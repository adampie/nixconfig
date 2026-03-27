{ ... }:
{
  flake.nixosModules.openssh =
    { ... }:
    {
      services.openssh = {
        enable = true;
        settings = {
          # Authentication
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
          MaxAuthTries = 3;
          AuthenticationMethods = "publickey";
          HostbasedAuthentication = false;
          IgnoreRhosts = true;
          PermitUserEnvironment = false;
          StrictModes = true;

          # Session
          LoginGraceTime = 30;
          MaxStartups = "10:30:60";
          MaxSessions = 2;
          ClientAliveInterval = 300;
          ClientAliveCountMax = 2;
          TCPKeepAlive = false;
          Compression = false;

          # Forwarding
          DisableForwarding = true;
          AllowTcpForwarding = false;
          AllowStreamLocalForwarding = false;
          AllowAgentForwarding = false;
          X11Forwarding = false;
          PermitTunnel = false;
          GatewayPorts = "no";

          # Cryptography
          Ciphers = [
            "chacha20-poly1305@openssh.com"
            "aes256-gcm@openssh.com"
          ];
          KexAlgorithms = [
            "sntrup761x25519-sha512@openssh.com"
            "mlkem768x25519-sha256"
            "curve25519-sha256"
            "curve25519-sha256@libssh.org"
          ];
          Macs = [
            "hmac-sha2-512-etm@openssh.com"
            "hmac-sha2-256-etm@openssh.com"
          ];

          # Logging
          LogLevel = "VERBOSE";

          # Misc
          UseDns = false;
          PrintMotd = false;
        };
        hostKeys = [
          {
            path = "/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];
      };
    };
}
