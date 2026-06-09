{
  config,
  pkgs,
  ...
}: {
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    dataDir = "${config.xdg.dataHome}/mpd";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Output"
      }

      audio_output {
         type   "fifo"
         name   "my_fifo"
         path   "/tmp/mpd.fifo"
         format "44100:16:2"
      }
    '';
  };

  # Optional: mpdris2 allows mpd to be controlled via playerctl (which you use in Hyprland)
  services.mpdris2.enable = true;

  # Ensure the music directory exists
  home.packages = [pkgs.mpc];
}
