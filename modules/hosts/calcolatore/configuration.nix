{ self, ... }: {
  flake.nixosModules.calcolatoreConfiguration = { pkgs, config, ... }: {
    imports = [
      ./_hardware-configuration.nix
      ./_disko.nix
      self.nixosModules.docker
    ];

    networking.hostName = "calcolatore";

    users.users.frittata = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "dialout" "docker" "video" "audio" "input" ];
      shell = pkgs.zsh;
    };

    security.sudo.wheelNeedsPassword = true;

    # --- sops-managed user secrets -------------------------------------------
    sops.defaultSopsFile = ../../../secrets/calcolatore.yaml;
    sops.secrets."gh_token".owner = "frittata";
    sops.secrets."deepseek_api_key".owner = "frittata";

    sops.templates."frittata-env" = {
      owner = "frittata";
      content = ''
        export GH_TOKEN=${config.sops.placeholder."gh_token"}
        export DEEPSEEK_API_KEY=${config.sops.placeholder."deepseek_api_key"}
      '';
    };

    programs.zsh.interactiveShellInit = ''
      if [ -r ${config.sops.templates."frittata-env".path} ]; then
        . ${config.sops.templates."frittata-env".path}
      fi
    '';

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
