{...}: {
  home.username = "adampie";
  home.homeDirectory = "/Users/adampie";

  home.file.".local/bin/fac" = {
    text = ''
      #!/usr/bin/env zsh
      fetch_all_code "gitlab" "org" "zapier"
    '';
    executable = true;
  };
}
