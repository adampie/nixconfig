# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Apply Commands

Use mise tasks (preferred) or direct commands:

```sh
mise run plan     # Build and diff against current system
mise run apply    # sudo switch to new configuration
mise run fmt      # Format with nixfmt-tree
mise run check    # nix flake check --all-systems
mise run update   # Update flake.lock and stage it
mise run gc       # Garbage collect nix store
```

Direct commands:
```sh
# macOS
darwin-rebuild build --flake .#
sudo darwin-rebuild switch --flake .#

# NixOS (tower)
nixos-rebuild build --flake .#tower
sudo nixos-rebuild switch --flake .#tower
```

## Architecture

This is a Nix flake using **flake-parts** + **import-tree** to manage two hosts:
- **Adams-MacBook-Pro** — `aarch64-darwin`, nix-darwin
- **tower** — `x86_64-linux`, NixOS with LUKS encryption, NVIDIA, GNOME

**import-tree** auto-imports every `.nix` file under `modules/` as a flake-parts module. New files must be `git add`ed or the flake won't see them.

## Module System

Three module types, each set via `flake.<type>.<name>`:

| Type | Option type | Used by |
|------|------------|---------|
| `homeModules` | `types.raw` (custom) | Both hosts |
| `darwinModules` | `types.raw` (custom) | MacBook only |
| `nixosModules` | `types.deferredModule` (flake-parts built-in) | Tower only |

Every module file follows this pattern:
```nix
{ ... }:
{
  flake.homeModules.moduleName =
    { pkgs, ... }:
    {
      # home-manager options here
    };
}
```

Modules are imported by hosts via `self.homeModules.moduleName` (or `darwinModules`/`nixosModules`).

## Key Conventions

- Module names use **camelCase** (e.g., `packagesCommon`, `nixIndex`)
- Platform differences use `pkgs.stdenv.isDarwin` conditionals
- Host configs in `modules/hosts/<hostname>/default.nix` define both `flake.<type>Configurations.<host>` and the host's module
- Tower hardware/boot/GPU config lives in `hardware-configuration.nix`, disk layout in `disko.nix`
- Disko manages `fileSystems`/`swapDevices` declaratively — partition labels must match the actual disk (`root`, `swap`, `ESP`)
- Formatter is `nixfmt-tree` (`nix fmt .`)

## Hosts

**MacBook** (`modules/hosts/Adams-MacBook-Pro/default.nix`): imports darwinModules (homebrew, system defaults) + homeModules. Username `adampie`, home `/Users/adampie`.

**Tower** (`modules/hosts/tower/default.nix`): imports nixosModules (gnome, disko, hardware) + homeModules. Username `adampie`, home `/home/adampie`. Uses systemd-boot, LUKS encryption, NVIDIA open drivers, PipeWire audio, Podman containers.
