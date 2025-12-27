{
  programs.nixvim = {
    enable = true;
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 4;
      completeopt = [
        "menu"
        "menuone"
        "noselect"
      ];
      termguicolors = true;
    };

    colorschemes.everforest = {
      enable = true;
    };

    dependencies = {
      chafa.enable = true;
      imagemagick.enable = true;
    };
  };
}
