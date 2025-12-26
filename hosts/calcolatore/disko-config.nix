{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        # ⚠️ PASTE YOUR ID HERE ⚠️
        # This prevents accidental formatting if drive letters change (e.g. sda -> sdb)
        device = "/dev/disk/by-id/nvme-BC511_NVMe_SK_hynix_512GB_CY06T000310606K23"; 
        
        content = {
          type = "gpt";
          partitions = {
            # 1. ESP (Boot Partition)
            ESP = {
              priority = 1;
              size = "512M";
              type = "EF00";
              label = "BOOT"; # GPT Label
              content = {
                type = "filesystem";
                format = "vfat";
                # Sets the Filesystem Label to 'NIXBOOT' for easy identification
                extraArgs = [ "-n" "NIXBOOT" ]; 
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            
            # 2. Swap 
            swap = {
              size = "8G";
              label = "SWAP"; # GPT Label
              content = {
                type = "swap";
                # Sets the Swap Label to 'NIXSWAP'
                extraArgs = [ "-L" "NIXSWAP" ]; 
                resumeDevice = true;
              };
            };
            
            # 3. Root (Btrfs)
            root = {
              size = "100%";
              label = "ROOT"; # GPT Label
              content = {
                type = "btrfs";
                # Sets the Filesystem Label to 'NIXROOT'
                extraArgs = [ "-f" "-L" "NIXROOT" ]; 
                
                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
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
