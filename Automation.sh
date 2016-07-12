set -x

testLaunch() {
	echo "Test Launch"
	
	dumpScreen
	if [ $(isValueOnScreen "CheckPoints isn't responding. Do you want to close it?") == "true" ]; then
		logStuff $checkPointsLogName "CheckPoints isn't responding. Do you want to close it?"
		boundedTouch 240 179 384 227
		sleep 2
		restartTheWholeThing
	fi
}

while getopts tl args
do
    case $args in
        t)
			# automationPath=/cygdrive/c/github
			# automationShellPath=${automationPath}/Automation
			automationPath=/data/Automation
			automationShellPath=${automationPath}/Automation
			. ${automationShellPath}/lib/Common.sh
			testLaunch
            ;;
		l)
			# The main automation program.
			automationPath=/data/Automation
			automationShellPath=${automationPath}/Automation
			. ${automationShellPath}/lib/Common.sh
			launch #> /data/Automation/Logs/running.log 2>&1
			# testLaunch
			;;
        ?)
            exit 1
            ;;
    esac
done
