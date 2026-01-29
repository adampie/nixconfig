{inputs, ...}: {
  flake.modules.homeManager.dev-tools = {pkgs, ...}: let
    stablepkgs = import inputs.nixpkgs-stable {
      inherit (pkgs) system;
      config.allowUnfree = true;
    };
  in {
    home.packages =
      (with pkgs; [
        gh
        ghorg
        osv-scanner
      ])
      ++ (with stablepkgs; [
        neofetch
      ]);

    programs.mise = {
      enable = true;
      enableZshIntegration = true;
      globalConfig = {
        settings.experimental = true;
        tools = {
          nodejs = "lts";
          python = "latest";
          go = "latest";
        };
      };
    };
  };

  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        alejandra
        deadnix
        mise
        nil
        nixd
        statix
      ];

      shellHook = ''
        echo "Run 'nix fmt' to format code"
        echo "Run 'nix flake check' to validate"
      '';
    };
  };
}
