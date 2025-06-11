# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

### Configuration Management
- `nixus` - Update flake inputs, build configuration, show diff, and apply changes (recommended workflow)
- `sudo darwin-rebuild switch --flake .#` - Apply configuration changes directly
- `darwin-rebuild build --flake .#` - Build configuration without switching (for testing)
- `nix flake update` - Update all flake inputs manually

### Development
- `nix fmt` - Format all Nix files using alejandra formatter
- JetBrains IDE shortcuts: `idea`, `pycharm`, `goland`, `datagrip` (launches IDEs from command line)

## Architecture Overview

This is a flake-based nix-darwin configuration supporting two Apple Silicon MacBooks with a sophisticated profile system.

### Core Structure
- **Hosts** (`hosts/darwin/`): Machine-specific configurations that import profiles and set hostname/username
- **Profiles** (`profiles/`): Modular configurations organized by use case (shared, personal, work)
- **System Module** (`modules/system/darwin.nix`): macOS system settings and custom options
- **Library** (`lib/default.nix`): Helper functions for Darwin system creation

### Profile System
The configuration uses a three-tier profile approach:

1. **Shared Profile**: Base packages, programs, and applications used across all machines
   - Core CLI tools (git, gh, ripgrep, starship, claude-code)
   - Essential GUI apps via Homebrew (1Password, terminals, IDEs)
   - Common program configurations (git, zsh, starship prompt)

2. **Personal Profile**: Extensions for personal use
   - Additional packages (goreleaser, neofetch, fh)
   - Personal applications (Claude, Discord, gaming tools)
   - Mac App Store apps (Flighty, Xcode)

3. **Work Profile**: Work-specific tooling
   - Kubernetes/Docker tools (kubectl, helm, dive)
   - Build tools (just)
   - Minimal additional GUI applications

### Package Management Strategy
- **Nix packages**: CLI tools and development utilities
- **Homebrew casks**: GUI applications that work better outside Nix
- **Mac App Store**: Apps requiring App Store distribution
- **Custom taps**: Private/proprietary software repositories

### Key Configuration Patterns
- Each host sets `host.username`, `host.hostname`, and `host.homeProfile` options
- System module automatically creates `~/Code` and `~/Screenshots` directories
- Custom scripts are placed in `~/.local/bin/` and added to PATH
- Homebrew configurations are split by profile and automatically managed
- All configurations support both stable and unstable nixpkgs channels

### Development Environment Features
- Mise for runtime version management
- 1Password integration for SSH and repository access
- Ghostty terminal with Dracula theme and JetBrains Mono font
- GPG and SSH properly configured for development workflows
- TouchID enabled for sudo authentication
