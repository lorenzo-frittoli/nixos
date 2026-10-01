{ ... }: {
  flake.nixosModules.bootloader = { pkgs, ... }: {
    boot.loader = {
      efi.canTouchEfiVariables = true;
      timeout = 2;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
    };

    boot.kernelPackages = pkgs.linuxPackages;

    boot.plymouth = {
      enable = true;
      theme = "bgrt";
    };
  };
}
