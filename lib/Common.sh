. ${automationShellPath}/lib/ConfigureInstall.sh
. ${automationShellPath}/lib/WordSearch.sh
. ${automationShellPath}/lib/JetpackJourney.sh
. ${automationShellPath}/lib/PopQuiz.sh
. ${automationShellPath}/lib/Checkpoints.sh
. ${automationShellPath}/lib/PerkTV.sh

lgHomeScreenActivity="com.lge.launcher2.Launcher"
usbSettingsActivity="com.android.settings.UsbSettings"

checktime() {
	# extract hour from UNIX date
	local H=$(date +%H)

	# exit with exit code 1 to stop script execution
	if [ "$(( 10#$H ))" -ge "3" ] && [ "$(( 10#$H ))" -le "6" ]; then
		exit 1
	fi
}

advancedTouch() {
	local x=$1
	local y=$2
	local rand1=$(shuf -i 0-10 -n 1)-5
	local rand2=$(shuf -i 0-10 -n 1)-5
	
	normalTouch $(( $x+$rand1 )) $(( $y+$rand2 ))
}

normalTouch() {
	local x=$1
	local y=$2
	
	input tap $x $y
}

boundedTouch() {
	local x1=$1
	local y1=$2
	local x2=$3
	local y2=$4
	
	local x=$(shuf -i $x1-$x2 -n 1)
	local y=$(shuf -i $y1-$y2 -n 1)
	
	normalTouch $x $y
}

# $1=device
getCurrentActivity() {
	local activity=$(dumpsys window windows | awk -F '/' '/mCurrentFocus=/ { gsub(/\}/,""); gsub(/\r/,""); printf("%s",$2) }')
	echo $activity
}

# $1=device, $2=package, $3=activity
launchApp() {
	local device=$1
	local package=$2
	local activity=$3
	
	adb -s $device shell am start -n "$package/$activity"
}

killAllApps() {
	am force-stop $wordSearchPackage >/dev/null 2>&1 &
	am force-stop $jetpackJourneyPackage >/dev/null 2>&1 &
	am force-stop $jetpackJourneyApplicationError >/dev/null 2>&1 &
	am force-stop $popQuizPackage >/dev/null 2>&1 &
	am force-stop $perkTVLivePackage >/dev/null 2>&1 &
	am force-stop $checkpointsPackage >/dev/null 2>&1 &
	am force-stop $perkTVPackage >/dev/null 2>&1 &
	wait
}

launchDevice() {
	# Make sure it's on home?
	input keyevent KEYCODE_HOME
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
}