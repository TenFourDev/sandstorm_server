#!/usr/bin/env sh

if [ -f ./.env ]; then
    set -a
    . ./.env
    set +a
fi

Insurgency/Binaries/Linux/InsurgencyServer-Linux-Shipping \
    Tell?Scenario=Scenario_Tell_Survival?MaxPlayers=10 \
    -ModDownloadTravelTo="Precinct?Scenario=Scenario_Precinct_Checkpoint_Security?Lighting=Night?Mutators=Big?MaxPlayers=10" \
    -MapCycle=MapCycleZombie.txt -SecurityCode=none -motd=MotdZombie -Mods -Port=27102 -QueryPort=27131 -NoEAC -GameStats \
    -mutators=Flashlight_Shadows,MapVoteLabels,MoreAmmoPlus,FullyLoaded,AdminCommands,JoinLeaveMessage,PingExt,StallCounter,ImprovedAI_2,WG3,MoreAmmo,Reloads,Bolts,Quickdraw,ZombiesLite \
    -GameStatsToken="${GAME_STATS_TOKEN}" -GSLTToken="${GSLT_TOKEN}" \
    -hostname="[Ten Four] Zombie 8vs96 (Gun Master, Waves)"