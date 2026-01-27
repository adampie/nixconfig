{
  description = "Nix config by adampie - Dendritic structure";

  inputs = {
    # Dendritic infrastructure
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    
    # System packages
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    
    # System management
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # User environment
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} ({...}: {
      # Define systems first at top level
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      
      # Then import all modules
      imports = (inputs.import-tree ./modules).imports;
    });
}
