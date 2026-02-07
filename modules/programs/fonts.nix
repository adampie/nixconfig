{...}: {
  flake.modules.homeManager.fonts = {pkgs, ...}: {
    home.packages = with pkgs; [
      nerd-fonts.hack
    ];
  };
}
