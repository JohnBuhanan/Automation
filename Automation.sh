set -x

testLaunch() {
	echo "Test Launch"
	
	
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
