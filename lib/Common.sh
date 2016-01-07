. ${automationShellPath}/lib/ConfigureInstall.sh
. ${automationShellPath}/lib/WordSearch.sh
. ${automationShellPath}/lib/JetpackJourney.sh
. ${automationShellPath}/lib/PopQuiz.sh
. ${automationShellPath}/lib/Checkpoints.sh
. ${automationShellPath}/lib/PerkTV.sh

lgHomeScreenActivity="com.lge.launcher2.Launcher"
usbSettingsActivity="com.android.settings.UsbSettings"

screenDensity="$(getprop ro.sf.lcd_density)"

lgFuelScreenXResolution=320
lgFuelScreenYResolution=480

wmSize=$(wm size)
wmSize=${wmSize:15}

actualScreenXResolution="${wmSize%x*}"
actualScreenYResolution="${wmSize#*x}"

checktime() {
	# extract hour from UNIX date
	local H=$(date +%H)

	# exit with exit code 1 to stop script execution
	if [ "$(( 10#$H ))" -ge "3" ] && [ "$(( 10#$H ))" -le "6" ]; then
		exit 1
	fi
}

updateAndRelaunch() {
	local gitDateSeconds=$1
	echo NEW VERSION AVAILABLE! UPDATING!
	# Do update
	sh $automationPath/UpdateAutomation.sh
	# Log last update time of git download.
	echo $gitDateSeconds > $automationPath/updatedAt
	# Relaunch Automation
	sh $automationShellPath/Automation.sh -l &
	exit 1
}

getGitDate() {
	local updatedAtJson=$(curl -k "https://api.github.com/repos/johnbuns/Automation" | grep -o "\"pushed_at\": \".*\",")
	
	updatedAtJson="${updatedAtJson:15}"
	updatedAtJson="${updatedAtJson/Z\",/}"
	updatedAtJson="${updatedAtJson/T/ }"
	
	echo $(/system/xbin/date --date="${updatedAtJson}" +%s)
}

checkForUpdates() {
	# Curl on github api. Get the updated_at field
	local gitDateSeconds=$(getGitDate)
	
	local updatedAtFile=${automationPath}/updatedAt
	
	# Check for updatedAt file.
	if [ -e "$updatedAtFile" ]; then
		echo FILE EXISTS!
		
		# Read the number of seconds from it.
		local fileDateSeconds=$(cat $updatedAtFile)
		
		# Current version is out of date if number of seconds are less.
		if [ $gitDateSeconds -gt $fileDateSeconds ]; then
			updateAndRelaunch $gitDateSeconds
		fi
	else
		echo FILE DOES NOT EXIST!
		updateAndRelaunch $gitDateSeconds
	fi
}

advancedTouch() {
	local x=$1
	local y=$2
	local rand1=$(shuf -i 0-10 -n 1)-5
	local rand2=$(shuf -i 0-10 -n 1)-5
	
	normalTouch $(( $x+$rand1 )) $(( $y+$rand2 ))
}

translateTouch() {
	local inflate=1000000
	
	let lgFuelX=$1*$inflate
	let lgFuelY=$2*$inflate
	
	let xScreenPercent=$lgFuelX/$lgFuelScreenXResolution
	let yScreenPercent=$lgFuelY/$lgFuelScreenYResolution
	
	let actualX=$xScreenPercent*$actualScreenXResolution/$inflate
	
	let actualY=$yScreenPercent*$actualScreenYResolution/$inflate
	
	input tap $actualX $actualY
}

normalTouch() {
	local x=$1
	local y=$2
	
	translateTouch $x $y
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