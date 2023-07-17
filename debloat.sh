#!/bin/bash


setup(){
	if ! adb get-state &>/dev/null; then
		printf "\n%s\n\n" "No device is connected." && exit 1;
	fi

	brand=$(adb shell getprop ro.product.brand | tr -d '\r')
	model=$(adb shell getprop ro.product.model | tr -d '\r')

	printf "\n%s\n" "Device connected: $model (${brand^})"
}

search_package(){
	printf "\n%s" "Search for package : "
	read -r
	adb shell pm list packages | grep -i "$REPLY" | sed 's/package://g' | sort > pkg_list
	
	if [ -s pkg_list ]; then
		printf "\n%s\n" "Packages:"
		nl pkg_list
	else
		printf "\n%s\n" "No package found."
	fi

	rm -f pkg_list
}

list_packages(){
	printf "\n%s\n" "Listing all packages..."
	adb shell pm list packages | sed 's/package://g' | sort > pkg_list

	printf "\n%s\n" "Packages:"
	nl pkg_list

	rm -f pkg_list
}

uninstall(){
	printf "\n%s" "Enter package : "
	read -r

	printf "\n%s\n\n" "Uninstalling..."
	local status=$(adb shell pm uninstall -k --user 0 $REPLY)

	if [ "$status" = "Success" ]; then
		echo "Success: $REPLY"
	else
		echo "Failed: $REPLY"
		printf "%s\n" "Reason: $status"
	fi
}

bulk_uninstall(){
	printf "\n%s" "List all packages you want to uninstall in the file \"package.txt\""
	printf "\n\n%s" "Press any key to start uninstalling "
	read -n 1 -r -s

	printf "\n\n%s\n\n" "Uninstalling..."

	if [ -f package.txt ]; then
		COUNT_SUCCESS=0
		COUNT_FAILURE=0

		for pkg in $(cat package.txt); do
			if [ -z "$pkg" ]; then
				continue
			fi

			local status=$(adb shell pm uninstall -k --user 0 $pkg)

			if [ "$status" = "Success" ]; then
				echo "Success: $pkg" && ((COUNT_SUCCESS++))
			else
				echo "Failure: $pkg" && ((COUNT_FAILURE++))
			fi
		done

		printf "\n%s" "Status:"
		printf "\n%s" "$COUNT_SUCCESS applications uninstalled successfully."
		printf "\n%s\n" "$COUNT_FAILURE uninstall failed."
	else
		printf "%s\n" "File not found: package.txt"
	fi
}

### Main Script
main(){
	while true; do
		clear -x
		setup

		printf "\n%s" "OPTIONS :"
		printf "\n%s" "1 - Search package"
		printf "\n%s" "2 - List all packages"
		printf "\n%s" "3 - Uninstall package"
		printf "\n%s" "4 - Bulk uninstall packages"
		printf "\n%s" "X - Exit"

		printf "\n\n%s" "Enter option : "
		read -n 1 -r

		clear -x

		case $REPLY in
		1) search_package;;
		2) list_packages;;
		3) uninstall;;
		4) bulk_uninstall;;
		X|x)
			printf "\n%s" "Do you want to reboot? (y/n) : "
			read -n 1 -r
			printf "\n\n"
			if [ "$REPLY" == "y" ]; then
				printf "%s\n\n" "Rebooting device..."
				adb reboot && exit 0;
			fi
			exit 0;;
		*)
		    printf "\n\n%s\n" "Invalid option!"
		    ;;
		esac

		printf "\n%s" "Press any key to continue "
		read -n 1 -r -s
	done
}

main
