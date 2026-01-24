{pkgs, ...}: {
  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelParams = ["hid_apple.fnmode=2"];
}
