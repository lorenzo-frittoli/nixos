{
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.chats = moduleWithSystem ({ self', ... }: {
    environment.systemPackages = [ self'.packages.chats ];
  });

  perSystem = { pkgs, ... }: {
    packages.chats = pkgs.stdenv.mkDerivation {
      pname = "chats-launcher";
      version = "1.0";
      dontUnpack = true;
      nativeBuildInputs = [ pkgs.copyDesktopItems ];

      desktopItems = [
        (pkgs.makeDesktopItem {
          name = "chats";
          desktopName = "Chats";
          genericName = "Messaging Suite";
          exec = "launch-messengers";
          icon = "org.telegram.desktop";
          terminal = false;
          categories = [ "Network" "Chat" ];
        })
      ];

      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        cat > $out/bin/launch-messengers <<'EOF'
        #!${pkgs.runtimeShell}
        zapzap &
        Telegram &
        signal-desktop &
        EOF
        chmod +x $out/bin/launch-messengers
        runHook postInstall
      '';
    };
  };
}
