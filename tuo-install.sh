#!/bin/bash

starts() {
	clear
	if [[ ! -d "/data/data/com.termux/files/home" ]]; then
		echo -e "This script is only for TERMUX\n"
		echo -e "Please wait for another Update\n"
		exit 0
	fi

	if [[ ! -d "$HOME/storage" ]]; then
		echo -e "Setting up Storage\n"
		echo -e "Please Allow Storage Permission\n"
		sleep 2
		termux-setup-storage
	fi
}

install_pkgs() {
	pkgs=(python mpv ffmpeg)

	for i in "${pkgs[@]}"; do
		if [[ ! $(command -v "$i") ]]; then
			type -p "$i" &>/dev/null || {
				echo -e "\nInstalling $i\n"
				pkg install -y "$i"
				sleep 1
			}
		fi
	done

	if [[ ! $(command -v pip3) ]]; then
		curl -k --progress-bar -L "https://bootstrap.pypa.io/get-pip.py" -o "gpip.py"
		python gpip.py
		rm gpip.py
	fi
	if [[ ! $(command -v yt-dlp) ]]; then
		pip3 install yt-dlp
	fi
}

config_s() {
	directory=("$HOME/bin" "$HOME/.config/yt-dlp" "/sdcard/YouTube")
	for d in "${directory[@]}"; do
		if [[ ! -d "$d" ]]; then
			echo "Creating Directory : $d"
			mkdir -p $d
		fi
	done

	confs=("$HOME/bin/termux-url-opener" "$HOME/.config/yt-dlp/config")
	for c in "${confs[@]}"; do
		if [[ -e "$c" ]]; then
			echo "Backing Up : $c"
			mv $c "${c}.bak"
		fi
		if [[ -e $(basename $c) ]]; then
			cp $(basename $c) "$c"
			chmod 777 "$c"
		else
			echo -e "\nSome Config files not found,,,Clone Again\n"
			exit 0
		fi
	done
	
	echo -e "\nConfiguration Completed !!\n"
}

starts
install_pkgs
config_s
