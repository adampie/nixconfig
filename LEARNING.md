# Dendritic Nix Design Pattern

A one-pager to understand the Dendritic pattern and how this repo was migrated to it.

---

## What is Dendritic?

Dendritic is a **configuration pattern** for Nix. Not a library, not a framework - just a way of organizing code. The core idea:

> **Every `.nix` file is a flake-parts module. No exceptions.**

This means every file has the same interpretation, can be auto-loaded, and freely renamed/moved.

---

## Before vs After

### Old Structure (Traditional)

```
nixconfig/
├── flake.nix              ← Big file with system creation logic
├── lib/
│   └── default.nix        ← Helper functions (mkDarwinSystem, etc.)
├── hosts/
│   └── darwin/
│       └── Adams-MacBook-Pro/
│           └── default.nix ← Host config (imports darwin module + users)
├── modules/
│   ├── darwin/
│   │   └── default.nix    ← macOS defaults (is a darwin module)
│   └── host/
│       └── options.nix    ← Host options (is a darwin module)
└── users/
    └── adampie/
        ├── default.nix    ← User config (is a home-manager module)
        └── personal.nix   ← Personal overrides (is a home-manager module)
```

**Problem:** Each file has a _different_ interpretation. `flake.nix` is a flake,
`lib/default.nix` is a function set, `modules/darwin/` files are darwin modules,
`users/` files are home-manager modules. You must _know_ what each file is before
you can use it.

### New Structure (Dendritic)

```
nixconfig/
├── flake.nix              ← Minimal: just inputs + import-tree
└── modules/
    ├── dendritic.nix      ← Bootstrap: defines module collection types
    ├── host-options.nix   ← Host options         (is a flake-parts module)
    ├── darwin-defaults.nix← macOS defaults        (is a flake-parts module)
    ├── homebrew.nix       ← Homebrew config       (is a flake-parts module)
    ├── user-adampie.nix   ← User base config      (is a flake-parts module)
    ├── git.nix            ← Git configuration      (is a flake-parts module)
    ├── shell.nix          ← Zsh + Starship         (is a flake-parts module)
    ├── editors.nix        ← Zed + Ghostty          (is a flake-parts module)
    ├── ssh.nix            ← SSH configuration       (is a flake-parts module)
    ├── scripts.nix        ← Custom scripts          (is a flake-parts module)
    ├── dev-tools.nix      ← Dev packages + shell    (is a flake-parts module)
    ├── formatter.nix      ← Formatter + checks      (is a flake-parts module)
    └── hosts/
        └── adams-macbook-pro.nix  ← Host definition (is a flake-parts module)
```

**Every single file is a flake-parts module.** No ambiguity.

---

## The Three Key Pieces

### 1. Minimal `flake.nix`

All logic moves out of `flake.nix` into modules. The flake becomes a manifest:

```nix
# BEFORE: flake.nix had ~120 lines of system creation logic
{
  outputs = { nixpkgs, nix-darwin, home-manager, ... }: let
    forEachSupportedSystem = ...;
    mkDarwinSystem = ...;
  in {
    darwinConfigurations = builtins.mapAttrs ...;
    devShells = forEachSupportedSystem ...;
    formatter = forEachSupportedSystem ...;
    checks = forEachSupportedSystem ...;
  };
}

# AFTER: flake.nix is 2 lines of logic
{
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; }
      (inputs.import-tree ./modules);
}
```

### 2. Auto-Loading with `import-tree`

No manual imports. Every `.nix` file under `./modules/` is discovered and loaded
automatically. Prefix a file or directory with `_` to exclude it.

```
modules/
├── git.nix          ← auto-loaded
├── shell.nix        ← auto-loaded
├── _experimental.nix ← IGNORED (underscore prefix)
└── _drafts/
    └── nixos.nix    ← IGNORED (parent has underscore)
```

### 3. Aspect-Oriented Modules via `flake.modules.<class>.<aspect>`

Each file configures a **feature** (aspect) across one or more **platforms** (classes):

```nix
# BEFORE: git config lived in users/adampie/default.nix (a home-manager module)
# mixed in with 200+ lines of other user config
{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Adam Pietrzycki";
    # ...
  };
  # ... 200 more lines of unrelated config
}

# AFTER: modules/git.nix - self-contained, single-purpose
{ ... }: {
  # This is a flake-parts module that contributes a home-manager sub-module
  flake.modules.homeManager.git = { ... }: {
    programs.git = {
      enable = true;
      userName = "Adam Pietrzycki";
      defaultBranch = "main";
      # All git config in one place
      settings = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        # ...
      };
    };
  };
}
```

---

## How Cross-Cutting Concerns Work

A single file can configure **multiple platforms** for the same feature:

```
┌─────────────────────────────────────────────────┐
│                modules/ssh.nix                   │
│                                                  │
│  ┌─ flake.modules.darwin.ssh ─────────────────┐ │
│  │  networking.applicationFirewall...          │ │
│  └────────────────────────────────────────────┘ │
│                                                  │
│  ┌─ flake.modules.homeManager.ssh ────────────┐ │
│  │  home.file.".ssh/config" = ...             │ │
│  └────────────────────────────────────────────┘ │
│                                                  │
│  ┌─ perSystem (formatter, checks, etc.) ──────┐ │
│  │  packages.ssh-tools = ...                  │ │
│  └────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────┘
```

In this repo, `ssh.nix` only needs home-manager config, so it only defines
`flake.modules.homeManager.ssh`. But if you needed darwin-level SSH settings too,
you'd add `flake.modules.darwin.ssh` in the same file.

---

## How the Host Wires Everything Together

```
┌──────────────────────────────────────────────────────────────┐
│                     flake-parts evaluation                    │
│                                                               │
│  import-tree loads ALL modules:                               │
│    git.nix → flake.modules.homeManager.git = <deferred>      │
│    shell.nix → flake.modules.homeManager.shell = <deferred>  │
│    darwin-defaults.nix → flake.modules.darwin.system = <def>  │
│    homebrew.nix → flake.modules.darwin.homebrew = <deferred>  │
│    ...                                                        │
│                                                               │
│  hosts/adams-macbook-pro.nix:                                │
│    Collects ALL darwin modules → darwinSystem { modules = }   │
│    Collects ALL hm modules → home-manager.users.adampie       │
│                                                               │
│    Result: flake.darwinConfigurations."Adams-MacBook-Pro"     │
└──────────────────────────────────────────────────────────────┘
```

---

## No More `specialArgs`

The old pattern passed values between modules using `specialArgs`:

```nix
# BEFORE: lib/default.nix
mkDarwinSystem = { ... }:
  nix-darwin.lib.darwinSystem {
    specialArgs = { inherit stablepkgs mkJetBrainsDarwinScript; };
    # Every module receives these as function arguments
  };

# BEFORE: users/adampie/default.nix
{ pkgs, mkJetBrainsDarwinScript, ... }:  # ← received via specialArgs
```

In the dendritic pattern, use **closures** instead:

```nix
# AFTER: modules/scripts.nix
{ ... }: let
  # Define helper locally - no need to pass it around
  mkJetBrainsDarwinScript = appName: appBinary: { ... };
in {
  flake.modules.homeManager.scripts = { ... }: { ... };
};

# AFTER: modules/dev-tools.nix
{ inputs, ... }: {
  # `inputs` comes from flake-parts, captured in closure
  flake.modules.homeManager.dev-tools = { pkgs, ... }: let
    stablepkgs = import inputs.nixpkgs-stable {
      inherit (pkgs) system;
      config.allowUnfree = true;
    };
  in { ... };
};
```

---

## Adding a New Feature

Just create a new file:

```nix
# modules/docker.nix
{ ... }: {
  flake.modules.darwin.docker = { ... }: {
    homebrew.casks = [ "docker" ];
  };

  flake.modules.homeManager.docker = { pkgs, ... }: {
    home.packages = [ pkgs.docker-compose ];
    home.file.".docker/config.json".text = builtins.toJSON { ... };
  };
}
```

That's it. No imports to update. No flake.nix changes. `import-tree` picks it up
automatically.

---

## Disabling a Feature

Prefix with `_`:

```bash
mv modules/docker.nix modules/_docker.nix
```

`import-tree` ignores it. No other changes needed.

---

## Resources

- [Dendritic Pattern Spec](https://github.com/mightyiam/dendritic)
- [Dendritic Design with Flake-Parts Guide](https://github.com/Doc-Steve/dendritic-design-with-flake-parts)
- [import-tree](https://github.com/vic/import-tree)
- [Dendrix Community Distribution](https://github.com/vic/dendrix)
- [vic/vix Reference Config](https://github.com/vic/vix)
- [flake-parts](https://github.com/hercules-ci/flake-parts)
