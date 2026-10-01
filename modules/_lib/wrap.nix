# Helper (underscore-prefixed, ignored by import-tree) for wrapping a binary
# with extra CLI flags and/or environment variables.
{
  lib,
  pkgs,
}: {
  package,
  bin,
  flags ? [ ],
  env ? { },
}: pkgs.symlinkJoin {
  name = "${bin}-wrapped";
  paths = [ package ];
  nativeBuildInputs = [ pkgs.makeWrapper ];
  meta.mainProgram = bin;
  postBuild = ''
    wrapProgram "$out/bin/${bin}" ${
      lib.concatStringsSep " " (
        (lib.optional (flags != [ ]) "--add-flags ${lib.escapeShellArg (lib.concatStringsSep " " flags)}")
        ++ (lib.mapAttrsToList (k: v: "--set ${k} ${lib.escapeShellArg v}") env)
      )
    }
  '';
}
