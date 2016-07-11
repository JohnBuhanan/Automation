perkTVPackage="com.juteralabs.perktv"
perkTVPressActivity="com.juteralabs.perktv.activities.WatchEarnOverlay"
perkTVLogName="perkTV"
perkTVHealthCheckLogName="perkTVHealthCheck"

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
	
	sleep 10
	
	# Might be static ad.  But might not?
	dumpScreen
	
	if [ $(isValueOnScreen "ib_fan_close") == "true" ]; then
		logStuff $perkTVLogName "ib_fan_close"
		normalTouch 304 56
		sleep 1
	fi
	
	# Watch & Earn title
	waitUntilTextFound "Watch &amp; Earn"
	logStuff $perkTVLogName "Watch &amp; Earn"
	boundedTouch 55 160 108 203
	
	# Anastasia Date
	waitUntilTextFound "Anastasia Date"
	logStuff $perkTVLogName "Anastasia Date"
	boundedTouch 34 101 299 216
}

clearCachePerkTV() {
	rm -r /data/data/com.juteralabs.perktv/cache
	rm -r /data/data/com.juteralabs.perktv/files
	rm -r /data/data/com.juteralabs.perktv/code_cache
	rm -r /data/data/com.juteralabs.perktv/databases
}

perkTVHealthCheck() {
	dumpScreen
	standardHealthCheck
	
	if [ $(isValueOnScreen "ib_fan_close") == "true" ]; then
		logStuff $perkTVHealthCheckLogName "Back on the start screen with the static ad."
		restartTheWholeThing
		return
	fi
	
	if [ $(isValueOnScreen "Watch &amp; Earn") == "true" ]; then
		logStuff $perkTVHealthCheckLogName "Back on the start screen without the static ad."
		restartTheWholeThing
		return
	fi
	
	if [ $(isValueOnScreen "text=\"X\"") == "true" ]; then
		logStuff $perkTVHealthCheckLogName "Found static ad to close."
		normalTouch 455 25
		return
	fi
}