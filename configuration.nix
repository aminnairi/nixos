{ config, lib, pkgs, ... }:
let
  nixpkgs-src = builtins.fetchTarball https://github.com/nixos/nixpkgs/archive/nixos-25.11.tar.gz;
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
in
{ 
  imports = [
    /etc/nixos/hardware-configuration.nix
    (import "${home-manager}/nixos")
  ];

  nixpkgs.pkgs = import nixpkgs-src {
    config.allowUnfree = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  powerManagement.enable = true;

  zramSwap.enable = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.defaultCharset = "UTF-8";

  networking.hostName = "nixos";

  system.stateVersion = "25.05";

  users.users.amin.isNormalUser = true;
  users.users.amin.description = "Amin NAIRI";
  users.users.amin.extragroups = [ "video" "wheel" "networkmanager" ];
  users.users.amin.shell = pkgs.fish;
  users.users.amin.home = "/home/amin";

  fonts.packages = with pkgs; [ nerd-fonts-jetbrains-mono ];
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.monospace = [ "JetBrainsMono Nerd Font" ];

  programs.home-manager.enable = true;

  home-manager.userUserPackages = true;
  home-manager.useGlobalPkgs = true;

  home.username = "amin";
  home.homeDirectory = "/home/amin";
  home.stateVersion = "25.11";
  home.programs.chromium.enable = true;

  wayland.windowManager.hyprland.enable = true;
}
