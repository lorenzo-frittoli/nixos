{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            # 1. ESP (EFI System Partition)
            ESP = {
              priority = 1;
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            # 2. Swap (Dedicated partition is fine, reliable for hibernation)
            swap = {
              size = "8G";
              content = {
                type = "swap";
                resumeDevice = true; # Tells NixOS to use this for hibernation
              };
            };
            # 3. Root (Btrfs with Subvolumes)
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Force override existing partition
                
                # Global mount options for the filesystem
                # zstd is the best balance of speed/compression
                # noatime extends SSD life and improves performance
                subvolumes = {
                  # Mount the root filesystem
                  "@" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  # Mount home separately so you can snapshot OS without reverting home
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  # Mount /nix separately (optional but common) to exclude it from root snapshots
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
