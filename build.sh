#!/bin/bash

# Text formatting
BOLD=$(tput bold)
ITALIC=$(tput sitm)
NORMAL=$(tput sgr0)
UNDERLINE=$(tput smul)
CYAN=$(tput setaf 6)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)

echo "${BOLD}${CYAN}Select an option:${NORMAL}"
echo "1. Build mode: ${GREEN}${ITALIC}APK${NORMAL}"
echo "2. Build mode: ${GREEN}${ITALIC}AAP${NORMAL}"
echo "3. Build mode: ${GREEN}${ITALIC}IOS${NORMAL}"
while :
do 
	read -p "Build with: " input
	case $input in
		1)
		flutter build apk --target-platform android-arm,android-arm64 --split-per-abi --release
		break
		;;
		2)
		flutter build appbundle --target-platform android-arm,android-arm64 --release
		break
		;;
        3)
		flutter build ios --release
		break
		;;
		*)
		;;
	esac
done