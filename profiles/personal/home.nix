{
  lib,
  mkJetBrainsDarwinScript,
  ...
}: {
  home.username = "adampie";
  home.homeDirectory = "/Users/adampie";

  home.file = {
    ".local/bin/fac" = {
      text = ''
        #!/usr/bin/env zsh
        fetch_all_code "github" "user" "adampie"
        fetch_all_code "github" "org" "fricory"
      '';
      executable = true;
    };
  };
}
