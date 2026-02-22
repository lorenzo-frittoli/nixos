{
  programs.kitty = {
    enable = true;
    settings = {
      background_blur = 5;
    };

    keybindings = {
      "ctrl+backspace" = "send_text all \\x17";
    };
  };
}
