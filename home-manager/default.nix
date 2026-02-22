{
  homeStateVersion,
  user,
  hasGui,
  ...
}: {
  imports =
    [
      ./cli/default.nix
    ]
    ++ (
      if hasGui
      then [./gui/default.nix]
      else []
    );

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion;
  };
}
