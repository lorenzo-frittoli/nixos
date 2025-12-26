{
  boot.loader = {
    # If you want to use GRUB
    grub = {
      enable = true;
      device = "nodev"; # Required for EFI
      efiSupport = true;
      # enableCryptodisk = true; # Uncomment if using LUKS on root
    };
    
    # You also need to point to the EFI partition
    # Disko usually mounts this at /boot, so this is the default
    efi.canTouchEfiVariables = true;
  };
}
