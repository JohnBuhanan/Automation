screenPackage="com.perk.screen"
screenMainActivity="com.perk.screen.LockActivity"
screenPressActivity="com.facebook.FacebookActivity"

launchScreen() {
	echo "Launching Screen..."
	
	# Loop until killed from outside
	while :
	do	
		if [ $(isScreenOn) == false ] ; then
			echo "Screen is off. Turning on."
			sleep 1
			input keyevent KEYCODE_POWER # wakeup
			sleep 2
			translateSwipe 150 434 304 434 750
			sleep 8
		else 
			echo "Screen is already on. Turning off."
			input keyevent KEYCODE_POWER # sleep
			sleep 2
		fi
	done
}