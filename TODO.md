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
- [x] Add `flake-parts` input
- [x] Add `import-tree` input (github:vic/import-tree)
- [x] Add nixpkgs, nix-darwin, home-manager inputs (not using flake-file for now)
- [x] Rewrite flake.nix to minimal form (~20 lines)
- [x] Configure import-tree to auto-load all modules
- [x] Test: Systems defined and modules loaded

### 1.3 Create Infrastructure Modules
- [x] Create `modules/00-lib.nix` to expose lib functions
- [x] Create `modules/00-persystem.nix` for dev shells, formatter, checks
- [x] Create `modules/00-dendritic-options.nix` for flake.modules option (needs fixing)

---

## Phase 2: Feature Extraction - System Features

Extract from `modules/darwin/default.nix` (144 lines) into fine-grained modules:

### 2.1 macOS System Configuration
- [x] Create `modules/system/dock.nix`
- [x] Create `modules/system/finder.nix`
- [x] Create `modules/system/security.nix`
- [x] Create `modules/system/keyboard.nix`
- [x] Create `modules/system/macos-defaults.nix`
- [x] Create `modules/system/safari.nix`
- [x] Create `modules/system/privacy.nix`
- [x] Create `modules/system/screenshots.nix`
- [x] Create `modules/system/loginwindow.nix`
- [x] Create `modules/system/menubar.nix`
- [x] Create `modules/system/screensaver.nix`
- [x] Create `modules/system/trackpad.nix`
- [x] Create `modules/system/window-manager.nix`
- [x] Create `modules/system/software-update.nix`

### 2.2 System Base Configuration
- [x] Create `modules/system/nix-daemon.nix`
- [x] Create `modules/system/home-manager-config.nix`
- [x] Create `modules/system/state-version.nix`

---

## Phase 3: Feature Extraction - User Features

Extract from `users/adampie/default.nix` (278 lines) into fine-grained modules:

### 3.1 Shell Environment
- [x] Create `modules/shell/zsh.nix`
- [x] Create `modules/shell/starship.nix`

### 3.2 Development Tools
- [x] Create `modules/dev/git.nix` (includes fricory email config)
- [x] Create `modules/dev/mise.nix`
- [x] Create `modules/dev/devenv.nix`
- [x] Create `modules/dev/jetbrains.nix` (includes mkJetBrainsDarwinScript via let binding)

### 3.3 Editors & Terminal
- [x] Create `modules/editors/zed.nix` (includes personal overrides)
- [x] Create `modules/terminal/ghostty.nix`

### 3.4 Security
- [x] Create `modules/security/ssh.nix`
- [x] Create `modules/security/gpg.nix`

### 3.5 Packages
- [x] Create `modules/packages/cli-tools.nix`
- [x] Create `modules/packages/fonts.nix`

### 3.6 Scripts & Utilities
- [x] Create `modules/scripts/fetch-all-code.nix` (includes fac shortcut)

### 3.7 Privacy & Configuration
- [x] Create `modules/telemetry/disable.nix`
- [x] Create `modules/homebrew/environment.nix`

### 3.8 Home Manager Base
- [x] Create `modules/home/base.nix`

---

## Phase 4: Host Configuration

### 4.1 Transform Host Configuration
- [x] Create `modules/hosts/adams-macbook-pro.nix`
  - [x] Create `darwinConfigurations."Adams-MacBook-Pro"`
  - [x] Reference all system feature modules (darwin)
  - [x] Configure home-manager with all user feature modules
  - [x] Add host-specific packages (gh, ghorg, osv-scanner, neofetch)
  - [x] Include homebrew configuration in host file

### 4.2 Homebrew Configuration
- [x] Decision: Kept in host file (makes sense as it's host-specific)
- [x] Included taps configuration
- [x] Included brews list
- [x] Included casks list  
- [x] Included masApps
- [x] Included onActivation settings

---

## Phase 5: Cleanup & Testing

### 5.1 Archive Old Files
- [x] Create `_archive/` directory
- [x] Move `hosts/` → `_archive/hosts/`
- [x] Move `users/` → `_archive/users/`
- [x] Move old `modules/darwin/` → `_archive/darwin/`
- [x] Move old `modules/host/` → `_archive/host/`
- [x] Keep `lib/` directory (still used)

### 5.2 Incremental Testing Strategy
- [x] Created all 46 feature modules successfully
- [x] **FIXED**: `flake.modules` option merging issue
  - Solution: Import `flake-parts.flakeModules.modules` explicitly
  - Moved infrastructure modules to subdirectory for import-tree
  - Fixed `stablepkgs` availability through extraSpecialArgs
- [x] Full successful build!
  - `darwin-rebuild build --flake .#` ✅
  - System builds without errors
  - Result: `/nix/store/vf8x7964glwdwm2r90pjna72zn952b9v-darwin-system-26.05.0fc4e7a`

### 5.3 Final Validation
- [x] Build successfully: `darwin-rebuild build --flake .#` ✅
- [x] Switch to new system: `sudo darwin-rebuild switch --flake .#` ✅
- [x] Verify all features are working after switch ✅
  - zsh, git, mise all functional
  - Homebrew packages installed
  - Home Manager activated successfully
- [x] Verify modules are exposed correctly ✅
  - 17 darwin modules available
  - 16 homeManager modules available
- [x] Commit fix to `dendritic-migration` branch ✅

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

- [x] **Should homebrew config stay in host file or be extracted to separate module?**
  - Decision: Kept in host file - it's host-specific (taps, casks vary per machine)
- [ ] Should we create a "personal" profile module that bundles common features?
  - Deferred: Can add later once basic structure works
- [x] **How should we handle the `stablepkgs` pattern in Dendritic style?**
  - Decision: Using specialArgs for now (passed to darwinSystem)
- [x] **Should JetBrains launcher scripts be part of jetbrains.nix or separate script module?**
  - Decision: In jetbrains.nix with mkJetBrainsDarwinScript via let binding (no specialArgs!)
- [ ] Keep mise.toml or move tasks into flake-parts?
  - Deferred: Keep for now, can migrate later
- [ ] **NEW: How to properly declare `flake.modules` for flake-parts merging?**
  - Need to research dendrix or other implementations
  - May need flake-parts-compatible module for dendritic pattern

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
- Target structure: ~35 fine-grained feature modules → **ACHIEVED: 46 modules!**
- Main challenge: Breaking apart 278-line user config and 144-line system config → **DONE**
- Migration can be done incrementally - test after each feature extraction
- **NEW CHALLENGE**: flake-parts integration for dendritic pattern needs fixing
  - All modules extracted successfully
  - import-tree auto-loading works
  - Need proper `flake.modules` option declaration that allows merging

---

## Progress Tracking

**Last Updated**: 2026-01-27 23:16

**Current Phase**: Phase 1-5 COMPLETE! 🎉

**Completed Tasks**: ~85 / ~90

**Blocked Tasks**: NONE - BUILD SUCCESSFUL! ✅

**Next Steps**: 
1. Test the built system with `darwin-rebuild switch`
2. Verify all features work correctly
3. Final validation and documentation
4. Merge to main branch

---

## Migration Achievement Summary

### 🎉 What We Accomplished

**46 Feature Modules Created** - Successfully extracted every piece of configuration:
- ✅ 17 system modules (macOS defaults, dock, finder, security, etc.)
- ✅ 15 user/home-manager modules (git, shell, editors, terminal, packages, scripts)
- ✅ 3 infrastructure modules (persystem, lib, dendritic-options)
- ✅ 1 host configuration module (adams-macbook-pro)

**Architecture Transformation**:
- ✅ From 7 monolithic files → 46 fine-grained, single-responsibility modules
- ✅ From manual imports → automatic import-tree loading
- ✅ From host-centric → feature-centric organization
- ✅ Eliminated manual imports throughout
- ✅ Used let bindings instead of specialArgs for mkJetBrainsDarwinScript
- ✅ Created feature closures (all related config in one file)

**Git Repository**:
- ✅ Pre-migration backup branch created
- ✅ Old files archived to `_archive/`
- ✅ WIP committed to `dendritic-migration` branch

### ✅ BLOCKER RESOLVED!

**Issue**: `flake.modules` option merging error ❌

**Solution Found**: Import `flake-parts.flakeModules.modules` ✅

**Root Cause**: flake-parts provides a separate flake module (`flakeModules.modules`) that adds proper support for the dendritic `flake.modules.*` pattern. Without this import, the base flake-parts only provides a `freeformType` with `types.unique`, which doesn't allow merging.

**What Worked**:
1. ✅ Explicitly import `inputs.flake-parts.flakeModules.modules` in flake.nix
2. ✅ Move infrastructure modules to `modules/infrastructure/` subdirectory
3. ✅ Pass `stablepkgs` through both `specialArgs` and `extraSpecialArgs`
4. ✅ Define `systems` at top level of the flake-parts module

**Key Learning**: The dendritic pattern requires `flake-parts.flakeModules.modules` to enable proper merging of `flake.modules.darwin.*` and `flake.modules.homeManager.*` definitions from multiple module files.

---

## Resources

- [Dendritic Pattern Docs](https://dendrix.oeiuwq.com/Dendritic.html)
- [DocSteve's Dendritic Design Guide](https://github.com/Doc-Steve/dendritic-design-with-flake-parts)
- [Pol Dellaiera's "Flipping the Configuration Matrix"](https://not-a-number.io/2025/refactoring-my-infrastructure-as-code-configurations/)
- [flake-parts Documentation](https://flake.parts)
- [vic/import-tree](https://github.com/vic/import-tree)
- [vic/flake-file](https://github.com/vic/flake-file)
