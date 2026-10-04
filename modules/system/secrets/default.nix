{ inputs, ... }: {
  flake.nixosModules.secrets = { pkgs, ... }: {
    imports = [ inputs.sops-nix.nixosModules.sops ];

    # Generate SSH host keys even when sshd is disabled, so sops can decrypt
    # using the host's ed25519 key (the default `sops.age.sshKeyPaths`).
    services.openssh.generateHostKeys = true;

    # Alternative: a dedicated, root-owned age key on each host.
    # Place the key at this path before switching, then uncomment:
    # sops.age.keyFile = "/var/lib/sops-nix/key.txt";

    # Handy on the host for editing secrets / deriving recipients.
    environment.systemPackages = [ pkgs.sops pkgs.ssh-to-age ];
  };
}
