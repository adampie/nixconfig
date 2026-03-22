{ ... }:
{
  flake.homeModules.ssh =
    { pkgs, ... }:
    let
      isDarwin = pkgs.stdenv.isDarwin;
      identityAgent =
        if isDarwin then
          "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\""
        else
          "~/.1password/agent.sock";
    in
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        includes = if isDarwin then [ "~/.orbstack/ssh/config" ] else [ ];
        matchBlocks."*".extraOptions.IdentityAgent = identityAgent;
      };
    };
}
