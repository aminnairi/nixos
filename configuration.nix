{ config, lib, pkgs, ... }:

let

  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;

in

  { imports =
    [ /etc/nixos/hardware-configuration.nix
    (import "${home-manager}/nixos")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  powerManagement.enable = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint 
      ];
    };
  };

  hardware = {
    sane = {
      enable = true;
      extraBackends = with pkgs; [
        sane-airscan
      ];
    };
  };

  networking = {
    hostName = "nixos";
    firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
    networkmanager = {
      enable = true;
      wifi = {
        powersave = true;
      };
    };
  };

  system.stateVersion = "25.05";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us"; # Ou votre disposition habituelle
        options = "compose:ralt"; # Définit Alt Gr comme touche de composition
      };
      displayManager = {
        gdm = {
          enable = true;
        };
      };
      desktopManager = {
        gnome = {
          enable = true;
        };
      };
    };
  };

  programs = {
    fish = {
      enable = true;
    };

    git = {
      enable = true;
      config = {
        init = {
          defaultBranch = "development";
        };
        user = {
          name = "aminnairi";
          email = "18418459+aminnairi@users.noreply.github.com";
        };
      };
    };

    vim = {
      enable = true;
      defaultEditor = true;
    };
  };

  environment = {
    variables = {
      EDITOR = "vim";
    };
    systemPackages = with pkgs; [
      git
      vim
      fish
      google-chrome
      home-manager
    ];
    gnome = {
      excludePackages = [
        pkgs.geary
        pkgs.gnome-calendar
        pkgs.gnome-contacts
        pkgs.gnome-clocks
        pkgs.snapshot
        pkgs.gnome-tour
        pkgs.gnome-text-editor
        pkgs.gnome-weather
        pkgs.gnome-maps
        pkgs.gnome-music
      ];
    };
  };

  users.users.amin = {
    isNormalUser = true;
    description = "Amin NAIRI";
    extraGroups = [ "video" "wheel" ];
    shell = pkgs.fish;
    home = "/home/amin";
  }; 

  home-manager.users.amin = { pkgs, ... }: {
    home = {
      stateVersion = "25.05";
    };

    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        xkb-options = [ "compose:ralt" ];
      };
    };

  };
}

