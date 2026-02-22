{
  pkgs,
  stateVersion,
  hostname,
  ...
}: {
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ./nvidia.nix
    ../../core/modules/default.nix
  ];

  environment.systemPackages = [pkgs.home-manager];

  networking.hostName = hostname;

  system.stateVersion = stateVersion;
}
