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
    -ModDownloadTravelTo="Precinct?Scenario=Scenario_Precinct_Checkpoint_Security?Lighting=Night?MaxPlayers=5?Mutators=Healthy" \
    -MapCycle=MapCycleZombie.txt -SecurityCode=none -motd=MotdZombieFrenzy -Mods -Port=27104 -QueryPort=27133 -NoEAC -GameStats \
    -mutators=Flashlight_Shadows,MapVoteLabels,MoreAmmoPlus,MoreAmmo,FullyLoaded,AdminCommands,JoinLeaveMessage,PingExt,StallCounter,ImprovedAI_2,Reloads,Bolts,Quickdraw,ZombiesLite,CapCount,Canoeing,AwardWaves \
    -GameStatsToken="${GAME_STATS_TOKEN}" -GSLTToken="${GSLT_TOKEN_ZOMBIE_FRENZY}" \
    -hostname="[Ten Four] Zombie Frenzy 4vs84 (Gun Master, Waves)"