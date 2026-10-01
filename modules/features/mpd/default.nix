{ ... }: {
  flake.nixosModules.mpd = { pkgs, ... }: {
    services.mpd = {
      enable = true;
      user = "frittata";
      group = "users";
      dataDir = "/home/frittata/.local/share/mpd";
      settings = {
        music_directory = "/home/frittata/Music";
        audio_output = [
          {
            type = "pipewire";
            name = "PipeWire Output";
          }
          {
            type = "fifo";
            name = "my_fifo";
            path = "/tmp/mpd.fifo";
            format = "44100:16:2";
          }
        ];
      };
    };

    systemd.user.services.mpdris2 = {
      description = "MPRIS interface for MPD";
      unitConfig.ConditionUser = "frittata";
      after = [ "mpd.service" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.mpdris2}/bin/mpdris2 --no-install";
        Restart = "on-failure";
      };
    };

    environment.systemPackages = [ pkgs.mpc ];
  };
}
