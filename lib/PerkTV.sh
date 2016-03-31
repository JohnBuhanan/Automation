perkTVPackage="com.juteralabs.perktv"
perkTVPressActivity="com.juteralabs.perktv.activities.WatchEarnOverlay"
perkTVLogName="perkTV"

launchPerkTV() {
	launchPerkTV2
	
	while :
	do
		sleep 20
		perkTVHealthCheck
	done
}

launchPerkTV2() {
	echo "Launching PerkTV"
	
	# Might be static ad.
	dumpScreen
	
	if [ $(isValueOnScreen "ib_fan_close") == "true" ]; then
		logStuff $perkTVLogName "Found static ad. Clicking ib_fan_close"
		normalTouch 304 56
		sleep 1
	fi
	
	# waitUntilTextFound "ib_fan_close"
	# normalTouch 304 56
	
	# Watch & Earn title
	waitUntilTextFound "Watch &amp; Earn"
	boundedTouch 55 160 108 203
	
	# Anastasia Date
	waitUntilTextFound "Anastasia Date"
	boundedTouch 34 101 299 216
}

perkTVHealthCheck() {
	dumpScreen
	standardHealthCheck
	
	if [ $(isValueOnScreen "ib_fan_close") == "true" ]; then
		logStuff $perkTVLogName "Found static ad. Clicking ib_fan_close"
		normalTouch 304 56
	fi
	
	# if [ $(isValueOnScreen "Can't play this video") == "true" ]; then
		# logStuff $checkPointsLogName "Can't play this video."
		# normalTouch 240 200
	# fi
}

# ib_fan_close