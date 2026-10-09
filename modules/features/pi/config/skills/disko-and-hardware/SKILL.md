---
name: disko-and-hardware
description: Change disk layout or hardware configuration in this repo safely. Use when editing _disko.nix, _hardware-configuration.nix, or anything that could touch disks.
---

# Disko and hardware

Disk layout lives in `modules/hosts/<host>/_disko.nix`; hardware config in
`modules/hosts/<host>/_hardware-configuration.nix`. Both are underscore-prefixed
so `import-tree` skips them; they are pulled in explicitly by the host config.

## Editing

- `_disko.nix` is a plain disko module: `disko.devices.disk.<name> = { ... }`.
  Keep `flake.diskoConfigurations.<host> = import ./_disko.nix;` working.
- `_hardware-configuration.nix` is regenerated with `nixos-generate-config`
  (`--root /mnt`) on the target machine; do not hand-edit kernel modules lightly.
- After changing, always verify with a host eval (`/verify`).

## Destructive commands — never run without an explicit request

`./format.bash <host>` runs `disko --mode destroy,format,mount`, which **erases
the disks**. It is only for a fresh install. Never run it, `mkfs`, `wipefs`,
`fdisk`, `parted`, or `dd of=/dev/...` unless the user explicitly asks in that
message.

If the user does ask, confirm the target device and host first, and state
clearly that the operation is destructive before running it.
