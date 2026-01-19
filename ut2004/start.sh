## --- Gamemode Mapping ---
case ${GAMEMODE} in 
    deathmatch|dm)          URL='DM-Rankin?game=XGame.xDeathMatch' ;;
    lastmanstanding|lms)    URL='DM-Morpheus3?game=BonusPack.xLastManStandingGame' ;;
    teamdeathmatch|tdm)     URL='DM-Rankin?game=XGame.xTeamGame' ;;
    onslaught|ons)          URL='ONS-Torlan?game=Onslaught.ONSOnslaughtGame' ;;
    bombingrun|bomb)        URL='BR-Anubis?game=XGame.xBombingRun' ;;
    invasion|inv)           URL='ONS-Torlan?game=SkaarjPack.Invasion' ;;
    assault|aslt)           URL='AS-Mothership?UT2K4Assault.ASGameInfo' ;;
    doubledom|dd)           URL='DOM-SunTemple?game=xGame.xDoubleDom' ;;
    mutant|mut)             URL='DM-Morpheus3?game=BonusPack.xMutantGame' ;;
    capturetheflag|ctf)     URL='CTF-FaceClassic?game=XGame.xCTFGame' ;;
    *)  log_warn "Invalid gametype: ${GAMEMODE}"; exit 1 ;;
esac
