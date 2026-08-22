#!/usr/bin/env sh

if [ -f ./.env ]; then
    set -a
    . ./.env
    set +a
fi

cp ./Insurgency/Saved/Config/LinuxServer/GameZombie.ini ./Insurgency/Saved/Config/LinuxServer/Game.ini
cp ./Insurgency/Saved/Config/LinuxServer/EngineZombie.ini ./Insurgency/Saved/Config/LinuxServer/Engine.ini

Insurgency/Binaries/Linux/InsurgencyServer-Linux-Shipping \
    Tell?Scenario=Scenario_Tell_Survival?MaxPlayers=6 \
    -ModDownloadTravelTo="Precinct?Scenario=Scenario_Precinct_Checkpoint_Security?Lighting=Night?Mutators=Big?MaxPlayers=6" \
    -MapCycle=MapCycleZombie.txt -SecurityCode=none -motd=MotdZombie -Mods -Port=27102 -QueryPort=27131 -NoEAC -GameStats \
    -mutators=Flashlight_Shadows,MapVoteLabels,MoreAmmoPlus,FullyLoaded,AdminCommands,JoinLeaveMessage,PingExt,StallCounter,ImprovedAI_2,WG3,Reloads,Bolts,Quickdraw,ZombiesLite,CapCount,Healthy,Canoeing \
    -GameStatsToken="${GAME_STATS_TOKEN}" -GSLTToken="${GSLT_TOKEN}" \
    -hostname="[Ten Four] Zombie 6vs96 (Gun Master, Waves)"