DISKO_CONFIG_FILE="./hosts/$1/disko-config.nix";

format() {
	sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount $DISKO_CONFIG_FILE
}

# Check number of parameters
if [ "$#" -ne 1 ]; then
    echo "Please provide one and only one parameter, the hostname."
	exit;
fi

# Check if parameter is valid
if [ ! -f $DISKO_CONFIG_FILE ]; then
    echo "File not found:"
	echo "- Make sure your hostname is correct"
	echo "- Make sure you are running the script from the root of the git repo"
	exit;
fi

while true; do
  read -p "Do you want to proceed? (y/n) " yn
  case $yn in
	[yY]*) format; break;;
    [nN]*) echo "Exiting..."; exit;;
    *) echo "Please answer y or n.";;
  esac
done   
