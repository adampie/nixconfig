# nixconfig

**Dendritic Nix Configuration** - A feature-centric, aspect-oriented NixOS/nix-darwin configuration following the [Dendritic pattern](https://dendrix.oeiuwq.com/Dendritic.html).

## 🌳 Architecture

This configuration uses the **Dendritic pattern** with:
- ✅ **Feature-centric** organization (not host-centric)
- ✅ **Automatic module loading** via [import-tree](https://github.com/vic/import-tree)
- ✅ **Aspect-oriented** modules using [flake-parts](https://flake.parts)
- ✅ **Zero manual imports** - just create a file!
- ✅ **46 fine-grained modules** for maximum reusability

### Structure

```
modules/
├── infrastructure/   # Core: flake-parts, lib, persystem
├── dev/             # Development: git, mise, devenv, jetbrains
├── editors/         # Editors: zed
├── home/            # Home base configuration
├── homebrew/        # Homebrew environment
├── hosts/           # Host-specific configs
├── packages/        # Package sets: cli-tools, fonts
├── scripts/         # Custom scripts: fetch-all-code
├── security/        # Security: ssh, gpg
├── shell/           # Shell: zsh, starship
├── system/          # macOS system: dock, finder, security, etc.
├── telemetry/       # Privacy: disable telemetry
└── terminal/        # Terminal: ghostty
```

Each module follows the dendritic pattern:
```nix
{...}: {
  flake.modules.darwin.feature = { /* darwin config */ };
  flake.modules.homeManager.feature = { /* user config */ };
}
```

## 📚 Documentation

- **[MIGRATION_SUMMARY.md](MIGRATION_SUMMARY.md)** - Complete technical documentation of the dendritic architecture

## 🚀 Commands

### Switch 

```sh
sudo darwin-rebuild switch --flake .#
```

### Update

```sh
nix flake update
darwin-rebuild build --flake .#
sudo darwin-rebuild switch --flake .#
```

### Formatting

```sh
nix fmt .
nix flake check --all-systems
```

## ✨ Adding Features

### Create a New Feature Module

```nix
# modules/dev/docker.nix
{...}: {
  flake.modules.darwin.docker = {
    # macOS system config for Docker
  };
  
  flake.modules.homeManager.docker = {
    # User environment config for Docker
    programs.docker.enable = true;
  };
}
```

Then rebuild - **that's it!** The module is automatically loaded by import-tree.

### Add a New Host

```nix
# modules/hosts/work-laptop.nix
{inputs, ...}: {
  flake.darwinConfigurations.work-laptop = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [
      # Import the features you want
      inputs.self.modules.darwin.security
      inputs.self.modules.darwin.dock
      # ... etc
    ];
  };
}
```

## 📦 Available Modules

### Darwin Modules (17)
System-level macOS configuration:
- `dock`, `finder`, `keyboard`, `loginwindow`, `menubar`
- `macos-defaults`, `nix-daemon`, `privacy`, `safari`
- `screensaver`, `screenshots`, `security`, `software-update`
- `state-version`, `trackpad`, `window-manager`, `home-manager-config`

### Home Manager Modules (16)
User environment configuration:
- **Shell**: `zsh`, `starship`
- **Dev**: `git`, `mise`, `devenv`, `jetbrains`
- **Editors**: `zed`
- **Terminal**: `ghostty`
- **Security**: `ssh`, `gpg`
- **Packages**: `cli-tools`, `fonts`
- **Scripts**: `fetch-all-code`
- **Privacy**: `disable-telemetry`, `homebrew-environment`
- **Base**: `home-base`

## 🔧 Install

1. Check Hostname

1. Install Homebrew

    ```sh
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```
  
1. Install 1Password and configure

    1. Install
    
        ```sh
        brew install 1password --cask
        ```
  
    1. Configure SSH Agent

1. Install [Determinate Nix](https://install.determinate.systems/determinate-pkg/stable/Universal)

1. Install nix-darwin and Apply Configuration
  
    1. Set up GitHub Keys
  
    ```sh
    ssh -T git@github.com
    ```
    
    1. Run nix-darwin

    ```sh
    sudo nix run nix-darwin -- switch --flake "https://flakehub.com/f/adampie/nixconfig/0#"
    ```

    > If writing to `/etc/zshenv` fails, run `sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin`
  
1. Mac Settings

    * General
    
        * AutoFill from Passwords -> False

    * Desktop & Dock
        
        * Show Widgets On Desktop -> False

    * Displays
    
        * More Space

    * Spotlight
        
        * Show related content -> False
        * Help Apple Improve Search -> False

    * Privacy & Security
    
        * Full Disk Access
        
            * Ghostty -> True
        
        * Location Services
            
            * Significant locations and routes -> False
            * Mac Analytics -> False
    
        * Advanced
            
            * Require an administrator password to access systemwide settings -> True

1. Application Settings

    * 1Password - Developer
    
        * Show 1Password Developer experience -> True
        * Use the SSH Agent -> True
        * Open SSH URLs with -> Ghostty
        * Integrate with 1Password CLI -> True
        * Check for developer credentials on disk -> True

    * Safari
  
        * AutoFill -> Disable all
        * Security -> Warn before connecting to a website over HTTP
        * Extensions -> Allow in Private Browsing
        * Advanced -> Show full website address
        * Advanced -> Show features for web developers
        * Active Wipr

## 🙏 Credits

- **Dendritic Pattern**: [vic/dendrix](https://github.com/vic/dendrix)
- **flake-parts**: [hercules-ci/flake-parts](https://github.com/hercules-ci/flake-parts)
- **import-tree**: [vic/import-tree](https://github.com/vic/import-tree)
