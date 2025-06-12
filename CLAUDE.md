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
- `fetch_all_code <scm> <type> <account>` - Clone all repositories from SCM accounts using 1Password tokens
- `fac` - Profile-specific wrapper for bulk repository cloning (calls fetch_all_code with predefined parameters)

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
- All configurations support both stable (`nixpkgs`) and unstable (`nixpkgs-unstable`) channels
- Helper functions (`mkJetBrainsScript`, `mkClaudeFiles`) programmatically generate configurations
- Profile inheritance: shared → personal/work with clean layering
- Built-in Nix daemon disabled (`nix.enable = false`) in favor of external Nix installation

### Development Environment Features
- Mise for runtime version management
- 1Password integration for SSH, GPG signing, and automated token retrieval
- Ghostty terminal with Dracula theme and JetBrains Mono font
- GPG and SSH properly configured for development workflows
- TouchID enabled for sudo authentication
- Comprehensive privacy defaults (NO_TELEMETRY, DO_NOT_TRACK, analytics disabled)
- Claude Code configuration automatically synchronized from repository

### Security and Privacy
- Homebrew security flags enabled (`--require-sha` for casks)
- Telemetry and analytics disabled across all tools
- 1Password SSH agent and GPG signing integration
- Custom screencapture location and system appearance settings
- Automatic `.claude/` directory and memory file synchronization
