_: {
  home = {
    username = "adampie";
    homeDirectory = "/Users/adampie";

    file = {
      ".local/bin/fac" = {
        text = ''
          #!/usr/bin/env zsh
          fetch_all_code "github" "user" "adampie"
          fetch_all_code "github" "org" "fricory"
        '';
        executable = true;
      };
    };
  };
}
