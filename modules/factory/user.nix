{...}: {
  flake.factory.user = username: {
    darwin = {config, ...}: {
      system.primaryUser = username;

      users.users.${username} = {
        name = username;
        home = "/Users/${username}";
      };

      home-manager.users.${username} = {
        imports =
          config.home-manager.users.${username}._module.args.imports or [];
      };
    };

    nixos = {...}: {
      users.users.${username} = {
        isNormalUser = true;
        home = "/home/${username}";
        extraGroups = ["wheel"];
      };
    };

    homeManager = {
      home = {
        username = username;
      };
    };
  };
}
