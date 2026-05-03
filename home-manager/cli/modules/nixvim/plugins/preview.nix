{
  programs.nixvim.plugins = {
    typst-preview = {
      enable = true;
      settings = {
        debug = true;
        # Use qutebrowser for the preview
        open_cmd = "qutebrowser --target window %s";
        # This handles switching files automatically without opening new tabs
        follow_cursor = true;
      };
    };
  };
}
