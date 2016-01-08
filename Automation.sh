set -x

automationPath=/data/Automation
automationShellPath=${automationPath}/Automation

. ${automationShellPath}/lib/Common.sh

checkForUpdatesAndLaunch() {
	local before=$(cat ${automationPath}/updatedAt)
	sh ${automationPath}/UpdateAutomation.sh
	local after=$(cat ${automationPath}/updatedAt)
	
	if [ $before -eq $after ]; then
		launch
	else
		$(sh ${automationShellPath}/Automation.sh -l &)
	fi
}

#$1=flag to run everything.
launch() {
	# checktime 
	# echo VERSION 3
	killAllApps
	sleep 3
	stop media && start media
	sleep 1
	# launchDevice
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
			checkForUpdatesAndLaunch
			;;
        ?)
            exit 1
            ;;
    esac
done
