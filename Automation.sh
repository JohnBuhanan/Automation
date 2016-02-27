set -x

testLaunch() {
	echo "Test Launch"
	
	updateCron
	
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
			# testLaunch
			;;
        ?)
            exit 1
            ;;
    esac
done
