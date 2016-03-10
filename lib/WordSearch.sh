wordSearchPackage="com.perk.wordsearch.aphone"
wordSearchMainActivity="com.perk.wordsearch.aphone.WordSearch"
wordSearchPressActivity="com.perk.wordsearch.aphone.HomeScreen"
wordSearchLogName="wordSearch"

launchWordSearch() {
	launchWordSearch2
	
	while :
	do
		sleep 20
		wordSearchHealthCheck
	done
}

launchWordSearch2() {
	echo "Launching Word Search"
	waitUntilTextFound "QUICKPLAY"
	boundedTouch $device 47 216 130 298
	waitUntilTextFound "2 words"
	boundedTouch $device 45 217 150 296
}

wordSearchHealthCheck() {
	dumpScreen
	# local currentActivity=$(getCurrentActivity)
	standardHealthCheck
	
	if [ $(isValueOnScreen "QUICKPLAY") == "true" ]; then
		logStuff $wordSearchLogName "Errored back to main screen."
		restartTheWholeThing
	fi
	
	if [ $(isValueOnScreen "No Connection") == "true" ]; then
		logStuff $wordSearchLogName "No Connection."
		restartTheWholeThing
	fi
}