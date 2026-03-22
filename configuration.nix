{ config, lib, pkgs, ... }:

let
  nixpkgs-src = builtins.fetchTarball https://github.com/nixos/nixpkgs/archive/nixos-25.11.tar.gz;
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
  lazyvim = pkgs.fetchFromGitHub {
    owner = "LazyVim";
    repo = "Starter";
    rev = "v2.10.0";
  };
in

{
  imports = [
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
  time.hardwareClockInLocalTime = true;

# Locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings.LANG = "en_US.UTF-8";
  i18n.extraLocaleSettings.LANGUAGE = "en_US.UTF-8";
  i18n.extraLocaleSettings.CL_CTYPE = "fr_FR.UTF_8";
  i18n.extraLocaleSettings.LC_NUMERIC = "fr_FR.UTF_8";
  i18n.extraLocaleSettings.LC_COLLATE = "fr_FR.UTF_8";
  i18n.extraLocaleSettings.LC_TIME = "fr_FR.UTF_8";
  i18n.extraLocaleSettings.LC_MESSAGES = "fr_FR.UTF_8";
  i18n.extraLocaleSettings.LC_MONETARY = "fr_FR.UTF_8";
  i18n.extraLocaleSettings.LC_ADDRESS = "fr_FR.UTF_8";
  i18n.extraLocaleSettings.LC_IDENTIFICATION = "fr_FR.UTF_8";
  i18n.extraLocaleSettings.MEASUREMENT = "fr_FR.UTF_8";
  i18n.extraLocaleSettings.LC_PAPER = "fr_FR.UTF_8";
  i18n.extraLocaleSettings.LC_TELEPHONE = "fr_FR.UTF_8";
  i18n.extraLocaleSettings.LC_NAME = "fr_FR.UTF_8";

# Networking
  networking.hostName = "nixos";

# Gnome
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [{
    settings."org/gnome/desktop/input-sources".xkb-options = [ "compose:ralt" ];	
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  }];

# Services
  services.libinput.enable = true;

# Fish (system-wide)
  programs.fish.enable = true;

# Environment (system-wide)
  environment.gnome.excludePackages = with pkgs; [
    geary
    gnome-calendar
    gnome-contacts
    gnome-clocks
    snapshot
    gnome-tour
    gnome-text-editor
    gnome-weather
    gnome-maps
    gnome-music
  ];

# Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;
  virtualisation.docker.rootless.enable = true;
  virtualisation.docker.autoPrune.enable = true;

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
  home-manager.users.amin.programs.fish.shellAbbrs.dkcpdn = "docker compose down --remove-orphans --volumes --timeout 0";
  home-manager.users.amin.programs.fish.shellAbbrs.nrs = "sudo nixos-rebuild switch";
  home-manager.users.amin.programs.fish.shellAbbrs.ncg = "sudo nix-collect-garbage -d";
  home-manager.users.amin.programs.fish.shellAbbrs.ndg = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +5";

# Lazyvim
  home-manager.users.amin.xdg.configFile."nvim".source = pkgs.fetchFromGitHub {
    owner = "LazyVim";
    repo = "Starter";
    rev = "803bc181d7c0d6d5eeba9274d9be49b287294d99";
    sha256 = "sha256-QrpnlDD4r1X4C8PqBhQ+S3ar5C+qDrU1Jm/lPqyMIFM=";
  };

  home-manager.users.amin.xdg.configFile.test.source = "Hello, world!"

  # home-manager.users.amin.home.file."nvim/lua/config/plugins/avante.lua".text = ''
  #   return {
  #     import = "lazyvim.plugins.extras.ai.avante"
  #   }
  # '';
  #
# Kitty
  home-manager.users.amin.programs.kitty.enable = true;
  home-manager.users.amin.programs.kitty.enableGitIntegration = true;
  home-manager.users.amin.programs.kitty.shellIntegration.enableFishIntegration = true;
  home-manager.users.amin.programs.kitty.font.name = "JetBrainsMono Nerd Font Mono";
  home-manager.users.amin.programs.kitty.font.size = 12;
  home-manager.users.amin.programs.kitty.settings.background_opacity = "0.9";
  home-manager.users.amin.programs.kitty.settings.linux_display_server = "x11";
  home-manager.users.amin.programs.kitty.settings.hide_window_decorations = "no";
  home-manager.users.amin.programs.kitty.settings.window_padding_width = "4";
  home-manager.users.amin.programs.kitty.settings.confirm_os_window_close = 0;
  
# Home manager packages
  home-manager.users.amin.home.packages = with pkgs; [
    chromium
  ];
}
