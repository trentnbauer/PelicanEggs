#!/bin/sh

# Define ANSI Color Codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

GAMEDIR=/home/container
INIFILE=${GAMEDIR}/System/UT2004.ini

echo -e "${CYAN}Importing variables from startup command...${NC}"

# Basic Variables from positional arguments
ADMINNAME_VAL=${4}
ADMINPASS_VAL=${5}
MUTATORS=${6}
MINPLAYERS=${7}
MAXPLAYERS=${8}
EXTRA=${9}

# Environment Variables from Pelican Egg
S_NAME="${SERVER_NAME}"
S_MOTD="${MOTD}"

## --- INI Injection and Activity Logging ---

echo -e "${YELLOW}Setting server name to:${NC} ${GREEN}${S_NAME}${NC}"
sed -i "/^ServerName=/s/ServerName=.*/ServerName=${S_NAME}/" "${INIFILE}"

echo -e "${YELLOW}Setting Admin Name to:${NC} ${GREEN}${ADMINNAME_VAL}${NC}"
sed -i "/^AdminName=/s/AdminName=.*/AdminName=${ADMINNAME_VAL}/" "${INIFILE}"

echo -e "${YELLOW}Setting Admin Password...${NC}"
sed -i "/^AdminPassword=/s/AdminPassword=.*/AdminPassword=${ADMINPASS_VAL}/" "${INIFILE}"

echo -e "${YELLOW}Setting MOTD to:${NC} ${GREEN}${S_MOTD}${NC}"
sed -i "/^MessageOfTheDay=/s/MessageOfTheDay=.*/MessageOfTheDay=${S_MOTD}/" "${INIFILE}"

echo -e "${YELLOW}Setting Server Port to:${NC} ${GREEN}${2}${NC}"
sed -i "/^Port=/s/Port=.*/Port=${2}/" "${INIFILE}"

echo -e "${YELLOW}Setting WebAdmin Port to:${NC} ${GREEN}${3}${NC}"
sed -i "/^ListenPort=/s/ListenPort=.*/ListenPort=${3}/" "${INIFILE}"

## --- Gamemode Logic ---
DEATHMATCH='DM-Rankin?game=XGame.xDeathMatch'
LASTMANSTANDING='DM-Morpheus3?game=BonusPack.xLastManStandingGame'
TEAMDEATHMATCH='DM-Rankin?game=XGame.xTeamGame'
ONSLAUGHT='ONS-Torlan?game=Onslaught.ONSOnslaughtGame'
BOMBINGRUN='BR-Anubis?game=XGame.xBombingRun'
INVASION='ONS-Torlan?game=SkaarjPack.Invasion'
ASSAULT='AS-Mothership?UT2K4Assault.ASGameInfo'
DOUBLEDOM='DOM-SunTemple?game=xGame.xDoubleDom'
MUTANT='DM-Morpheus3?game=BonusPack.xMutantGame'
CTF='CTF-FaceClassic?game=XGame.xCTFGame'

if [ $# -lt 1 ]; then
    echo -e "${YELLOW}Usage: $0 gametype${NC}"
    exit 1
else
    case $1 in 
        deathmatch|dm)          GAMETYPE=${DEATHMATCH} ;;
        lastmanstanding|lms)    GAMETYPE=${LASTMANSTANDING} ;;
        teamdeathmatch|tdm)     GAMETYPE=${TEAMDEATHMATCH} ;;
        onslaught|ons)          GAMETYPE=${ONSLAUGHT} ;;
        bombingrun|bomb)        GAMETYPE=${BOMBINGRUN} ;;
        invasion|inv)           GAMETYPE=${INVASION} ;;
        assault|aslt)           GAMETYPE=${ASSAULT} ;;
        doubledom|dd)           GAMETYPE=${DOUBLEDOM} ;;
        mutant|mut)             GAMETYPE=${MUTANT} ;;
        capturetheflag|ctf)     GAMETYPE=${CTF} ;;
        *)  echo -e "${YELLOW}$1 - invalid gametype.${NC}"
            exit 1 ;;
    esac
fi

## --- Server Execution ---
echo -e "${CYAN}Finalizing startup and launching ucc-bin...${NC}"
cd ./System/
./ucc-bin server "${GAMETYPE}?AdminName=${ADMINNAME_VAL}?AdminPassword=${ADMINPASS_VAL}?mutator=${MUTATORS}?MinPlayers=${MINPLAYERS}?MaxPlayers=${MAXPLAYERS}?${EXTRA}" -ini=${INIFILE} -nohomedir
