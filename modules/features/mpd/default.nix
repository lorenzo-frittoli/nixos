{ ... }: {
  flake.nixosModules.mpd = { pkgs, config, ... }: let
    # mpd runs as a *system* service but must reach the user's PipeWire socket
    # at /run/user/<uid>/pipewire-0, so give it the runtime dir and order it
    # after logind creates that directory.
    uid = config.users.users.frittata.uid;
    runtimeDir = "/run/user/${toString uid}";
  in {
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

    systemd.services.mpd = {
      environment = {
        XDG_RUNTIME_DIR = runtimeDir;
        PIPEWIRE_RUNTIME_DIR = runtimeDir;
      };
      after = [ "user-runtime-dir@${toString uid}.service" ];
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
