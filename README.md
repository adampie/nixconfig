# nixconfig

## Install

### MacOS

1. Settings -> Privacy & Settings -> Full Disk Access -> Enable Terminal

1. Install Homebrew

   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

1. Install 1Password and configure
   1. Install

      ```sh
      eval "$(/opt/homebrew/bin/brew shellenv zsh)"
      brew install 1password --cask
      ```

   1. Configure SSH Agent
      - Settings - Developer
        - Show 1Password Developer Experience
        - Set up the SSH Agent -> Use Key Names -> Edit Automatically

1. Install [Determinate Nix](https://install.determinate.systems/determinate-pkg/stable/Universal)

1. Install nix-darwin and Apply Configuration
   1. Set up GitHub Keys

   ```sh
   ssh -T git@github.com
   ```

   1. Run nix-darwin

   ```sh
   sudo nix run nix-darwin -- switch --flake "https://flakehub.com/f/adampie/nixconfig/0#Adams-MacBook-Pro"
   ```

1. Settings -> Privacy & Settings -> Full Disk Access -> Enable Ghostty

1. Mac Settings
   - General
     - AutoFill from Passwords -> False

   - Desktop & Dock
     - Show Widgets On Desktop -> False

   - Displays
     - More Space

   - Spotlight
     - Show related content -> False
     - Help Apple Improve Search -> False

   - Privacy & Security
     - Location Services
       - Significant locations and routes -> False
       - Mac Analytics -> False
     - Advanced
       - Require an administrator password to access systemwide settings -> True

1. Application Settings
   - 1Password - Developer
     - Show 1Password Developer experience -> True
     - Use the SSH Agent -> True
     - Open SSH URLs with -> Ghostty
     - Integrate with 1Password CLI -> True
     - Check for developer credentials on disk -> True

   - Safari
     - AutoFill -> Disable all
     - Security -> Warn before connecting to a website over HTTP
     - Extensions -> Allow in Private Browsing
     - Advanced -> Show full website address
     - Advanced -> Show features for web developers
     - Active Wipr
