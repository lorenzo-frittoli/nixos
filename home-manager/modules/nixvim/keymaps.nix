{ lib
, config
, ...
}: {
  programs.nixvim = {
    globals.mapleader = " ";
    keymaps =
      let
        mappings = [
          # Open explorer
          {
            mode = "n";
            key = "<leader>pv";
            action = ":Ex";
          }
        ];
      in
      config.lib.nixvim.keymaps.mkKeymaps
        {
          options.silent = true;
        }
        mappings;
  };
}
