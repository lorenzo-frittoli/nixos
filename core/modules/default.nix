{hasGui, ...}: {
  imports =
    [
      ./audio.nix
      ./bluetooth.nix
      ./boot.nix
      ./env.nix
      ./home-manager.nix
      ./kernel.nix
      ./net.nix
      ./nh.nix
      ./nix.nix
      ./timezone.nix
      ./user.nix
    ]
    ++ (
      if hasGui
      then [./hyprland.nix]
      else []
    );
}
