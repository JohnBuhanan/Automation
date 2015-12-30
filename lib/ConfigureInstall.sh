installApp() {
	local path=$1
	install $path
}

uninstallApp() {
	local package=$1	
	uninstall $package
}