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
      displayManager = {
        gdm = {
          enable = true;
        };
        desktopManager = {
          gnome = {
            enable = true;
          };
        };
      };
			xkb = {
				layout = "us"; # Ou votre disposition habituelle
				options = "compose:ralt"; # Définit Alt Gr comme touche de composition
			};
		};
	};

	users.users.amin = {
		isNormalUser = true;
		description = "Amin NAIRI";
    extraGroups = [ "video" "wheel" ];
		shell = pkgs.fish;
		home = "/home/amin";
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
      excludePackages = with pkgs; [
        geary
        gnome-calendar
        gnome-contacts
        gnome-clocks
        snapshot
        gnome-tour
        gnome-help
        gnome-text-editor
        gnome-weather
        gnome-maps
        gnome-music
      ];
    };
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

		programs = {
			git = {
				enable = true;
				userName = "aminnairi";
				userEmail = "18418459+aminnairi@users.noreply.github.com";
			};

			vim = {
				enable = true;
				defaultEditor = true;
				settings = {
					number = true;
					relativenumber = true;
					tabstop = 2;
					shiftwidth = 2;
					expandtab = true;
				};
				extraConfig = ''
					syntax on
					set nowrap
				'';
				plugins = with pkgs.vimPlugins; [
					vim-nix
					vim-commentary
					vim-surround
				];
			};
		};
	};
}

