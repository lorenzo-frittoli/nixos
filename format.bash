#!/usr/bin/env bash
# Format/partition a host's disks using its disko configuration.
# Usage: ./format.bash <hostname>
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <hostname>"
  exit 1
fi

HOST="$1"
DISKO_CONFIG="./modules/hosts/${HOST}/_disko.nix"

if [ ! -f "$DISKO_CONFIG" ]; then
  echo "File not found: $DISKO_CONFIG"
  echo "- Check the hostname"
  echo "- Run this from the repository root"
  exit 1
fi

echo "This will DESTROY and reformat the disks of '${HOST}'."
read -r -p "Do you want to proceed? (y/n) " yn
case "$yn" in
  [yY]*)
    sudo nix --experimental-features "nix-command flakes" \
      run github:nix-community/disko -- \
      --mode destroy,format,mount "$DISKO_CONFIG"
    ;;
  *)
    echo "Exiting..."
    ;;
esac
