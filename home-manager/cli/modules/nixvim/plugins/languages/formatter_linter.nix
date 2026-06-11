{
  programs.nixvim.plugins = {
    # 1. DIAGNOSTICS & CODE ACTIONS
    none-ls = {
      enable = true;
      sources = {
        code_actions.statix.enable = true; # Nix
        diagnostics = {
          statix.enable = true; # Nix
          deadnix.enable = true; # Nix
          pylint.enable = true; # Python
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
      };
    };

    # 3. MODERN FORMATTING & FORMAT-ON-SAVE
    conform-nvim = {
      enable = true;
      settings = {
        # This replaces lsp-format entirely and fixes the deprecation error
        format_on_save = {
          lsp_format = "fallback";
          timeout_ms = 500;
        };

        # Explicit formatters.
        # C++ (clangd) and Rust (rust-analyzer) will automatically fall back to their LSPs.
        formatters_by_ft = {
          nix = ["alejandra"];
          lua = ["stylua"];
          python = ["black"];
          sh = ["shfmt"];
          vue = ["prettier"];
          json = ["prettier"];
          markdown = ["prettier"];
          typst = ["typstyle"];
        };

        # Optional: Keep your specific black arguments
        formatters = {
          # Python
          black = {
            prepend_args = ["--fast"];
          };
        };
      };
    };
  };
}
