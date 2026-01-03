{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # packages required by all systems
    git
    wget
  ];
}
