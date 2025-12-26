{
  programs.nixvim.plugins = {
    telescope = {
      enable = true;
      extensions = {
        media-files = {
          enable = true;
          settings = {
            filetypes = [
              "png"
              "jpg"
              "jpeg"
              "webp"
              "gif"
            ];
            find_cmd = "rg";
          };
        };
      };
      keymaps = {
        # Find files using Telescope command-line sugar.
        "<leader>ff" = "find_files";
        "<leader>fw" = "live_grep";
        "<leader>fh" = "help_tags";
        "<leader>fd" = "diagnostics";
        "<leader>fm" = "media_files";
        "<leader>fg" = "git_files";
        "<leader>fo" = "oldfiles";
        # "<leader>b" = "buffers";
      };
      settings.defaults = {
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^__pycache__/"
          "^output/"
          "^data/"
          "%.ipynb"
        ];
        set_env.COLORTERM = "truecolor";
      };
    };
  };
}
