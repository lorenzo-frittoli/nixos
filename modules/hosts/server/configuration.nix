{ ... }: {
  flake.nixosModules.serverConfiguration = { pkgs, ... }: {
    imports = [ ./_hardware-configuration.nix ./_disko.nix ];

    networking.hostName = "server";

    users.users.user01 = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      # Public keys are not secrets and are safe to commit. Add one line per
      # device allowed to log in.
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE6/t8SWZ6uw4+m31wwzc1fPXuLS7iNhvQKj77lRoqYx frittata@calcolatore"
      ];
    };

    # Key-only SSH: no passwords are accepted over the network. Reachable on
    # the LAN (port 22) and over the tailnet (trusted interface).
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    networking.firewall.allowedTCPPorts = [ 22 ];

    # No login password is set, so sudo cannot prompt for one. The SSH key is
    # the credential. If you want a console-recovery password and/or
    # password-protected sudo, add a sops-managed hashedPasswordFile instead.
    security.sudo.wheelNeedsPassword = false;
  };
}
