{pkgs, ...}: let
  # 1. Create a script that handles the backgrounding properly
  launch-messengers = pkgs.writeShellScriptBin "launch-messengers" ''
    zapzap &
    Telegram &
    signal-desktop &
  '';
in {
  # 2. Add the script to your home packages
  home.packages = [launch-messengers];

  # 3. Use the script in the desktop entry
  xdg.desktopEntries = {
    messaging-apps = {
      name = "Messaging Apps";
      genericName = "Messaging Suite";
      # Point directly to the script's binary
      exec = "${launch-messengers}/bin/launch-messengers";
      icon = "org.telegram.desktop";
      terminal = false;
      categories = ["Network" "Chat"];
    };
  };
}
