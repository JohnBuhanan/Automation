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
	
	if [ $(isValueOnScreen "Can't play this video") == "true" ]; then
		logStuff $checkPointsLogName "Can't play this video."
		normalTouch 240 200
	fi
	
	if [ $(isValueOnScreen "Network Problem") == "true" ]; then
		logStuff $checkPointsLogName "Network problem."
		normalTouch 167 281
	fi
	
	if [ $(isValueOnScreen "tab_videos") == "true" ]; then
		launch
	fi
	
	if [ $(isValueOnScreen "play_all_button") == "true" ]; then
		launch
	fi
}