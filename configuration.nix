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

# System state
  system.stateVersion = "25.11";

# System
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

# Power management
  powerManagement.enable = true;

# Zram
  zramSwap.enable = true;

# Time zone
  time.timeZone = "Europe/Paris";

# Locale
  i18n.defaultLocale = "en_US.UTF-8";

# Networking
  networking.hostName = "nixos";

# Fish (system-wide)
  programs.fish.enable = true;

# Gnome (system-wide)
  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/input-sources".xkb-options = [ "compose:ralt" ];	
    }
  ];

# Users
  users.users.amin.isNormalUser = true;
  users.users.amin.description = "Amin NAIRI";
  users.users.amin.extraGroups = [ "video" "wheel" "networkmanager" ];
  users.users.amin.shell = pkgs.fish;
  users.users.amin.home = "/home/amin";

# Fonts
  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.monospace = [ "JetBrainsMono Nerd Font" ];

# Home Manager
  home-manager.useGlobalPkgs = true;
  home-manager.users.amin.home.stateVersion = "25.11";

# Neovim
  home-manager.users.amin.programs.neovim.enable = true;
  home-manager.users.amin.programs.neovim.defaultEditor = true;

# Fish
  home-manager.users.amin.programs.fish.enable = true;
  home-manager.users.amin.programs.fish.completions.dkcpu = "docker compose up --detach --build";
  
# Home manager packages
  home-manager.users.amin.home.packages = with pkgs; [
    chromium
  ];
}
