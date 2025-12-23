{ config, pkgs, ... }:

{
  # ... other configurations

  programs.ssh = {
    # Setting enable = true is often redundant since the client is usually available,
    # but it ensures the programs.ssh module is fully active.
    enable = true;

    # Use extraConfig for general settings, just like a standard ssh_config file.
    extraConfig = ''
      Host my-remote-server
        Hostname 192.168.1.100  # Replace with the server's IP or FQDN
        Port 22                # Replace if the server uses a different port
        User myusername        # The username on the remote server
        IdentityFile ~/.ssh/id_ed25519 # The private key file for this host
    '';

    # You can also enable the SSH agent to manage your keys
    # startAgent = true;
  };
}
