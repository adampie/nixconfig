# Per-system configuration (formatter, devShells, checks)
{inputs, ...}: {
  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];

  perSystem = {pkgs, ...}: {
    # Formatter
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

    # Dev shell
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

    # Checks
    checks = {
      statix = pkgs.runCommand "statix-check" {} ''
        ${pkgs.statix}/bin/statix check ${inputs.self} --ignore=flake.lock
        touch $out
      '';

      deadnix = pkgs.runCommand "deadnix-check" {} ''
        ${pkgs.deadnix}/bin/deadnix --fail ${inputs.self}
        touch $out
      '';

      format = pkgs.runCommand "format-check" {} ''
        ${pkgs.alejandra}/bin/alejandra --check ${inputs.self}
        touch $out
      '';
    };
  };
}
