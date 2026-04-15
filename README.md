# nixconfig

## Install

### MacOS

1. Settings → Privacy & Settings → Full Disk Access → Enable Terminal

2. Install Homebrew

   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. Install 1Password and configure
   1. Install

      ```sh
      eval "$(/opt/homebrew/bin/brew shellenv zsh)"
      brew install 1password --cask
      ```

   2. Configure SSH Agent
      - Settings - Developer
        - Show 1Password Developer Experience
        - Set up the SSH Agent → Use Key Names → Edit Automatically

4. Install [Determinate Nix](https://install.determinate.systems/determinate-pkg/stable/Universal)

5. Install nix-darwin and Apply Configuration
   1. Set up GitHub Keys

   ```sh
   ssh -T git@github.com
   ```

   1. Run nix-darwin

   ```sh
   sudo nix run nix-darwin -- switch --flake "https://flakehub.com/f/adampie/nixconfig/0#Adams-MacBook-Pro"
   ```

6. Settings → Privacy & Settings → Full Disk Access → Enable Ghostty
