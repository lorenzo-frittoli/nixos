{ ... }: {
  flake.nixosModules.git = { pkgs, ... }: {
    programs.git = {
      enable = true;
      config = {
        user = {
          name = "lorenzo-frittoli";
          email = "lorenzo.frittoli.ge@gmail.com";
        };
        credential = {
          "https://github.com".helper = [ "" "!${pkgs.gh}/bin/gh auth git-credential" ];
          "https://gist.github.com".helper = [ "" "!${pkgs.gh}/bin/gh auth git-credential" ];
        };
      };
    };
    programs.gnupg.agent.enable = true;
    environment.systemPackages = [ pkgs.gh ];
  };
}
