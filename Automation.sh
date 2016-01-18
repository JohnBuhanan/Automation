set -x

launch() {
	# checktime
	date >> /data/Automation/automation.log
	killAllApps
	sleep 3
	stop media && start media
	sleep 1
	launchDevice
	wait
}

testLaunch() {
	# echo test func
	local points=$(getScreenPoints)
	
}

while getopts tl args
do
    case $args in
        t)
			automationPath=/cygdrive/c/github
			automationShellPath=${automationPath}/Automation
			. ${automationShellPath}/lib/Common.sh
			testLaunch
            ;;
		l)
			# The main automation program.
			automationPath=/data/Automation
			automationShellPath=${automationPath}/Automation
			. ${automationShellPath}/lib/Common.sh
			launch
			;;
        ?)
            exit 1
            ;;
    esac
done
