popQuizPackage="com.jutera.perkpopquiz.aphone"
popQuizMainActivity="com.jutera.perkpopquiz.SplashActivity"
popQuizPressActivity="com.jutera.perkpopquiz.LaunchActivity"
popQuizLogName="popQuiz"

launchPopQuiz() {
	launchPopQuiz2
	
	while :
	do
		sleep 20
		popQuizHealthCheck
	done
}

launchPopQuiz2() {
	echo "Launching Pop Quiz"
	waitUntilTextFound "WELCOME&#10;BACK!"
	boundedTouch $device 96 382 217 400
	sleep 2
	boundedTouch $device 45 281 209 303
	waitUntilTextFound "Play Solo"
	boundedTouch $device 58 240 270 253
}

popQuizHealthCheck() {
	dumpScreen
	local currentActivity=$(getCurrentActivity)
	standardHealthCheck
	
	if [ $currentActivity == "com.jutera.perkpopquiz.FANActivity" ]; then
		logStuff $popQuizLogName "Closing static ad."
		normalTouch 305 19
	fi
	
	if [ $currentActivity == "com.jutera.perkpopquiz.LaunchActivity" ]; then
		logStuff $popQuizLogName "Errored back to welcome screen 1."
		restartTheWholeThing
	fi
	
	if [ $(isValueOnScreen "WELCOME&#10;BACK!") == "true" ]; then
		logStuff $checkPointsLogName "Errored back to welcome screen 2."
		restartTheWholeThing
	fi
	
	# if [ $(isValueOnScreen "No Internet") == "true" ]; then
		# logStuff $checkPointsLogName "WiFi Outage."
		# restartTheWholeThing
	# fi
}