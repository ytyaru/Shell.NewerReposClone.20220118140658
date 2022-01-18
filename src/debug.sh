#!/usr/bin/env bash
Debug() {
	Reset() { echo -en "\e[0m"; }
	Bold() { echo -en "\e[1m"; }
	LightCyan() { echo -en "\e[96m"; }
	Header() { echo -en 'DEBUG '; }
	Show() { Reset; LightCyan; Header; echo -e "$msg" 1>&2; Reset; }
	#Show() { echo 'AAAAAAAAAAAAAA'; }
	local args=("$@"); local msg="$(IFS=$'\n'; echo -e "${args[*]}")"
	Show
}
