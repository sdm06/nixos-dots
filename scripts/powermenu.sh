#!/bin/sh

# Options
shutdown="  Shutdown"
reboot="  Reboot"
lock="  Lock"
suspend="  Suspend"
hibernate="  Hibernate"
logout="  Logout"

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "Power Menu" \
		-mesg "Uptime: $(uptime -p | sed -e 's/up //g')" \
		-theme-str 'window {width: 300px;}' \
		-theme-str 'listview {lines: 6;}'
}

# Run Rofi
run_rofi() {
	echo -e "$lock\n$suspend\n$hibernate\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

# Actions
run_cmd() {
	case $1 in
		"$shutdown")
			systemctl poweroff
			;;
		"$reboot")
			systemctl reboot
			;;
		"$lock")
            sleep 0.5 && slock
			;;
		"$suspend")
			systemctl suspend
			;;
		"$hibernate")
			systemctl hibernate
			;;
		"$logout")
			loginctl terminate-user $USER
			;;
	esac
}

run_cmd "$(run_rofi)"
