set -x

automationPath=/data/Automation
automationShellPath=${automationPath}/Automation

. ${automationShellPath}/lib/Common.sh

launch() {
	# checktime 
	killAllApps
	sleep 3
	stop media && start media
	sleep 1
	launchDevice
	wait
}

testLaunch() {
	# echo test func
	checkForUpdatesAndLaunch
}

while getopts tl args
do
    case $args in
        t)
			testLaunch
            ;;
		l)
			# The main automation program.
			launch
			;;
        ?)
            exit 1
            ;;
    esac
done
