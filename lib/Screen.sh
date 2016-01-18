screenPackage="com.perk.screen"
screenMainActivity="com.perk.screen.LockActivity"
screenPressActivity="com.facebook.FacebookActivity"

phoneLimit=999

# $1=numLoops
doNCycles() {
	local i=1
	local n=$1
	while [ $i -ne $n ]
	do
		doCycle
		true $(( i++ ))
	done
}

phoneReachedLimit() {
	sh /data/Automation/ChangeAndroidId.sh
	sh /data/Automation/Automation/Automation.sh -l &
	exit 0
}

# $1=checkLimit
doCycle() {
	local checkLimit=$1
	
	# Start with phone off.  If it is on, then turn it off.
	ensureScreenOff
	
	echo "Screen is off. Turning on."
	input keyevent KEYCODE_POWER # wakeup
	sleep .5
	# Did facebook login popup when we are trying to swipe?
	input keyevent KEYCODE_BACK
	sleep .5
	
	if [ $checkLimit == true ]; then
		if [ $(getScreenPoints) -gt $phoneLimit ]; then
			phoneReachedLimit
		fi
	fi
	
	# Swipe
	advancedSwipe 152 438 304 438 400
	sleep 5
}

launchScreen() {
	echo "Launching Screen..."
	
	# Loop until killed from outside
	while :
	do	
		# Do ten swipes.
		doNCycles 10
		
		# Do a swipe, but check the point limit.
		doCycle true
	done
}