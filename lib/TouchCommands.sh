screenDensity="$(getprop ro.sf.lcd_density)"

lgFuelScreenXResolution=320
lgFuelScreenYResolution=480

wmSize=$(wm size)
wmSize=${wmSize:15}

actualScreenXResolution="${wmSize%x*}"
actualScreenYResolution="${wmSize#*x}"

inflateValue=1000000

# $1=originalValue, $2=deviation
plusOrMinus() {
	local originalValue=$1
	local deviation=$2
	
	local rand=$(randBetween 0 $((deviation * 2)))
	rand=$rand-$deviation
	
	echo $(($originalValue+$rand))
}

# $1=firstInt, $2=secondInt
randBetween() {
	local firstInt=$1
	local secondInt=$2
	
	local rand1=$(shuf -i $firstInt-$secondInt -n 1)
	
	echo $rand1
}

# $1=x
translateX() {
	let lgFuelX=$1*$inflateValue
	let xScreenPercent=$lgFuelX/$lgFuelScreenXResolution
	let actualX=$xScreenPercent*$actualScreenXResolution/$inflateValue
	
	echo $actualX
}

# $1=x
translateY() {
	let lgFuelY=$1*$inflateValue
	let yScreenPercent=$lgFuelY/$lgFuelScreenYResolution
	let actualY=$yScreenPercent*$actualScreenYResolution/$inflateValue
	
	echo $actualY
}

translateTouch() {
	local actualX=$(translateX $1)
	local actualY=$(translateY $2)
	
	input tap $actualX $actualY
}

advancedSwipe() {
	local x1=$(plusOrMinus $1 10)
	local y1=$(plusOrMinus $2 10)
	local x2=$(plusOrMinus $3 10)
	local y2=$(plusOrMinus $4 10)
	local duration=$5
	
	translateSwipe $x1 $y1 $x2 $y2 $duration
}

translateSwipe() {
	local x1=$(translateX $1)
	local y1=$(translateY $2)
	local x2=$(translateX $3)
	local y2=$(translateY $4)
	local duration=$5
	
	input touchscreen swipe $x1 $y1 $x2 $y2 $duration
}

normalTouch() {
	local x=$1
	local y=$2
	
	translateTouch $x $y
}

advancedTouch() {
	local x=$(plusOrMinus $1 5)
	local y=$(plusOrMinus $2 5)
	
	normalTouch $x $y
}

boundedTouch() {
	local x1=$1
	local y1=$2
	local x2=$3
	local y2=$4
	
	local x=$(shuf -i $x1-$x2 -n 1)
	local y=$(shuf -i $y1-$y2 -n 1)
	
	normalTouch $x $y
}

goHome() {
	input keyevent KEYCODE_HOME
}