{ ... }: {
  flake.nixosModules.tailscale = { config, ... }: {
    services.tailscale.enable = true;

    # Trust the tailnet interface so peers can reach services (SSH included)
    # without exposing anything to the public internet, and allow the
    # WireGuard UDP port for direct peer-to-peer connections.
    networking.firewall = {
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };

    # Joining the tailnet is a one-time interactive step (`sudo tailscale up`),
    # or non-interactive with an auth key (`--authkey`). The daemon then keeps
    # the node connected across reboots.
  };
}
