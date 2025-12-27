# My NixOS Config

This config is mostly stolen from [here](https://github.com/Andrey0189/nixos-config-reborn).

## Installation

To get started with this setup, follow these steps:

1. **Install NixOS**: If you haven't already installed NixOS, follow the [NixOS Installation Guide](https://nixos.org/manual/nixos/stable/#sec-installation) for detailed instructions.
2. **Clone the Repository**:

	```bash
    git clone https://github.com/lorenzo-frittoli/nixos
    cd nixos
    ```

3. **Copy one of the hosts configuration to set up your own**:

    ```bash
    cd hosts
    cp -r calcolatore <your_hostname>
    cd <your_hostname>
    ```

4. **Edit `disko-config.nix` and `hardware-configuration.nix`**:
    ```diff
    {
      disko.devices = {
        disk = {
          main = {
            type = "disk";
            # ⚠️ PASTE YOUR ID HERE ⚠️
            # This prevents accidental formatting if drive letters change (e.g. sda -> sdb)
    --      device = "/dev/disk/by-id/nvme-BC511_NVMe_SK_hynix_512GB_CY06T000310606K23"; 
    ++      device = "/dev/disk/by-id/<your-main-disk-id>"; 
    ...
    ```

5. **Format the drive**:
Run this inside the top directory (where `format.bash` is located).
```bash
    ./format.bash <your_hostname>
```

6. **Edit `hosts/<your_hostname>/local-packages.nix` and `nixos/packages.nix` files if needed**:

    ```bash
    vim local-packages.nix
    vim ../../nixos/packages.nix
    ```

7. **Finally, edit the `flake.nix` file**:

    ```diff
    ...
      outputs = { self, nixpkgs, home-manager, ... }@inputs: let
        system = "x86_64-linux";
    --  homeStateVersion = "24.11";
    ++  homeStateVersion = "<your_home_manager_state_version>";
    --  user = "frittata";
    ++  user = "<your_username>";
        hosts = [
    --    { hostname = "calcolatore"; stateVersion = "24.05"; }
    ++    { hostname = "<your_hostname>"; stateVersion = "<your_state_version>"; }
        ];
    ...
    ```

8. **Rebuilding**:

    ```bash
    cd nixos
    git add .
    nixos-rebuild switch --flake ./#<hostname>
    # or nixos-install --flake ./#<hostname> if you are installing on a fresh system
    home-manager switch
    ```
