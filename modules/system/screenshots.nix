# macOS Screenshots location
# Note: Username is shared via let binding from host configuration
{...}:
let
  # Default location - will be overridden by host-specific config if needed
  username = "adampie";
in {
  flake.modules.darwin.screenshots = {
    system.defaults.screencapture.location = "/Users/${username}/Screenshots";
  };
}
