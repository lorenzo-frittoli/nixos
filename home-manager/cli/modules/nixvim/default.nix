{ inputs, ...} : {
  imports = [
    inputs.nixvim.homeModules.nixvim
    
    ./keymaps.nix
    ./options.nix
    ./plugins
  ];
}
