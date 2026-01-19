#!/bin/sh

# Define ANSI Color Codes for Pelican Console
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

GAMEDIR=/home/container
INIFILE=${GAMEDIR}/System/UT2004.ini

# Helper functions for colored output
log_info() { printf "${CYAN}%s${NC}\n" "$1"; }
log_setting() { printf "${YELLOW}%s${NC} ${GREEN}%s${NC}\n" "$1" "$2"; }
log_warn() { printf "${RED}%s${NC}\n" "$1"; }

log_info "Processing startup switches..."

# Default values
GAMEMODE="dm"
SERVER_PORT="7777"
WEB_PORT="8075"
ADMINNAME_VAL="admin"
ADMINPASS_VAL="changeme"
MUTATORS=""
MINPLAYERS="16"
MAXPLAYERS="16"
EXTRA_VAL=""

# Parse switches with safety checks to prevent shift errors
while [ "$#" -gt 0 ]; do
    case "$1" in
        -mode|-port|-webport|-admin|-pass|-mutator|-min|-max|-extra)
            # Assign the flag and then check if the next argument is a value
            FLAG="$1"
            # If the next argument exists and doesn't start with '-', it's a value
            if [ -n "$2" ] && [ "${2#-}" = "$2" ]; then
                VALUE="$2"
                shift 2
            else
                VALUE=""
                shift 1
            fi

            # Map the values to the correct variables
            case "$FLAG" in
                -mode)    GAMEMODE="$VALUE" ;;
                -port)    SERVER_PORT="$VALUE" ;;
                -webport) WEB_PORT="$VALUE" ;;
                -admin)   ADMINNAME_VAL="$VALUE" ;;
                -pass)    ADMINPASS_VAL="$VALUE" ;;
                -mutator) MUTATORS="$VALUE" ;;
                -min)     MINPLAYERS="$VALUE" ;;
                -max)     MAXPLAYERS="$VALUE" ;;
                -extra)   EXTRA_VAL="$VALUE" ;;
            esac
            ;;
        *)
            # Skip any arguments that don't match our flags
            shift 1
            ;;
    esac
done

# Use Environment Variables from Pelican Summary
S_NAME="${SERVER_NAME:-"A Gamers Grind Server"}"
S_MOTD="${MOTD:-"Welcome to A Gamers Grind"}"

## --- INI Injection ---

log_setting "Setting server name to:" "${S_NAME}"
sed -i "/^ServerName=/s/ServerName=.*/ServerName=${S_NAME}/" "${INIFILE}"

log_setting "Setting Admin Name to:" "${ADMINNAME_VAL}"
sed -i "/^AdminName=/s/AdminName=.*/AdminName=${ADMINNAME_VAL}/" "${INIFILE}"

log_info "Setting Admin Password..."
sed -i "/^AdminPassword=/s/AdminPassword=.*/AdminPassword=${ADMINPASS_VAL}/" "${INIFILE}"

log_setting "Setting MOTD to:" "${S_MOTD}"
sed -i "/^MessageOfTheDay=/s/MessageOfTheDay=.*/MessageOfTheDay=${S_MOTD}/" "${INIFILE}"

log_setting "Setting Server Port to:" "${SERVER_PORT}"
sed -i "/^Port=/s/Port=.*/Port=${SERVER_PORT}/" "${INIFILE}"

log_setting "Setting WebAdmin Port to:" "${WEB_PORT}"
sed -i "/^ListenPort=/s/ListenPort=.*/ListenPort=${WEB_PORT}/" "${INIFILE}"

## --- Gamemode Mapping ---
case ${GAMEMODE} in 
    deathmatch|dm)          URL='DM-Rankin?game=XGame.xDeathMatch' ;;
    lastmanstanding|lms)    URL='DM-Morpheus3?game=BonusPack.xLastManStandingGame' ;;
    teamdeathmatch|tdm)     URL='DM-Rankin?game=XGame.xTeamGame' ;;
    onslaught|ons)          URL='ONS-Torlan?game=Onslaught.ONSOnslaughtGame' ;;
    bombingrun|bomb)        URL='BR-Anubis?game=XGame.xBombingRun' ;;
    invasion|inv)           URL='ONS-Torlan?game=SkaarjPack.Invasion' ;;
    assault|aslt)           URL='DM-Antalus?UT2K4Assault.ASGameInfo' ;;
    doubledom|dd)           URL='DOM-SunTemple?game=xGame.xDoubleDom' ;;
    mutant|mut)             URL='DM-Morpheus3?game=BonusPack.xMutantGame' ;;
    capturetheflag|ctf)     URL='CTF-FaceClassic?game=XGame.xCTFGame' ;;
    *)  log_warn "Invalid gametype: ${GAMEMODE}"; exit 1 ;;
esac

## --- Server Execution ---
log_info "Launching UT2004 Dedicated Server..."
cd ./System/
./ucc-bin server "${URL}?AdminName=${ADMINNAME_VAL}?AdminPassword=${ADMINPASS_VAL}?mutator=${MUTATORS}?MinPlayers=${MINPLAYERS}?MaxPlayers=${MAXPLAYERS}?${EXTRA_VAL}" -ini=${INIFILE} -nohomedir
