{pkgs, ...}: let
  cppDriverPath = "${pkgs.gcc.cc}/bin/g++";
in {
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      servers = {
        # --- Existing ---
        html.enable = true;
        pyright.enable = true;
        marksman.enable = true;
        nil_ls.enable = true;
        bashls.enable = true;
        yamlls.enable = true;

        # --- C++ ---
        clangd = {
          enable = true;
        };

        # --- Rust ---
        rust_analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
          installRustfmt = true;
          # Rust Analyzer runs "cargo check" (or clippy) on save automatically
          settings.check.command = "clippy";
        };

        # --- Lua ---
        lua_ls = {
          enable = true;
          settings.telemetry.enable = false;
        };

        # JSON
        jsonls.enable = true;

        # TOML (taplo)
        taplo.enable = true;

        # Typst (tinymist is the modern choice)
        tinymist = {
          enable = true;
          # Ensure it formats documents
          settings.exportPdf = "never";
        };
      };
    };

    # UI Enhancements
    lsp-status.enable = true;
    lspkind = {
      enable = true;
      settings.cmp.enable = true;
    };
    trouble.enable = true;
  };
}
