_: {
  home = {
    username = "adampie";
    homeDirectory = "/Users/adampie";

    file.".local/bin/fac" = {
      text = ''
        #!/usr/bin/env zsh
        fetch_all_code "gitlab" "org" "zapier"
      '';
      executable = true;
    };
  };
}
