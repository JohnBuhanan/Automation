checkpointsPackage="com.checkpoints.app"
checkpointsMainActivity="com.checkpoints.app.ui.MainActivity"
checkpointsPressActivity="com.checkpoints.app.ui.MainActivity"
checkPointsLogName="checkpoints"

launchCheckpoints() {
	launchCheckpoints2
	
	while :
	do
		sleep 20
		checkPointsHealthCheck
	done
}

launchCheckpoints2() {
	echo "Launching Checkpoints"
	waitUntilTextFound "tab_videos"
	normalTouch 200 457
	waitUntilTextFound "play_all_button"
	normalTouch 80 140
}

checkPointsHealthCheck() {
	dumpScreen
	standardHealthCheck
	
	if [ $(isValueOnScreen "Unfortunately") == "true" ]; then
		logStuff $checkPointsLogName "Unfortunately checkpoints has stopped."
		restartTheWholeThing
	fi
	
	if [ $(isValueOnScreen "Can't play this video") == "true" ]; then
		logStuff $checkPointsLogName "Can't play this video."
		normalTouch 240 200
	fi
	
	if [ $(isValueOnScreen "text=\"X\"") == "true" ]; then
		logStuff $checkPointsLogName "Static ad."
		boundedTouch 430 0 480 50  ## Horizontal coordinates...
	fi
	
	
	if [ $(isValueOnScreen "Network Problem") == "true" ]; then
		logStuff $checkPointsLogName "Network problem."
		restartTheWholeThing
	fi
	
	if [ $(isValueOnScreen "tab_videos") == "true" ]; then
		restartTheWholeThing
	fi
	
	if [ $(isValueOnScreen "play_all_button") == "true" ]; then
		restartTheWholeThing
	fi
}