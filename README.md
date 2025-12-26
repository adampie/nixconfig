# nixconfig

## Commands

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

## Install

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
    
    1. Run nix-darwin (fail)

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
        
        * Location Services
            
            * Significant locations and routes -> False
            * Mac Analytics -> False
    
        * Advanced
            
            * Require an administrator password to access systemwide settings -> True

1. Application Settings

    * 1Password - Deverloper
    
        * Show 1Password Developer experience -> True
        * Use the SSH Agent -> True
        * Open SSH URLs with -> Ghostty
        * Integrate with 1Password CLI -> True
        * Check for developer credentials on disk -> True

    * Safari
  
        * AutoFill -> Disable all
        * Extensions -> Allow in Private Browsing
        * Advanced -> Show full website address
        * Advanced -> Show features for web developers
        * Active Wipr
