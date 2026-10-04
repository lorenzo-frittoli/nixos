{ inputs, ... }: {
  flake.nixosModules.secrets = { pkgs, ... }: {
    imports = [ inputs.sops-nix.nixosModules.sops ];

    # Decryption identity used at activation. Copy your age key here before
    # switching (see secrets/README.md):
    #   sudo install -d -m 700 /var/lib/sops-nix
    #   sudo install -m 600 ~/.config/sops/age/keys.txt /var/lib/sops-nix/key.txt
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";

    # Also generate SSH host keys (kept for the optional host-key identity).
    services.openssh.generateHostKeys = true;

    environment.systemPackages = [ pkgs.sops pkgs.ssh-to-age ];
  };
}
