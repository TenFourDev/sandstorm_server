# Pick one random entry from a MapCycle*.txt file and emit a -ModDownloadTravelTo value.
# Usage:
#   awk -f random_map.awk -v seed=$$ -v maxplayers=10 -v mapfile=ScenarioMap.txt MapCycle.txt
#   awk -f random_map.awk -v seed=$$ -v maxplayers=5 -v mapfile=ScenarioMap.txt MapCycleZombie.txt

BEGIN {
    if (retries == "") retries = 3
    if (seed != "") srand(seed); else srand()
    if (mapfile == "") mapfile = "ScenarioMap.txt"

    while ((getline line < mapfile) > 0) {
        if (line ~ /^[[:space:]]*(#|$)/) continue

        tmp = line
        sub(/^[[:space:]]+/, "", tmp)
        if (tmp == "") continue

        n = split(tmp, kv, "=")
        if (n < 2) continue

        key = trim(kv[1])
        val = kv[2]
        for (i = 3; i <= n; i++) val = val "=" kv[i]
        val = trim(val)

        if (key == "") continue
        if (substr(key, 1, 1) == "!") exact_alias[substr(key, 2)] = val
        else map_alias[key] = val
    }
    close(mapfile)
}

function trim(s) {
    sub(/^[[:space:]]+/, "", s)
    sub(/[[:space:]]+$/, "", s)
    return s
}

function contains(m, accept, n, i, v) {
    if (accept == "") return 1
    n = split(m, v, ",")
    for (i = 1; i <= n; i++) if (trim(v[i]) == accept) return 1
    return 0
}

function strip(m, accept, n, i, v, out, first, value) {
    if (accept == "") return m
    n = split(m, v, ",")
    out = ""
    first = 1
    for (i = 1; i <= n; i++) {
        value = trim(v[i])
        if (value == "" || value == accept) continue
        if (!first) out = out ","
        out = out value
        first = 0
    }
    return out
}

function extract(line, field, prefix, pos, rest, end_idx) {
    prefix = field "=\""
    pos = index(line, prefix)
    if (pos == 0) return ""

    rest = substr(line, pos + length(prefix))
    end_idx = index(rest, "\"")
    if (end_idx == 0) return ""
    return substr(rest, 1, end_idx - 1)
}

function resolve(s, k, t) {
    for (k in exact_alias) if (s == k) return exact_alias[k]
    for (k in map_alias) if (index(s, k) > 0) return map_alias[k]

    t = s
    sub(/^Scenario_/, "", t)
    sub(/_Checkpoint.*$/, "", t)
    sub(/_Survival.*$/, "", t)
    sub(/_FFA.*$/, "", t)
    sub(/_Insurgents.*$/, "", t)
    sub(/_Security.*$/, "", t)
    sub(/_CS.*$/, "", t)

    return t == "" ? s : t
}

function emit_travel(line, s, l, o, muts, map_name, travel, mut_pos, mut_rest, end_idx) {
    s = extract(line, "Scenario")
    if (s == "") return ""

    l = extract(line, "Lighting")
    o = extract(line, "Options")
    map_name = resolve(s)
    travel = map_name "?Scenario=" s

    if (l != "") travel = travel "?Lighting=" l
    if (maxplayers != "") travel = travel "?MaxPlayers=" maxplayers

    mut_pos = index(o, "mutators=")
    if (mut_pos > 0) {
        mut_rest = substr(o, mut_pos + length("mutators="))
        end_idx = index(mut_rest, "?")
        if (end_idx == 0) end_idx = index(mut_rest, "&")
        if (end_idx == 0) end_idx = length(mut_rest) + 1
        muts = trim(substr(mut_rest, 1, end_idx - 1))

        if (acceptmutator != "") {
            if (!contains(muts, acceptmutator)) return ""
            muts = strip(muts, acceptmutator)
            if (muts == "") return ""
        }
        travel = travel "?Mutators=" muts
    } else if (acceptmutator != "") {
        return ""
    }
    return travel
}

/^[[:space:]]*$/ { next }
{
    if (test == "1") {
        travel = emit_travel($0)
        if (travel != "") print travel
        next
    }

    if (acceptmutator != "") {
        if (index($0, "mutators=") == 0) next
        muts = substr($0, index($0, "mutators=") + length("mutators="))
        end_idx = index(muts, "?")
        if (end_idx == 0) end_idx = index(muts, "&")
        if (end_idx == 0) end_idx = length(muts) + 1
        muts = trim(substr(muts, 1, end_idx - 1))
        if (!contains(muts, acceptmutator)) next
    }

    total_lines++
    raw_lines[total_lines] = $0
}

END {
    if (test == "1") exit 0
    if (total_lines == 0) {
        print "No valid map cycle entries were found." > "/dev/stderr"
        exit 1
    }

    for (attempt = 1; attempt <= retries; attempt++) {
        idx = int(rand() * total_lines) + 1
        travel = emit_travel(raw_lines[idx])
        if (travel != "") {
            print travel
            exit 0
        }
    }

    print "No valid map cycle entries were found." > "/dev/stderr"
    exit 1
}
