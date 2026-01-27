# macOS Security settings - Firewall and Touch ID
{...}:
let
  hostname = "Adams-MacBook-Pro";
in {
  flake.modules.darwin.security = {
    networking = {
      hostName = hostname;
      applicationFirewall = {
        enable = true;
        allowSigned = true;
        allowSignedApp = true;
        enableStealthMode = true;
      };
    };
    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
