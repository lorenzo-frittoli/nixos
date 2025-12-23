{ homeStateVersion, user, ... }:
{
  imports = [
    ./modules
    ./home-packages.nix
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion;
    sessionVariables = {
      # Variable Name = "Value"
      FLAKE = "$NH_FLAKE"; # Fix nh env variables
    };
  };
}
