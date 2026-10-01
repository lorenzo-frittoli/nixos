{ ... }: {
  flake.nixosModules.calcolatoreConfiguration = { pkgs, ... }: {
    imports = [ ./_hardware-configuration.nix ./_disko.nix ];

    networking.hostName = "calcolatore";

    virtualisation.docker.enable = true;

    users.users.frittata = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "dialout" "docker" "video" "audio" "input" ];
      shell = pkgs.zsh;
    };

    security.sudo.wheelNeedsPassword = true;

    environment.systemPackages = with pkgs; [
      cliphist
      wl-clipboard
      wtype
      brightnessctl
      grimblast
      hyprpicker
      bemoji
      trashy
      udisks
      ntfs3g
      linux-wifi-hotspot
      p7zip
      zip
      unzip
      w3m
      silicon
      figlet
      ueberzugpp
    ];
  };
}
