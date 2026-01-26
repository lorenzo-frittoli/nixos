{
  programs.nixvim.plugins = {
    markview = {
      enable = true;
    };

    typst-preview = {
      enable = true;
      settings = {
        # Use qutebrowser for the preview
        openCmd = "qutebrowser --target window %s";
        # This handles switching files automatically without opening new tabs
        followCursor = true;
      };
    };
  };
}
