. ${automationShellPath}/lib/ConfigureInstall.sh
. ${automationShellPath}/lib/WordSearch.sh
. ${automationShellPath}/lib/JetpackJourney.sh
. ${automationShellPath}/lib/PopQuiz.sh
. ${automationShellPath}/lib/Checkpoints.sh
. ${automationShellPath}/lib/PerkTV.sh
. ${automationShellPath}/lib/Screen.sh

lgHomeScreenActivity="com.lge.launcher2.Launcher"
usbSettingsActivity="com.android.settings.UsbSettings"

screenDensity="$(getprop ro.sf.lcd_density)"

lgFuelScreenXResolution=320
lgFuelScreenYResolution=480

wmSize=$(wm size)
wmSize=${wmSize:15}

actualScreenXResolution="${wmSize%x*}"
actualScreenYResolution="${wmSize#*x}"

inflateValue=1000000

checktime() {
	# extract hour from UNIX date
	local H=$(date +%H)

	# exit with exit code 1 to stop script execution
	if [ "$(( 10#$H ))" -ge "3" ] && [ "$(( 10#$H ))" -le "6" ]; then
		exit 1
	fi
}

# $1=originalValue, $2=deviation
plusOrMinus() {
	local originalValue=$1
	local deviation=$2
	
	local rand=$(randBetween 0 $((deviation * 2)))
	rand=$rand-$deviation
	
	echo $(($originalValue+$rand))
}

# $1=firstInt, $2=secondInt
randBetween() {
	local firstInt=$1
	local secondInt=$2
	
	local rand1=$(shuf -i $firstInt-$secondInt -n 1)
	
	echo $rand1
}

# $1=x
translateX() {
	let lgFuelX=$1*$inflateValue
	let xScreenPercent=$lgFuelX/$lgFuelScreenXResolution
	let actualX=$xScreenPercent*$actualScreenXResolution/$inflateValue
	
	echo $actualX
}

# $1=x
translateY() {
	let lgFuelY=$1*$inflateValue
	let yScreenPercent=$lgFuelY/$lgFuelScreenYResolution
	let actualY=$yScreenPercent*$actualScreenYResolution/$inflateValue
	
	echo $actualY
}

translateTouch() {
	local actualX=$(translateX $1)
	local actualY=$(translateY $2)
	
	input tap $actualX $actualY
}

advancedSwipe() {
	local x1=$(plusOrMinus $1 10)
	local y1=$(plusOrMinus $2 10)
	local x2=$(plusOrMinus $3 10)
	local y2=$(plusOrMinus $4 10)
	local duration=$5
	
	translateSwipe $x1 $y1 $x2 $y2 $duration
}

translateSwipe() {
	local x1=$(translateX $1)
	local y1=$(translateY $2)
	local x2=$(translateX $3)
	local y2=$(translateY $4)
	local duration=$5
	
	input touchscreen swipe $x1 $y1 $x2 $y2 $duration
}

normalTouch() {
	local x=$1
	local y=$2
	
	translateTouch $x $y
}

advancedTouch() {
	local x=$(plusOrMinus $1 5)
	local y=$(plusOrMinus $2 5)
	
	normalTouch $x $y
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

isScreenOn() {
	echo $(dumpsys power | grep mScreenOn= | grep -oE '(true|false)')
}

ensureScreenOn() {
	if [ $(isScreenOn) == false ]; then
		input keyevent KEYCODE_POWER
	fi
}

goHome() {
	input keyevent KEYCODE_HOME
}

launchDevice() {
	# Make sure it's on.
	ensureScreenOn
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