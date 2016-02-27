
lgHomeScreenActivity="com.lge.launcher2.Launcher"
usbSettingsActivity="com.android.settings.UsbSettings"

dumpPath="/sdcard/window_dump.xml"

# $1=beforeText, $2=afterText
grepValueOnScreen() {
	dumpScreen
	
	local value=$(grepValueInFile $dumpPath "$beforeText" "$afterText")
	
	echo value
}

# $1=valueToFind
isValueOnScreen() {
	local valueToFind=$1
	local foundValue=$(grep -o "$valueToFind" $dumpPath)
	
	if [ "$foundValue" == "$valueToFind" ]; then
		echo "true"
	else
		echo "false"
	fi
}

dumpScreen() {
	/system/bin/uiautomator dump > /dev/null 2>&1
}

# $1=textToFind
waitUntilTextFound() {
	local textToFind=$1
	local numberOfAttempts=0
	local attemptLimit=60
	
	while :
	do	
		dumpScreen
		if [ $(isValueOnScreen "$textToFind") == "true" ]; then
			break
		fi
		echo "Looping..."
		
		numberOfAttempts=$((numberOfAttempts + 1))
		if [ $numberOfAttempts -gt $attemptLimit ]; then
			break
		fi
		sleep 2
	done
	echo "DONE!"
}

# $1=device
getCurrentActivity() {
	local activity=$(dumpsys window windows | awk -F '/' '/mCurrentFocus=/ { gsub(/\}/,""); gsub(/\r/,""); printf("%s",$2) }')
	echo $activity
}

isScreenOn() {
	echo $(dumpsys power | grep mScreenOn= | grep -oE '(true|false)')
}

ensureScreenOn() {
	ensureScreen true
}

ensureScreenOff() {
	ensureScreen false
}

# $1=onOff
ensureScreen() {
	if [ $(isScreenOn) != $1 ]; then
		input keyevent KEYCODE_POWER
		sleep 1
	fi
}