echo "=============DART============"
echo "1. import_sorter"
echo "2. generate native screen"
echo "3. generate icon app"
echo "4. rename app"
echo "5. build_runner"

while :
do 
	read -p "Run with: " input
	case $input in
		1)
		dart run import_sorter:main
		break
		;;
		2)
		dart run flutter_native_splash:create --path=native_splash_generator.yaml
		break
        ;;
		3)
		dart run flutter_launcher_icons -f flutter_launcher_icons.yaml
		break
        ;;
		4)
		dart run package_rename --path=package_rename_config.yaml
		break
        ;;
		5)
		flutter packages pub run build_runner build -d
		break
        ;;
        *)
		;;
	esac
done