{ ... }: {
  flake.nixosModules.serverConfiguration = { pkgs, ... }: {
    imports = [ ./_hardware-configuration.nix ./_disko.nix ];

    networking.hostName = "server";

    users.users.user01 = {
      isNormalUser = true;
      initialPassword = "qwer";
      extraGroups = [ "wheel" ];
    };

    services.openssh.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
