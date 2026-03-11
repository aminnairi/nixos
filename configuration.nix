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

	networking.hostName = "nixos"; # Define your hostname.

	networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

	time.timeZone = "Europe/Paris";

	i18n.defaultLocale = "en_US.UTF-8";

	services.printing.enable = true;

	networking = {
		firewall = {
			enable = true;
			allowedTCPPorts = [];
			allowedUDPPorts = [];
		};
	};

	system.stateVersion = "25.05";

	nixpkgs.config.allowUnfree = true;
	nixpkgs.config.allowUnfreePredicate = _: true;

	services = {
		xserver = {
			enable = true;
			displayManager.gdm.enable = true;
			desktopManager.gnome.enable = true;
			xkb = {
				layout = "us"; # Ou votre disposition habituelle
				options = "compose:ralt"; # Définit Alt Gr comme touche de composition
			};
		};
	};

	users.users.amin = {
		isNormalUser = true;
		description = "Amin NAIRI";
		extraGroups = [ "wheel" ];
		shell = pkgs.bash;
		home = "/home/amin";
	}; 

	environment.systemPackages = with pkgs; [
		git
		vim
		google-chrome
		home-manager
	];

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

