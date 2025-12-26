# nixconfig

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

1. Application Settings

  1. Safari
  
    * AutoFill -> Disable all
    * Extensions -> Allow in Private Browsing
    * Advanced -> Show full website address
    * Advanced -> Show features for web developers
    * Active Wipr

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
