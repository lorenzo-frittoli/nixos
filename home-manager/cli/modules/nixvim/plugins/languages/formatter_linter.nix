{
  programs.nixvim.plugins = {
    # 1. FORMATTING & DIAGNOSTICS BRIDGE
    none-ls = {
      enable = true;
      settings = {
        cmd = ["bash -c nvim"];
      };
      sources = {
        code_actions = {
          statix.enable = true; # Nix
        };
        diagnostics = {
          statix.enable = true; # Nix
          deadnix.enable = true; # Nix
          pylint.enable = true; # Python
        };
        formatting = {
          alejandra.enable = true; # Nix
          stylua.enable = true; # Lua
          shfmt.enable = true; # Shell

          prettier = {
            enable = true;
            disableTsServerFormatter = true;
            settings = {
              extra_filetypes = ["vue" "json" "markdown"];
            };
          };

          black = {
            enable = true;
            settings = ''{ extra_args = { "--fast" } }'';
          };

          # Typst Formatter (Modern, fast, and active)
          typstyle.enable = true;
        };
      };
    };

    # 2. STANDALONE LINTERS
    lint = {
      enable = true;
      lintersByFt = {
        cpp = ["cppcheck"];
        json = ["jsonlint"];
        markdown = ["vale"];
        rust = ["clippy"];
        text = ["vale"];
        # Typst is intentionally left out here to prevent 'tidy' from running
      };
    };

    # 3. FORMAT ON SAVE CONTROLLER
    lsp-format = {
      enable = true;
      settings = {
        cpp = {
          order = ["clangd"];
        };

        # Explicitly force Typst to use none-ls (null-ls) for typstyle
        typst = {
          order = ["null-ls"];
        };

        python = {order = ["null-ls"];};
        lua = {order = ["null-ls"];};
        nix = {order = ["null-ls"];};
        markdown = {order = ["null-ls"];};
        json = {order = ["null-ls"];};
      };
    };
  };
}
