#!/bin/bash
set -e

SERVER_DIR="/home/steam/server"

echo "==> Checking for Insurgency: Sandstorm server updates..."

# print current user
echo "==> Current user: $(whoami)"

# print current working directory
echo "==> Current working directory: $(pwd)"

# print permissions of the server directory
echo "==> Permissions of the server directory:"
ls -ld "/home/steam/server"

gosu steam steamcmd \
    +force_install_dir "$SERVER_DIR" \
    +login anonymous \
    +app_update 581330 \
    +quit

echo "==> Insurgency: Sandstorm server is up to date."
echo "==> Starting server..."

cd "$SERVER_DIR"

# Only apply the timerslack tweak when TIMERSLACK_MODIO_AFTER is set
# (number of seconds to wait after server start before adjusting the
# ModioBackground thread's timer slack). If unset, skip it entirely.
if [ -n "${TIMERSLACK_MODIO_AFTER:-}" ]; then
(
    sleep "${TIMERSLACK_MODIO_AFTER}"
    echo "==> Timerslack Modio processes"
    sandstorm_modiobackground_pids="$( ps Hh -u "steam"  -o tid,comm | grep ModioBackground | grep --only-matching '[0-9]*' )"
    for pid in ${sandstorm_modiobackground_pids} ; do
        echo "==> ModioBackground PID: ${pid}"
        # Original timer delay:
        #    1000000   ns  = 1ms
        # Runs as root, so this needs CAP_SYS_NICE and works;
        # the game itself runs as the steam user below.
        echo 5000000000 > "/proc/${pid}/timerslack_ns"
    done
) &
fi

exec gosu steam ./start.sh