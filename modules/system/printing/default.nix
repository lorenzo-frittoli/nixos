{ ... }: {
  flake.nixosModules.printing = { pkgs, ... }: {
    # mDNS/DNS-SD so CUPS can discover network printers (IPP/AirPrint).
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.printing = {
      enable = true;
      drivers = with pkgs; [
        # Open-source Brother laser driver (many HL/MFC models).
        brlaser
        # Brother's own generic mono-laser driver. Covers models brlaser
        # does not, e.g. the MFC-L6800DW (BrGenML1 series).
        brgenml1cupswrapper
        # Generic PPDs for non-Brother printers.
        gutenprint
      ];
    };

    # GUI for adding/managing printers (polkit already lets `wheel` admin CUPS).
    programs.system-config-printer.enable = true;
  };
}
