{ config, lib, pkgs, ... }:
let
  nixpkgs-src = builtins.fetchTarball https://github.com/nixos/nixpkgs/archive/nixos-25.11.tar.gz;
in
{ 
  imports = [
    /etc/nixos/hardware-configuration.nix
      (import "${home-manager}/nixos")
  ];

  nixpkgs.pkgs = import nixpkgs-src {
    config.allowUnfree = true;
  };

  boot.loader.systemd-boot = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  powerManagement.enable = true;

  zramSwap.enable = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.defaultCharset = "UTF-8";

  networking.hostName = "nixos";

  system.stateVersion = "25.05";

  services.displayManager.defaultSession = "hyperland";

  services.hyperland.enable = true;
  services.hyperland.xwayland.enable = true;
  services.hyperland.settings

    programs.fish.enable = true;

  programs.git.enable = true;
  programs.git.config.init.defaultBranch = "development";
  programs.git.config.user.name = "aminnairi";
  programs.git.config.user.email = "18418459+aminnairi@users.noreply.github.com";

  programs.nixvim.enable = true;

  environment.variables.EDITOR = "nvim";

  environment.systemPackages = with pkgs; [
    chromium
  ];

  users.users.amin.isNormalUser = true;
  users.users.amin.description = "Amin NAIRI";
  users.users.amin.extragroups = [ "video" "wheel" "networkmanager" ];
  users.users.amin.shell = pkgs.fish;
  users.users.amin.home = "/home/amin";

  fonts.packages = with pkgs; [ nerd-fonts-jetbrains-mono ];
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.monospace = [ "JetBrainsMono Nerd Font" ];
}
