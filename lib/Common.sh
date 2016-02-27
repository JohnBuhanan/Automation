. ${automationShellPath}/lib/Logging.sh
. ${automationShellPath}/lib/TouchCommands.sh
. ${automationShellPath}/lib/Screen.sh
. ${automationShellPath}/lib/HotFixes.sh
. ${automationShellPath}/lib/ConfigureInstall.sh

. ${automationShellPath}/lib/WordSearch.sh
. ${automationShellPath}/lib/JetpackJourney.sh
. ${automationShellPath}/lib/PopQuiz.sh
. ${automationShellPath}/lib/Checkpoints.sh
. ${automationShellPath}/lib/PerkTV.sh
. ${automationShellPath}/lib/UnlockAndWin.sh

launch() {
	# checktime
	logStuff "automation" "Device launched."
	killAllApps
	sleep 3
	hotFixes
	sleep 1
	launchDevice
	wait
}

standardHealthCheck() {
	if [ $(getCurrentActivity) == $lgHomeScreenActivity ]; then
		launch
	fi
}

checktime() {
	# extract hour from UNIX date
	local H=$(date +%H)

	# exit with exit code 1 to stop script execution
	if [ "$(( 10#$H ))" -ge "3" ] && [ "$(( 10#$H ))" -le "6" ]; then
		exit 1
	fi
}

# $1=filePath, $2=beforeText, $3=afterText
grepValueInFile() {
	local filePath=$1
	local beforeText=$2
	local afterText=$3
	
	local text=$(grep -o ".*$afterText" $filePath)
	text=${text##*$beforeText}
	text=${text%$afterText*}
	
	echo $text
}

killLastSession() {
	# echo $$
	local file=/data/Automation/lastSessionPid
	local lastSessionPid=$(cat $file)
	kill -15 $lastSessionPid
	echo $$ > $file
}

killAllApps() {
	am force-stop $wordSearchPackage >/dev/null 2>&1 &
	am force-stop $jetpackJourneyPackage >/dev/null 2>&1 &
	am force-stop $jetpackJourneyApplicationError >/dev/null 2>&1 &
	am force-stop $popQuizPackage >/dev/null 2>&1 &
	am force-stop $perkTVLivePackage >/dev/null 2>&1 &
	am force-stop $checkpointsPackage >/dev/null 2>&1 &
	am force-stop $perkTVPackage >/dev/null 2>&1 &
	am force-stop $screenPackage >/dev/null 2>&1 &
	killLastSession
	wait
}

launchDevice() {
	# Make sure it's on.
	ensureScreenOn
	
	# Make sure it can reach internet.
	ensureWifiConnection
	
	# Make sure it's on home?
	goHome
	sleep 1
	# Click in top left corner.
	normalTouch 50 70
	sleep 10
	
	# See what is running.
	activity=$(getCurrentActivity)
	
    if [ "$activity" = "$checkpointsPressActivity" ]; then
        launchCheckpoints
		return
    fi
	
	if [ "$activity" = "$perkTVPressActivity" ]; then
        launchPerkTV
		return
    fi
	
	if [ "$activity" = "$wordSearchPressActivity" ]; then
        launchWordSearch
		return
    fi
	
	if [ "$activity" = "$popQuizPressActivity" ]; then
        launchPopQuiz
		return
    fi
	
	if [ "$activity" = "$jetpackJourneyPressActivity" ]; then
        launchJetpackJourney
		return
    fi
	
	if [ "$activity" = "$screenPressActivity" ]; then
        launchScreen
		return
    fi
}

# $1=device, $2=package, $3=activity
# launchApp() {
	# local device=$1
	# local package=$2
	# local activity=$3
	
	# adb -s $device shell am start -n "$package/$activity"
# }