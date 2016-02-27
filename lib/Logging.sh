logsDirectory="/data/Automation/Logs"

# $1=logName, $2=message
logStuff() {
	local logName=$1
	local message=$2
	local logPath=$logsDirectory/$logName.log
	
	makeSureLogDirectoryExists
	
	echo "$(date) --- $message" >> $logPath
	
	trimLogIfNeeded $logName
}

# $1=logName
trimLogIfNeeded() {
	local logName=$1
	local lineCount=$(getLogLineCount $logName)
	local logPath=$logsDirectory/$logName.log
	local lineLimit=100
	
	# If file is over 1000 lines
	if [ $lineCount -gt $lineLimit ]; then
		local linesToRemove=$((lineCount - lineLimit))
		set +x # Stop debugging.
		echo "$(tail -n +$linesToRemove $logPath)" > $logPath
		set -x # Start again.
	fi
	
}

makeSureLogDirectoryExists() {
	mkdir -p $logsDirectory # Make sure this exists.
}

# $1=logName
getLogLineCount() {
	local logName=$1
	local logPath=$logsDirectory/$logName.log
	
	echo $(cat $logPath | wc -l)
}