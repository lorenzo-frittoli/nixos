{
  programs.nixvim.plugins = {
    # 1. FORMATTING & DIAGNOSTICS BRIDGE
    none-ls = {
      enable = true;
      settings = {
        cmd = [ "bash -c nvim" ];
      };
      sources = {
        code_actions = {
          statix.enable = true; # Nix
        };
        diagnostics = {
          statix.enable = true; # Nix
          deadnix.enable = true; # Nix
          pylint.enable = true; # Python
          # Removed cppcheck from here (using nvim-lint instead for performance)
        };
        formatting = {
          # Nix
          alejandra.enable = true;

          # Lua
          stylua.enable = true;

          # Shell
          shfmt.enable = true;

          # Web/Markdown/JSON
          prettier = {
            enable = true;
            disableTsServerFormatter = true;
            settings = {
              extra_filetypes = [
                "vue"
                "json"
                "markdown"
              ];
            };
          };

          # Python
          black = {
            enable = true;
            settings = ''{ extra_args = { "--fast" } }'';
          };

          # REMOVED: clang_format (We will let clangd handle this to support your Tabs preference)
        };
      };
    };

    # 2. STANDALONE LINTERS (lighter weight than none-ls)
    lint = {
      enable = true;
      lintersByFt = {
        cpp = [ "cppcheck" ];
        # Rust usually doesn't need this if rust-analyzer is active,
        # but kept if you want explicit clippy results in the lint window.
        rust = [ "clippy" ];
        text = [ "vale" ];
        markdown = [ "vale" ];
        json = [ "jsonlint" ];
      };
    };

    # 3. FORMAT ON SAVE CONTROLLER
    lsp-format = {
      enable = true;
      settings = {
        # FORCE PRIORITY: Neovim, please use these formatters.

        # For C++, use the LSP (clangd) because we configured it with your custom tabs.
        cpp = {
          order = [ "clangd" ];
        };

        # For these, use none-ls (null-ls) because the CLI tools are better.
        python = {
          order = [ "null-ls" ];
        };
        lua = {
          order = [ "null-ls" ];
        };
        nix = {
          order = [ "null-ls" ];
        };
        markdown = {
          order = [ "null-ls" ];
        };
        json = {
          order = [ "null-ls" ];
        };
      };
    };
  };
}
