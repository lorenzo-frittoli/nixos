{
  lib,
  config,
  ...
}: {
  programs.nixvim = {
    globals.mapleader = " ";
    keymaps = let
      keymaps_raw = [
        # Harpoon keybinds
        ["n" "<leader>a" "<cmd>lua require('harpoon'):list():add()<cr>"]
        ["n" "<C-e>" "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<cr>"]
        ["n" "<C-h>" "<cmd>lua require('harpoon'):list():select(1)<cr>"]
        ["n" "<C-j>" "<cmd>lua require('harpoon'):list():select(2)<cr>"]
        ["n" "<C-k>" "<cmd>lua require('harpoon'):list():select(3)<cr>"]
        ["n" "<C-l>" "<cmd>lua require('harpoon'):list():select(4)<cr>"]

        # Open file explorer
        ["n" "<leader>pv" ":Ex<Enter>"]

        # Preview
        ["n" "<leader>ms" ":Markview splitToggle<Enter>"]
        ["n" "<leader>mv" ":Markview splitToggle<Enter>"]

        # Move selected lines
        ["v" "<C-j>" ":m +1<CR>"]
        ["v" "<C-k>" ":m -2<CR>"]

        # Fix line append cursor position
        ["n" "J" "mzJ`z"]

        # Fix page scroll cursor position
        ["n" "<C-d>" "<C-d>zz"]
        ["n" "<C-u>" "<C-u>zz"]

        # Fix search result position
        ["n" "n" "nzzzv"]
        ["n" "N" "Nzzzv"]

        # Paste with deletion without affecting clipboard
        ["x" "<leader>p" "[[\"_dP]]"]

        # P/Y for system clipboard
        [["n" "v"] "Y" "\"+y"]
        [["n" "v"] "P" "\"+p"]

        # Delete without affecting clipboard
        [["n" "v"] "<leader>d" "[[\"_d]]"]
      ];

      keys = ["mode" "key" "action"];

      toSet = values:
        builtins.listToAttrs (
          lib.lists.zipListsWith (key: value: {
            name = key;
            inherit value;
          })
          keys
          values
        );

      keymaps = map toSet keymaps_raw;
    in
      config.lib.nixvim.keymaps.mkKeymaps {
        options.silent = true;
      }
      keymaps;
  };
}
