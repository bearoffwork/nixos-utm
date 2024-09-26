{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    clipboard.register = "unnamedplus";

    plugins.treesitter = {
      enable = true;
      # settings.ensure_installed = "all";
    };
  };
}
