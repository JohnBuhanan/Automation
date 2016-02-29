set -x

testLaunch() {
	echo "Test Launch"
	
	echo $(getCurrentActivity)
	dumpScreen
	# local currentActivity=$(getCurrentActivity)
	
	# if [ $currentActivity == "com.jutera.perkpopquiz.FANActivity" ]; then
		# # logStuff $popQuizLogName "Closing static ad."
		# normalTouch 305 19
	# fi
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
			launch
			# testLaunch
			;;
        ?)
            exit 1
            ;;
    esac
done
