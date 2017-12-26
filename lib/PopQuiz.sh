popQuizPackage="com.jutera.perkpopquiz.aphone"
popQuizSplashActivity="com.jutera.perkpopquiz.SplashActivity"
popQuizMainActivity="com.jutera.perkpopquiz.WelcomeBackActivity"
popQuizPressActivity="com.jutera.perkpopquiz.LaunchActivity"
popQuizLogName="popQuiz"

launchPopQuiz() {
	launchPopQuiz2
}

launchPopQuiz2() {
	echo "Launching Pop Quiz"
	
	waitUntilTextFound "WELCOME BACK"
	boundedTouch $device 70 344 252 366
	sleep 2
	
	boundedTouch $device 22 233 40 257
	sleep 2
	boundedTouch $device 18 92 49 117
	
	waitUntilTextFound "Play Solo"
	boundedTouch $device 82 284 228 297
}

clearCachePopQuiz() {
	rm -r /data/data/com.jutera.perkpopquiz.aphone/app_webview
	rm -r /data/data/com.jutera.perkpopquiz.aphone/cache
	rm -r /data/data/com.jutera.perkpopquiz.aphone/databases
	rm -r /data/data/com.jutera.perkpopquiz.aphone/files
	rm -r /data/data/com.jutera.perkpopquiz.aphone/code_cache
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
		logStuff $popQuizLogName "Errored back to welcome screen 2."
		restartTheWholeThing
	fi
	
	if [ $(isValueOnScreen "Unfortunately, Perk") == "true" ]; then
		# [160,259][304,307]
		logStuff $popQuizLogName "Unfortunately..."
		normalTouch 232 283
		sleep 2
		restartTheWholeThing
	fi
	
	if [ $(isValueOnScreen "Perk Pop Quiz isn't responding. Do you want to close it?") == "true" ]; then
		# [160,259][304,307]
		logStuff $popQuizLogName "Perk Pop Quiz isn't responding. Do you want to close it?"
		# [208,259][304,307]
		normalTouch 256 283
		sleep 2
		restartTheWholeThing
	fi
}
