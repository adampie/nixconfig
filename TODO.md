# Dendritic Migration TODO

Migration from host-centric to feature-centric (aspect-oriented) Nix configuration using the [Dendritic pattern](https://dendrix.oeiuwq.com/Dendritic.html).

## 🎯 Goals

- [ ] Transform from host-centric to feature-centric organization
- [ ] Eliminate `specialArgs` and `extraSpecialArgs` usage
- [ ] Auto-load modules using `import-tree`
- [ ] Auto-generate `flake.nix` using `flake-file`
- [ ] Create fine-grained feature modules with aspect-oriented design
- [ ] Enable easy feature reusability across future hosts

---

## Phase 1: Foundation Setup

### 1.1 Backup & Preparation
- [x] Create git branch `pre-dendritic` for backup
- [x] Commit any uncommitted changes
- [x] Document current system state (run `darwin-rebuild build` successfully)

### 1.2 Update flake.nix Structure
- [ ] Add `flake-parts` input
- [ ] Add `import-tree` input (github:vic/import-tree)
- [ ] Add `flake-file` input (github:vic/flake-file)
- [ ] Rewrite flake.nix to minimal form (~15 lines)
- [ ] Move all flake inputs to be declared by modules (via flake-file)
- [ ] Test: `nix flake show` works

### 1.3 Create Infrastructure Modules
- [ ] Create `modules/_lib.nix` to expose lib functions
- [ ] Test: Verify lib functions are accessible in flake-parts

---

## Phase 2: Feature Extraction - System Features

Extract from `modules/darwin/default.nix` (144 lines) into fine-grained modules:

### 2.1 macOS System Configuration
- [ ] Create `modules/system/dock.nix`
  - Lines: 78-90 (`system.defaults.dock`)
- [ ] Create `modules/system/finder.nix`
  - Lines: 92-102 (`system.defaults.finder`)
- [ ] Create `modules/system/security.nix`
  - Lines: 132-141 (`networking.applicationFirewall`, `security.pam`)
- [ ] Create `modules/system/keyboard.nix`
  - Lines: 54-75 (`CustomUserPreferences.AppleSymbolicHotKeys`)
- [ ] Create `modules/system/macos-defaults.nix`
  - Lines: 19-33 (`system.defaults.NSGlobalDomain`)
- [ ] Create `modules/system/safari.nix`
  - Lines: 44-53 (`CustomUserPreferences."com.apple.Safari"`)
- [ ] Create `modules/system/privacy.nix`
  - Lines: 37-43 (AdLib, AppleIntelligenceReport, desktopservices)
- [ ] Create `modules/system/screenshots.nix`
  - Lines: 116 (`system.defaults.screencapture`)
- [ ] Create `modules/system/loginwindow.nix`
  - Lines: 104-107 (`system.defaults.loginwindow`)
- [ ] Create `modules/system/menubar.nix`
  - Lines: 109 (`system.defaults.menuExtraClock`)
- [ ] Create `modules/system/screensaver.nix`
  - Lines: 111-114 (`system.defaults.screensaver`)
- [ ] Create `modules/system/trackpad.nix`
  - Lines: 118 (`system.defaults.trackpad`)
- [ ] Create `modules/system/window-manager.nix`
  - Lines: 120-123 (`system.defaults.WindowManager`)
- [ ] Create `modules/system/software-update.nix`
  - Lines: 35 (`system.defaults.SoftwareUpdate`)

### 2.2 System Base Configuration
- [ ] Create `modules/system/nix-daemon.nix`
  - Lines: 9 (`nix.enable = false`)
- [ ] Create `modules/system/home-manager-config.nix`
  - Lines: 11-14 (`home-manager` overwrite settings)
- [ ] Create `modules/system/state-version.nix`
  - Lines: 17 (`system.stateVersion`)

---

## Phase 3: Feature Extraction - User Features

Extract from `users/adampie/default.nix` (278 lines) into fine-grained modules:

### 3.1 Shell Environment
- [ ] Create `modules/shell/zsh.nix`
  - Lines: 258-268 (`programs.zsh`)
- [ ] Create `modules/shell/starship.nix`
  - Lines: 137-150 (`programs.starship`)

### 3.2 Development Tools
- [ ] Create `modules/dev/git.nix`
  - Lines: 114-120 + `users/adampie/personal.nix:16-36`
  - Include conditional email config for fricory/
- [ ] Create `modules/dev/mise.nix`
  - Lines: 124-135 (`programs.mise`)
- [ ] Create `modules/dev/devenv.nix`
  - Line: 42 (package)
- [ ] Create `modules/dev/jetbrains.nix`
  - Lines: 65-69 (launcher scripts)
  - Use `mkJetBrainsDarwinScript` function

### 3.3 Editors & Terminal
- [ ] Create `modules/editors/zed.nix`
  - Lines: 171-256 (`programs.zed-editor`)
  - Include personal overrides from `users/adampie/personal.nix:38-42`
- [ ] Create `modules/terminal/ghostty.nix`
  - Lines: 152-169 (`programs.ghostty`)

### 3.4 Security
- [ ] Create `modules/security/ssh.nix`
  - Lines: 271-276 (`home.file.".ssh/config"`)
- [ ] Create `modules/security/gpg.nix`
  - Line: 122 (`programs.gpg`)

### 3.5 Packages
- [ ] Create `modules/packages/cli-tools.nix`
  - Lines: 39-51 (cosign, curl, devenv, fh, jq, ripgrep, wget, yq, etc.)
- [ ] Create `modules/packages/fonts.nix`
  - Line: 45 (`nerd-fonts.hack`)

### 3.6 Scripts & Utilities
- [ ] Create `modules/scripts/fetch-all-code.nix`
  - Lines: 71-109 (ghorg wrapper script)
  - Lines: 5-12 from `users/adampie/personal.nix` (fac shortcut)

### 3.7 Privacy & Configuration
- [ ] Create `modules/telemetry/disable.nix`
  - Lines: 20-31 (`sessionVariables` for NO_TELEMETRY, etc.)
- [ ] Create `modules/homebrew/environment.nix`
  - Lines: 54-60 (`home.file.".homebrew/brew.env"`)

### 3.8 Home Manager Base
- [ ] Create `modules/home/base.nix`
  - Lines: 8-18 (username, homeDirectory, stateVersion, directory creation)
  - Lines: 33-37 (sessionPath)
  - Lines: 62-64 (.hushlogin, .local/bin/.keep)

---

## Phase 4: Host Configuration

### 4.1 Transform Host Configuration
- [ ] Create `modules/hosts/adams-macbook-pro.nix`
  - Declare all inputs via `flake-file.inputs`
  - Create `darwinConfigurations."Adams-MacBook-Pro"`
  - Import system feature modules (darwin)
  - Configure home-manager with user feature modules
  - Add host-specific packages (gh, ghorg, osv-scanner, neofetch)
  - Move homebrew configuration here

### 4.2 Homebrew Configuration
- [ ] Decide: Keep in host file or extract to `modules/homebrew/config.nix`?
- [ ] Extract taps configuration
- [ ] Extract brews list
- [ ] Extract casks list  
- [ ] Extract masApps
- [ ] Extract onActivation settings

---

## Phase 5: Cleanup & Testing

### 5.1 Archive Old Files
- [ ] Create `_archive/` directory
- [ ] Move `hosts/` → `_archive/hosts/`
- [ ] Move `users/` → `_archive/users/`
- [ ] Move old `modules/darwin/` → `_archive/modules/darwin/`
- [ ] Move old `modules/host/` → `_archive/modules/host/`
- [ ] Keep `lib/` directory (still used)

### 5.2 Incremental Testing Strategy
- [ ] Test after extracting each system feature group
  - `nix flake check`
  - `darwin-rebuild build --flake .#`
- [ ] Test after extracting each user feature group
- [ ] Full test after host configuration
  - `darwin-rebuild build --flake .#`
  - Compare output with pre-migration build
  - `nix store diff-closures /run/current-system ./result`

### 5.3 Final Validation
- [ ] Build successfully: `darwin-rebuild build --flake .#`
- [ ] Verify all features are working
- [ ] Test that new modules can be added by just creating files
- [ ] Test that features can be disabled by renaming with `_` prefix
- [ ] Commit to `dendritic-migration` branch

---

## Phase 6: Documentation

### 6.1 Update Documentation
- [ ] Update README.md with Dendritic approach explanation
- [ ] Document the new directory structure
- [ ] Add examples of common operations:
  - Adding a new feature module
  - Disabling a feature temporarily
  - Adding a new host
  - Sharing feature modules
- [ ] Document the aspect-oriented design philosophy
- [ ] Add references to Dendritic documentation

### 6.2 Create Module Documentation
- [ ] Add comments to each module explaining what aspect it configures
- [ ] Document shared values (let bindings) used across classes
- [ ] Create examples for each major module category

---

## Phase 7: Final Migration

### 7.1 Deploy & Verify
- [ ] Switch to new configuration: `sudo darwin-rebuild switch --flake .#`
- [ ] Verify system works as before
- [ ] Test all applications open correctly
- [ ] Test all CLI tools work
- [ ] Test git signing works
- [ ] Test SSH works
- [ ] Test 1Password integration works

### 7.2 Cleanup
- [ ] Delete `_archive/` directory (after confirmation everything works)
- [ ] Remove pre-migration branch (optional, keep as reference)
- [ ] Update flake.lock: `nix flake update`
- [ ] Final commit to main branch

---

## Benefits Checklist (Post-Migration Validation)

Verify these advantages are achieved:

- [ ] ✅ No more `specialArgs` or `extraSpecialArgs` usage
- [ ] ✅ All values shared via let bindings or flake-parts options
- [ ] ✅ No manual imports - all modules auto-loaded
- [ ] ✅ Feature closures - all related config in one file
- [ ] ✅ Minimal flake.nix (~15 lines, auto-generated)
- [ ] ✅ Can add new feature by just creating a file
- [ ] ✅ Can disable feature by prefixing filename with `_`
- [ ] ✅ Ready to add new hosts easily
- [ ] ✅ Modules are shareable with community
- [ ] ✅ Can create incremental features (e.g., git/advanced.nix)

---

## Open Questions

Track decisions needed during migration:

- [ ] Should homebrew config stay in host file or be extracted to separate module?
- [ ] Should we create a "personal" profile module that bundles common features?
- [ ] How should we handle the `stablepkgs` pattern in Dendritic style?
- [ ] Should JetBrains launcher scripts be part of jetbrains.nix or separate script module?
- [ ] Keep mise.toml or move tasks into flake-parts?

---

## Notes & Decisions

**Date**: 2026-01-27

**Approach Chosen**: Full Dendritic migration with:
- ✅ flake-parts based modules
- ✅ Auto-generated flake.nix (vic/flake-file)
- ✅ Automatic module loading (vic/import-tree)
- ✅ Fine-grained feature modules
- ✅ Explicit feature lists per host (not profiles)

**Key Insights**:
- Current structure: 7 .nix files, mostly monolithic
- Target structure: ~35 fine-grained feature modules
- Main challenge: Breaking apart 278-line user config and 144-line system config
- Migration can be done incrementally - test after each feature extraction

---

## Progress Tracking

**Last Updated**: 2026-01-27

**Current Phase**: Phase 1 - Foundation Setup

**Completed Tasks**: 0 / ~90

**Blocked Tasks**: None

**Next Steps**: 
1. Create backup branch
2. Update flake.nix inputs
3. Begin system feature extraction

---

## Resources

- [Dendritic Pattern Docs](https://dendrix.oeiuwq.com/Dendritic.html)
- [DocSteve's Dendritic Design Guide](https://github.com/Doc-Steve/dendritic-design-with-flake-parts)
- [Pol Dellaiera's "Flipping the Configuration Matrix"](https://not-a-number.io/2025/refactoring-my-infrastructure-as-code-configurations/)
- [flake-parts Documentation](https://flake.parts)
- [vic/import-tree](https://github.com/vic/import-tree)
- [vic/flake-file](https://github.com/vic/flake-file)
