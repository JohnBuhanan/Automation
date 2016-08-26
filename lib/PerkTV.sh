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
	
	# Static ad.
	# waitUntilTextFound "ib_fan_close"
	# logStuff $perkTVLogName "ib_fan_close"
	# normalTouch 304 56
	# sleep 2
	
	# Check for update?
	dumpScreen
	if [ $(isValueOnScreen "UPDATE") == "true" ]; then
		updatePerkTV
	fi
	
	
	# Watch & Earn title
	waitUntilTextFound "Watch &amp; Earn"
	logStuff $perkTVLogName "Watch &amp; Earn"
	boundedTouch 55 160 108 203
	
	# We used to hunt for Anastasia Date specifically, but now we hunt for video thumbnails.
	waitUntilTextFound "sv_movieTrailers"
	logStuff $perkTVLogName "sv_movieTrailers"
	boundedTouch 34 101 299 216
}

updatePerkTV() {
	logStuff $perkTVLogName "Clicking UPDATE in PerkTV app"
	boundedTouch 20 362 300 402
		
	waitUntilTextFound "Downloads"
	logStuff $perkTVLogName "Clicking UPDATE on Google play store"
	boundedTouch 165 283 304 317
	
	waitUntilTextFound "ACCEPT"
	logStuff $perkTVLogName "Clicking Accept in Google Play store"
	boundedTouch 168 337 288 373
	
	# Should be installed now. Wait a bit and restart.
	waitUntilTextFound "OPEN"
	restartTheWholeThing
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
	
	if [ $(isValueOnScreen "sv_movieTrailers") == "true" ]; then
		logStuff $perkTVHealthCheckLogName "Back on the video thumbnail section."
		boundedTouch 34 101 299 216
		return
	fi
	
	if [ $(isValueOnScreen "text=\"X\"") == "true" ]; then
		logStuff $perkTVHealthCheckLogName "Found static ad to close."
		normalTouch 455 25
		return
	fi
}