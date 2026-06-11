{ pkgs, ... }: {
  home.packages = with pkgs; [
    papirus-icon-theme
    pcmanfm-qt
  ];
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      package = pkgs.adwaita-qt;
      name = "adwaita-dark";
    };
  };

  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus-Dark";
  };
}
