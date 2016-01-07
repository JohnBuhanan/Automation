set -x

. ${automationShellPath}/lib/Common.sh

checkForUpdatesAndLaunch() {
	sh /data/Automation/UpdateAutomation.sh && launch
}

#$1=flag to run everything.   
launch() {
	# checktime
	checkForUpdates
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
	 
	# local test1=$(getGitDate)
	
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
