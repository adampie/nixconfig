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

## Managing Multiple Hosts and Distributions

### Multi-Host Directory Structure

Scale from one host to many by adding files under `modules/hosts/`:

```
modules/
├── dendritic.nix
├── host-options.nix
├── darwin-defaults.nix        ← shared across ALL darwin hosts
├── homebrew.nix               ← shared across ALL darwin hosts
├── git.nix                    ← shared across ALL hosts (home-manager)
├── shell.nix                  ← shared across ALL hosts
├── editors.nix                ← shared across ALL hosts
├── ...
└── hosts/
    ├── adams-macbook-pro.nix  ← Darwin (personal)
    ├── work-macbook.nix       ← Darwin (work)
    └── homelab-server.nix     ← NixOS  (server)
```

Every aspect module (git, shell, editors, etc.) is available to **all** hosts.
Each host file decides which modules to pull in and what host-specific values to set.

### Adding a Second Darwin Host

```nix
# modules/hosts/work-macbook.nix
{ inputs, config, lib, ... }: let
  system = "aarch64-darwin";
  darwinModules = lib.concatLists (builtins.attrValues config.flake.modules.darwin);
  hmModules = lib.concatLists (builtins.attrValues config.flake.modules.homeManager);
in {
  flake.darwinConfigurations."Work-MacBook" = inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    modules = darwinModules ++ [
      {
        host = {
          username = "adampie";
          hostname = "Work-MacBook";
          platform = "darwin";
          systemType = "work";      # ← different systemType
          architecture = "aarch64";
        };
      }
      inputs.home-manager.darwinModules.home-manager
      {
        nixpkgs.config.allowUnfree = true;
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.adampie.imports = hmModules;
        };
      }
    ];
  };
}
```

That host automatically gets **all** shared darwin and home-manager modules. No
imports to wire up.

### Adding a NixOS Host

First, extend the bootstrap to collect NixOS modules (already done in
`dendritic.nix` with `flake.modules.nixos`), then create the host:

```nix
# modules/hosts/homelab-server.nix
{ inputs, config, lib, ... }: let
  system = "x86_64-linux";
  nixosModules = lib.concatLists (builtins.attrValues config.flake.modules.nixos);
  hmModules = lib.concatLists (builtins.attrValues config.flake.modules.homeManager);
in {
  flake.nixosConfigurations."homelab" = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = nixosModules ++ [
      {
        host = {
          username = "adampie";
          hostname = "homelab";
          platform = "nixos";
          systemType = "server";
          architecture = "x86_64";
        };
      }
      inputs.home-manager.nixosModules.home-manager
      {
        nixpkgs.config.allowUnfree = true;
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.adampie.imports = hmModules;
        };
      }
    ];
  };
}
```

Aspect modules that define `flake.modules.homeManager.*` (git, shell, editors)
are shared with this host automatically. Modules that only define
`flake.modules.darwin.*` (darwin-defaults, homebrew) are naturally excluded because
the NixOS host only collects from `flake.modules.nixos`.

```
                      ┌─────────────┐
                      │  git.nix    │
                      │  shell.nix  │
                      │  editors.nix│  ← homeManager modules
                      │  ssh.nix    │    (shared by ALL hosts)
                      └──────┬──────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
     ┌────────▼────────┐    │    ┌─────────▼────────┐
     │ darwin-defaults  │    │    │ nixos-base.nix   │
     │ homebrew.nix     │    │    │ (future)         │
     │ (darwin only)    │    │    │ (nixos only)     │
     └────────┬────────┘    │    └─────────┬────────┘
              │              │              │
     ┌────────▼─────┐  ┌────▼─────┐  ┌────▼──────────┐
     │Adams-MacBook  │  │Work-Mac  │  │homelab-server │
     │(personal)     │  │(work)    │  │(server/nixos) │
     └──────────────┘  └──────────┘  └───────────────┘
```

### Including Modules Selectively Per Host

Not every host needs every module. There are three ways to handle this:

#### Strategy 1: Conditional Logic Inside Aspect Modules

Use the `host.*` options to gate configuration:

```nix
# modules/homebrew.nix — only applies to personal machines
{ ... }: {
  flake.modules.darwin.homebrew = { config, lib, ... }: {
    homebrew = lib.mkIf config.isPersonal {
      enable = true;
      onActivation = {
        autoUpdate = true;
        cleanup = "zap";
        upgrade = true;
      };
      casks = [
        "1password"
        "discord"
        "spotify"
      ];
    };
  };
}
```

```nix
# modules/git.nix — different signing key per systemType
{ ... }: {
  flake.modules.homeManager.git = { config, lib, ... }: {
    programs.git = {
      enable = true;
      userName = "Adam Pietrzycki";
      signing = lib.mkMerge [
        (lib.mkIf config.isPersonal {
          key = "ssh-ed25519 AAAA...personal-key";
          signByDefault = true;
        })
        (lib.mkIf config.isWork {
          key = "ssh-ed25519 AAAA...work-key";
          signByDefault = true;
        })
      ];
    };
  };
}
```

#### Strategy 2: Separate Modules Per Variant

Split a feature into base + variant files:

```
modules/
├── git.nix              ← base git config (shared by all)
├── git-personal.nix     ← personal signing key, personal email
└── git-work.nix         ← work signing key, work email
```

```nix
# modules/git.nix — base, always loaded
{ ... }: {
  flake.modules.homeManager.git = { ... }: {
    programs.git = {
      enable = true;
      userName = "Adam Pietrzycki";
      defaultBranch = "main";
    };
  };
}

# modules/git-personal.nix — personal additions
{ ... }: {
  flake.modules.homeManager.git-personal = { lib, ... }: {
    programs.git = {
      settings.user.email = lib.mkDefault "adam@pietrzycki.com";
      signing = {
        key = "ssh-ed25519 AAAA...personal-key";
        signByDefault = true;
      };
    };
  };
}
```

Both are auto-loaded. If you only want `git-personal.nix` on personal hosts,
use `lib.mkIf` inside it, or use Strategy 3.

#### Strategy 3: Exclude Modules per Host with Import Filtering

Use `import-tree`'s filter API to give different hosts different module sets:

```nix
# modules/hosts/work-macbook.nix
{ inputs, config, lib, ... }: let
  system = "aarch64-darwin";

  # Collect all darwin modules EXCEPT personal-only ones
  darwinModules = lib.concatLists (
    builtins.attrValues (
      lib.filterAttrs (name: _: !lib.hasPrefix "personal-" name)
        config.flake.modules.darwin
    )
  );

  hmModules = lib.concatLists (
    builtins.attrValues (
      lib.filterAttrs (name: _: !lib.hasPrefix "personal-" name)
        config.flake.modules.homeManager
    )
  );
in {
  flake.darwinConfigurations."Work-MacBook" = inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    modules = darwinModules ++ [ /* ... */ ];
  };
}
```

Name your personal-only aspects with a `personal-` prefix:
```
modules/
├── git.nix              ← loaded by ALL hosts
├── personal-git.nix     ← loaded by personal hosts only (filtered out by work)
├── personal-homebrew.nix
└── hosts/
    ├── adams-macbook-pro.nix  ← includes everything
    └── work-macbook.nix       ← filters out personal-* aspects
```

### Overriding Settings Across Files

The Nix module system's merge semantics work across all dendritic modules.

#### Using `mkDefault` for Overridable Defaults

```nix
# modules/shell.nix — sets a default
{ ... }: {
  flake.modules.homeManager.shell = { lib, ... }: {
    programs.zsh = {
      enable = true;
      history.size = lib.mkDefault 1000000;
    };
  };
}

# modules/shell-server.nix — overrides for servers
{ ... }: {
  flake.modules.homeManager.shell-server = { config, lib, ... }: {
    programs.zsh.history.size = lib.mkIf config.isServer 10000;
  };
}
```

#### Priority Ordering

The module system merges all deferred modules. Standard Nix priority applies:

| Priority | Function        | Use case                          |
|----------|-----------------|-----------------------------------|
| 1500     | `lib.mkDefault` | "use this unless something else says otherwise" |
| 1000     | (normal)        | standard setting                  |
| 50       | `lib.mkForce`   | "always use this, override everything else"     |

```nix
# modules/editors.nix — default theme
{ ... }: {
  flake.modules.homeManager.editors = { lib, ... }: {
    programs.zed-editor.userSettings.theme.dark = lib.mkDefault "Dracula Solid";
  };
}

# modules/editors-work.nix — work overrides the theme
{ ... }: {
  flake.modules.homeManager.editors-work = { config, lib, ... }: {
    programs.zed-editor.userSettings.theme.dark =
      lib.mkIf config.isWork "GitHub Dark";
  };
}
```

#### Appending to Lists

Lists are concatenated by default across modules. Each module can contribute:

```nix
# modules/dev-tools.nix
{ ... }: {
  flake.modules.homeManager.dev-tools = { pkgs, ... }: {
    home.packages = with pkgs; [ gh jq ripgrep ];
  };
}

# modules/dev-tools-work.nix
{ ... }: {
  flake.modules.homeManager.dev-tools-work = { pkgs, config, lib, ... }: {
    home.packages = lib.mkIf config.isWork (with pkgs; [
      awscli2
      terraform
    ]);
  };
}

# Result on work machine: [ gh jq ripgrep awscli2 terraform ]
# Result on personal machine: [ gh jq ripgrep ]
```

### Quick Reference: Include, Exclude, Override

```
┌──────────────────────────────────────────────────────────────┐
│  INCLUDE (feature applies to host)                           │
│                                                              │
│  • Default: all modules apply to all hosts                   │
│  • Gate with: lib.mkIf config.isPersonal { ... }       │
│  • Or: name aspects with prefixes, collect selectively       │
├──────────────────────────────────────────────────────────────┤
│  EXCLUDE (feature does not apply to host)                    │
│                                                              │
│  • Temporary: mv file.nix _file.nix (import-tree ignores)   │
│  • Per-host: filter aspects by name in the host file         │
│  • Conditional: lib.mkIf (!config.isServer) { ... }    │
├──────────────────────────────────────────────────────────────┤
│  OVERRIDE (host changes a shared default)                    │
│                                                              │
│  • Set defaults: lib.mkDefault value                         │
│  • Override: just set the value (higher priority than        │
│    mkDefault)                                                │
│  • Force: lib.mkForce value (overrides everything)           │
│  • Merge lists: just set home.packages in multiple modules   │
│  • Merge attrs: module system deep-merges attribute sets     │
└──────────────────────────────────────────────────────────────┘
```

---

## Resources

- [Dendritic Pattern Spec](https://github.com/mightyiam/dendritic)
- [Dendritic Design with Flake-Parts Guide](https://github.com/Doc-Steve/dendritic-design-with-flake-parts)
- [import-tree](https://github.com/vic/import-tree)
- [Dendrix Community Distribution](https://github.com/vic/dendrix)
- [vic/vix Reference Config](https://github.com/vic/vix)
- [flake-parts](https://github.com/hercules-ci/flake-parts)
