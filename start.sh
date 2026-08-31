#!/usr/bin/env sh

if [ -f ./.env ]; then
    set -a
    . ./.env
    set +a
fi

cp ./Insurgency/Saved/Config/LinuxServer/GameCheckpoint.ini ./Insurgency/Saved/Config/LinuxServer/Game.ini
cp ./Insurgency/Saved/Config/LinuxServer/EngineCheckpoint.ini ./Insurgency/Saved/Config/LinuxServer/Engine.ini

Insurgency/Binaries/Linux/InsurgencyServer-Linux-Shipping \
    Tell?Scenario=Scenario_Tell_Survival?MaxPlayers=10 \
    -ModDownloadTravelTo="Precinct?Scenario=Scenario_Precinct_Checkpoint_Security?Mutators=Diff7?MaxPlayers=10" \
    -MapCycle=MapCycle.txt -Mods -SecurityCode=none -Port=27102 -QueryPort=27131 -NoEAC -GameStats \
    -mutators=Flashlight_Shadows,MapVoteLabels,MoreAmmoPlus,FullyLoaded,AdminCommands,JoinLeaveMessage,PingExt,NoRestrictedArea,StallCounter,ImprovedAI,CapCount,Reloads,Bolts,Canoeing,AwardWaves \
    -GameStatsToken="${GAME_STATS_TOKEN}" -GSLTToken="${GSLT_TOKEN}" \
    -hostname="[Ten Four] Checkpoint 8vs36 0.8-1.0 (Gun Master, Waves)"