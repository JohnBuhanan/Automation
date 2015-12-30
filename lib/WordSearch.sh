wordSearchPackage="com.perk.wordsearch.aphone"
wordSearchMainActivity="com.perk.wordsearch.aphone.WordSearch"
wordSearchPressActivity="com.perk.wordsearch.aphone.HomeScreen"

launchWordSearch() {
	echo "Launching Word Search"
	boundedTouch $device 47 216 130 298
	sleep 5
	boundedTouch $device 218 217 296 296
}