{...}: {
  flake.modules.homeManager.ssh = {...}: {
    home.file.".ssh/config".text = ''
      Include ~/.orbstack/ssh/config

      Host *
          IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    '';
  };
}
