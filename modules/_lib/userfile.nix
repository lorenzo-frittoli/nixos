# Helper (underscore-prefixed, ignored by import-tree) to place a config file
# into a user's home via systemd-tmpfiles. Used for apps that have no wrapper
# and only read their config from a fixed XDG path.
{ lib }: { user, file, source }: {
  systemd.tmpfiles.rules = [
    "d /home/${user}/${builtins.dirOf file} 0755 ${user} users -"
    "L+ /home/${user}/${file} - - - - ${source}"
  ];
}
