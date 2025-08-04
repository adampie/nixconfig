# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

### Configuration Management
- `nixus` - Update flake inputs, build configuration, show diff, and apply changes (recommended workflow)
  - Fetches git changes, updates flake inputs, builds config, analyzes changes, and applies with confirmation
  - Shows Nix package changes, Homebrew updates, and Mac App Store updates
  - Automatically commits and pushes changes after successful application
- `sudo darwin-rebuild switch --flake .#` - Apply configuration changes directly
- `darwin-rebuild build --flake .#` - Build configuration without switching (for testing)
- `nix flake update` - Update all flake inputs manually
- `nix flake check` - Validate flake configuration syntax, run automated checks (statix, deadnix, format)

### Development
- `nix develop` - Enter development shell with alejandra, statix, deadnix, nil, nixd, git, gh
- `nix fmt` - Format all Nix files using alejandra formatter
- `alejandra .` - Format Nix files directly
- `statix check` - Run Nix linter to find anti-patterns
- `deadnix` - Find unused Nix code
- JetBrains IDE shortcuts: `idea`, `pycharm`, `goland`, `datagrip`, `webstorm` (launches IDEs from command line)
- `fetch_all_code <scm> <type> <account>` - Clone all repositories from SCM accounts using 1Password tokens
- `fac` - Profile-specific wrapper for bulk repository cloning (calls fetch_all_code with predefined parameters)

## Architecture Overview

This is a flake-based nix-darwin configuration supporting multiple Apple Silicon MacBooks with a sophisticated profile system.

### Core Structure
- **Hosts** (`hosts/darwin/`): Machine-specific configurations that import profiles and set host options
- **Profiles** (`profiles/`): Modular configurations organized by use case (shared, personal, work)
- **System Modules** (`modules/system/`): 
  - `common.nix`: Cross-platform host options and detection helpers
  - `darwin.nix`: macOS-specific system settings
- **Library** (`lib/default.nix`): Helper functions including mkDarwinSystem, mkJetBrainsDarwinScript, mkConditionalPackages

### Profile System
The configuration uses a three-tier profile approach with inheritance:

1. **Shared Profile** (`profiles/shared/`): Base configuration for all machines
   - `packages.nix`: Core CLI tools with platform conditionals
   - `programs.nix`: Program configurations (git, zsh, starship, mise)
   - `home.nix`: Base home-manager config, custom scripts (nixus, fetch_all_code)
   - `homebrew.nix`: Essential GUI apps and security settings

2. **Personal Profile** (`profiles/personal/`): Extensions for personal use
   - Inherits all shared configurations
   - Additional packages, personal apps, Mac App Store apps
   - Custom `fac` script for personal repository cloning

3. **Work Profile** (`profiles/work/`): Work-specific tooling
   - Inherits all shared configurations  
   - Kubernetes/Docker tools, work-specific `fac` script
   - Minimal additional GUI applications

### Key Configuration Patterns
- Host configurations set platform metadata: `platform`, `systemType`, `architecture`
- Common module provides detection helpers: `isDarwin`, `isPersonal`, `isWork`, etc.
- Package installation uses platform conditionals: `lib.optionals pkgs.stdenv.isDarwin`
- System module consolidates repeated attribute sets for efficiency
- Custom scripts installed to `~/.local/bin/` and automatically added to PATH
- Helper functions enable DRY principle (mkJetBrainsDarwinScript, mkClaudeFiles)

### Flake Structure
- **Inputs**: nixpkgs, nixpkgs-unstable, home-manager, nix-darwin, plus app-specific flakes
- **Outputs**:
  - `darwinConfigurations`: macOS system configurations
  - `devShells`: Development environment with Nix tooling
  - `checks`: Automated quality checks (format, lint, dead code)
  - `formatter`: alejandra for consistent formatting

### Development Standards
- Use `_:` for functions with no required arguments (not `{...}:`)
- Use `inherit` for cleaner attribute assignment
- Consolidate repeated attribute keys into single sets
- Remove unused function parameters and imports
- Run `nix flake check` before committing

## Important Notes

- The `nixus` script is the preferred update method - it shows comprehensive diffs before applying
- External Nix installation (Determinate Nix) is used with built-in daemon disabled (`nix.enable = false`)
- 1Password integration required for repository cloning and GPG/SSH operations
- Claude configuration files are automatically synchronized from the `claude/` directory
- Platform-specific packages only install where supported (e.g., mas only on Darwin)