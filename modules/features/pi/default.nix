{ moduleWithSystem, ... }:
let
  # Reuse the shared system palette so the pi theme stays in sync with the rest
  # of the desktop (plain Nix, importable from perSystem and NixOS modules).
  theme = import ../../system/theme/_theme.nix;
  p = theme.palette;

  # Generated pi theme (Tokyo Night). `name` must be distinct from the built-in
  # `dark`/`light` themes, which always take precedence.
  piTheme = {
    "$schema" = "https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json";
    name = "tokyonight";
    vars = {
      bg = p.base00;
      bgAlt = p.base01;
      sel = p.base02;
      comment = p.base03;
      fgDim = p.base04;
      fg = p.base05;
      red = p.base08;
      orange = p.base09;
      yellow = p.base0A;
      green = p.base0B;
      cyan = p.base0C;
      blue = p.base0D;
      purple = p.base0E;
      successBg = "#1f2d22";
      errorBg = "#2d1f26";
      pendingBg = p.base01;
    };
    colors = {
      accent = "blue";
      border = "blue";
      borderAccent = "cyan";
      borderMuted = "comment";
      success = "green";
      error = "red";
      warning = "yellow";
      muted = "fgDim";
      dim = "comment";
      text = "fg";
      thinkingText = "fgDim";

      selectedBg = "sel";
      userMessageBg = "bgAlt";
      userMessageText = "fg";
      customMessageBg = "sel";
      customMessageText = "fg";
      customMessageLabel = "purple";
      toolPendingBg = "pendingBg";
      toolSuccessBg = "successBg";
      toolErrorBg = "errorBg";
      toolTitle = "blue";
      toolOutput = "fgDim";

      mdHeading = "yellow";
      mdLink = "blue";
      mdLinkUrl = "comment";
      mdCode = "cyan";
      mdCodeBlock = "green";
      mdCodeBlockBorder = "comment";
      mdQuote = "fgDim";
      mdQuoteBorder = "comment";
      mdHr = "comment";
      mdListBullet = "cyan";

      toolDiffAdded = "green";
      toolDiffRemoved = "red";
      toolDiffContext = "comment";

      syntaxComment = "comment";
      syntaxKeyword = "purple";
      syntaxFunction = "blue";
      syntaxVariable = "cyan";
      syntaxString = "green";
      syntaxNumber = "orange";
      syntaxType = "yellow";
      syntaxOperator = "cyan";
      syntaxPunctuation = "fg";

      thinkingOff = "comment";
      thinkingMinimal = "fgDim";
      thinkingLow = "blue";
      thinkingMedium = "cyan";
      thinkingHigh = "purple";
      thinkingXhigh = "red";

      bashMode = "yellow";
    };
    export = {
      pageBg = "bg";
      cardBg = "bgAlt";
      infoBg = "sel";
    };
  };
in
{
  flake.nixosModules.pi = moduleWithSystem (
    { self', ... }:
    { config, lib, pkgs, ... }:
    let
      configDir = self'.packages.pi-config;
      users = lib.filterAttrs (_: u: (u.isNormalUser or false) && u.home != null) config.users.users;
      rulesFor = name: user:
        let
          home = user.home;
          group = user.group or "users";
        in
        [
          # The agent dir must stay writable (auth.json, sessions, npm/git
          # packages). Only read-only resources are symlinked into it.
          "d ${home}/.pi 0755 ${name} ${group} -"
          "d ${home}/.pi/agent 0755 ${name} ${group} -"
          "L+ ${home}/.pi/agent/APPEND_SYSTEM.md - - - - ${configDir}/APPEND_SYSTEM.md"
          "L+ ${home}/.pi/agent/extensions - - - - ${configDir}/extensions"
          "L+ ${home}/.pi/agent/skills - - - - ${configDir}/skills"
          "L+ ${home}/.pi/agent/prompts - - - - ${configDir}/prompts"
          "L+ ${home}/.pi/agent/themes - - - - ${configDir}/themes"
        ];
      settingsFor = name: user:
        let
          home = user.home;
          group = user.group or "users";
        in
        ''
          ${pkgs.coreutils}/bin/install -d -o ${name} -g ${group} -m 0755 "${home}/.pi" "${home}/.pi/agent"
          ${pkgs.coreutils}/bin/install -o ${name} -g ${group} -m 0644 ${configDir}/settings.json "${home}/.pi/agent/settings.json"
        '';
    in
    {
      environment.systemPackages = [ self'.packages.pi ];
      systemd.tmpfiles.rules = lib.concatLists (lib.mapAttrsToList rulesFor users);
      # settings.json must be a real writable file (pi rewrites
      # lastChangelogVersion), and tmpfiles' C+ will not replace an existing
      # file, so it is (re-)asserted here on every activation.
      system.activationScripts.piSettings.text = lib.concatStrings (lib.mapAttrsToList settingsFor users);
    }
  );

  perSystem = { pkgs, ... }: {
    # The managed config tree, referenced from the wrapper/activation so it is
    # part of the system closure and cannot be garbage collected.
    packages.pi-config = pkgs.runCommand "pi-config" { } ''
      mkdir -p $out/themes
      cp -r ${./config}/. $out/
      cp ${(pkgs.formats.json { }).generate "tokyonight.json" piTheme} $out/themes/tokyonight.json
    '';

    packages.pi = (import ../../_lib/wrap.nix { inherit pkgs; lib = pkgs.lib; }) {
      package = pkgs.pi-coding-agent;
      bin = "pi";
      env = {
        PI_TELEMETRY = "0";
        PI_SKIP_VERSION_CHECK = "1";
      };
    };
  };
}
