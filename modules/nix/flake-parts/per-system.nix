{
  perSystem = {pkgs, ...}: {
    formatter = pkgs.writeShellApplication {
      name = "fmt";
      runtimeInputs = [pkgs.alejandra];
      text = ''
        if [ "$#" -eq 0 ]; then
          exec alejandra .
        fi
        exec alejandra "$@"
      '';
    };

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

    checks = {
      statix = pkgs.runCommand "statix-check" {} ''
        ${pkgs.statix}/bin/statix check ${./../../../.} --ignore=flake.lock
        touch $out
      '';

      deadnix = pkgs.runCommand "deadnix-check" {} ''
        ${pkgs.deadnix}/bin/deadnix --fail ${./../../../.}
        touch $out
      '';

      format = pkgs.runCommand "format-check" {} ''
        ${pkgs.alejandra}/bin/alejandra --check ${./../../../.}
        touch $out
      '';
    };
  };
}
