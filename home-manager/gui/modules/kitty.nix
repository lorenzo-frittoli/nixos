{
  programs.kitty = {
    enable = true;
    settings = {
      background_blur = 5;
      window_padding_width = 20;
    };

    keybindings = {
      "ctrl+backspace" = "send_text all \\x17";
    };
  };
}
