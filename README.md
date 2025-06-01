# nixconfig

## Install

1. Install Homebrew

    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

2. Install Determinate Nix

    ```bash
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
    ```

    After installation, restart your terminal or source the Nix environment:

    ```bash
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    ```

3. Install nix-darwin and Apply Configuration

    ```bash
    sudo nix run nix-darwin -- switch --flake "https://flakehub.com/f/adampie/nixconfig/0#"
    ```

## Switch

```bash
sudo darwin-rebuild switch --flake .#
```

## Update

```bash
$ nixus

adampie@Mac:~/Code/adampie/nixconfig/ > nixus                                                 
warning: updating lock file "/Users/adampie/Desktop/nixconfig/flake.lock":
• Updated input 'nixpkgs-unstable':
    '...' (2025-05-28)
  → '...' (2025-05-31)
building the system configuration...
claude-code: 1.0.3 → 1.0.6, -13.0 KiB
Apply changes? (y/n): y
...
```
