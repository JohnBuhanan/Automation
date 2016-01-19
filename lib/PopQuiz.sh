popQuizPackage="com.jutera.perkpopquiz.aphone"
popQuizMainActivity="com.jutera.perkpopquiz.SplashActivity"
popQuizPressActivity="com.jutera.perkpopquiz.LaunchActivity"

launchPopQuiz() {
	echo "Launching Pop Quiz"
	sleep 10
	boundedTouch $device 96 382 217 400
	sleep 2
	boundedTouch $device 45 281 209 303
	sleep 2
	boundedTouch $device 58 240 270 253
}