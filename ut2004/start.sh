#!/bin/sh

GAMEDIR=/home/container
INIFILE=${GAMEDIR}/System/UT2004.ini
ADMINNAME='AdminName='${4}
ADMINPASS='AdminPassword='${5}
MUTATORS=${6}

## Gamemode Logic
DEATHMATCH='DM-Rankin?game=XGame.xDeathMatch'
LASTMANSTANDING='DM-Morpheus3?game=BonusPack.xLastManStandingGame'
TEAMDEATHMATCH='DM-Rankin?game=XGame.xTeamGame'
ONSLAUGHT='ONS-Torlan?game=Onslaught.ONSOnslaughtGame'
BOMBINGRUN='BR-Anubis?game=XGame.xBombingRun'
INVASION='ONS-Torlan?game=SkaarjPack.Invasion'
ASSAULT='DM-Antalus?UT2K4Assault.ASGameInfo'
DOUBLEDOM='DOM-SunTemple?game=xGame.xDoubleDom'
MUTANT='DM-Morpheus3?game=BonusPack.xMutantGame'
CTF='CTF-Orbital2?game=XGame.xCTFGame'


LOGDIR=${GAMEDIR}/logs
SERVER=${GAMEDIR}/System/ucc-bin
LOG=${GAMEDIR}/ut2004-server.log
RLOG=${GAMEDIR}/ut2004-restart.log
SLOG=ut2004-server.log
CACHERECORD=${GAMEDIR}/System/CacheRecords.ucl
CACHEBACKUP=${GAMEDIR}/System/CacheRecords.bak

# How many times to loop & restart if the server dies.  To disable looping,
# set this to 1.
LOOPS=4

#
# Check for one command line argument, which is a gametype.
#
if [ $# -lt 1 ]; then
	echo ""
	echo "Usage: $0 gametype"
	echo ""
	echo "Valid gametypes are:"
	echo ""
	echo "   deathmatch (dm)"
	echo "   lastmanstanding (lms)"
	echo "   teamdeathmatch (tdm)"
	echo "   onslaught (ons)"
	echo "   bombingrun (bomb)"
	echo "   invasion (inv)"
	echo "   assault (aslt)"
	echo "   doubledom (dd)"
	echo "   mutant (mut)"
	echo "   capturetheflag (ctf)"
	echo ""
	exit 1
else
	case $1 in 
		deathmatch|dm)		GAMETYPE=${DEATHMATCH} ;;
		lastmanstanding|lms)	GAMETYPE=${LASTMANSTANDING} ;;
		teamdeathmatch|tdm)	GAMETYPE=${TEAMDEATHMATCH} ;;
		onslaught|ons)		GAMETYPE=${ONSLAUGHT} ;;
		bombingrun|bomb)	GAMETYPE=${BOMBINGRUN} ;;
		invasion|inv)		GAMETYPE=${INVASION} ;;
        fraghouseinvasion|fhi)		GAMETYPE=${FHI} ;;
		assault|aslt)		GAMETYPE=${ASSAULT} ;;
		doubledom|dd)		GAMETYPE=${DOUBLEDOM} ;;
		mutant|mut)		GAMETYPE=${MUTANT} ;;
		capturetheflag|ctf)	GAMETYPE=${CTF} ;;
		*)	echo "$1 - invalid gametype."
			exit 1 ;;
	esac
fi

sed -i "/^Port=/s/Port=.*/Port=${2}/" "${INIFILE}"
sed -i "/^ListenPort=/s/ListenPort=.*/ListenPort=${3}/" "${INIFILE}"

echo "Starting ut2004 server"
cd ./System/
./ucc-bin server "${GAMETYPE}?${ADMINNAME}?${ADMINPASS}?${MUTATORS} -ini=${INIFILE} -nohomedir"
