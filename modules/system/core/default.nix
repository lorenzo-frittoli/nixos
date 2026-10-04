{ self, ... }: {
  flake.nixosModules.core = { pkgs, ... }: {
    imports = with self.nixosModules; [
      overlays
      bootloader
      nix
      hardware
      locale
      env
      secrets
    ];

    environment.systemPackages = with pkgs; [
      vim
      git
      wget
      curl
      unzip
      p7zip
      usbutils
      lsof
      gvfs
      libnotify
    ];

    system.stateVersion = "25.05";
  };
}
