{ self, moduleWithSystem, ... }: {
  flake.nixosModules.multimedia = moduleWithSystem ({ pkgs, ... }: {
    imports = with self.nixosModules; [
      mpd
      rmpc
    ];
    environment.systemPackages = with pkgs; [
      mpv
      imv
      ffmpeg
      ffmpegthumbnailer
      yt-dlp
      cava
      playerctl
      mediainfo
      obs-studio
    ];
  });
}
