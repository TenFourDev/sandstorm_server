#!/usr/bin/env sh

if [ -f ./.env ]; then
    set -a
    . ./.env
    set +a
fi

cp ./Insurgency/Saved/Config/LinuxServer/_Game.ini ./Insurgency/Saved/Config/LinuxServer/Game.ini
cp ./Insurgency/Saved/Config/LinuxServer/_Engine.ini ./Insurgency/Saved/Config/LinuxServer/Engine.ini

Insurgency/Binaries/Linux/InsurgencyServer-Linux-Shipping \
    Tell?Scenario=Scenario_Tell_Survival?Lighting=Night?MaxPlayers=5 \
    -ModDownloadTravelTo="Precinct?Scenario=Scenario_Precinct_Checkpoint_Security?Lighting=Night?MaxPlayers=5?Mutators=Mid" \
    -MapCycle=MapCycleZombie.txt -SecurityCode=none -motd=MotdZombie -Mods -Port=27103 -QueryPort=27132 -NoEAC -GameStats \ 
    -mutators=Flashlight_Shadows,MapVoteLabels,MoreAmmoPlus,MoreAmmo,FullyLoaded,AdminCommands,JoinLeaveMessage,PingExt,StallCounter,ImprovedAI_2,Reloads,Bolts,Quickdraw,ZombiesLite,CapCount,Canoeing,AwardWaves \
    -GameStatsToken="${GAME_STATS_TOKEN}" -GSLTToken="${GSLT_TOKEN_ZOMBIE}" \
    -hostname="[Ten Four] Zombie 4vs40 (Gun Master, Waves)"