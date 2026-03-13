{ config, lib, pkgs, ... }:
let

  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
  nixpkgs-src = builtins.fetchTarball https://github.com/nixos/nixpkgs/archive/nixos-25.11.tar.gz;

in

{ 
  imports = [
    /etc/nixos/hardware-configuration.nix
    (import "${home-manager}/nixos")
  ];

  nixpkgs.pkgs = import nixpkgs-src {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  powerManagement.enable = true;

  zramSwap = {
    # Compresses the ram used in memory
    enable = true;
  };

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
    nameservers = [ "157.90.170.95" ];
    search = [ "nairi.cloud" ];
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi = {
        powersave = true;
      };
    };
  };

  system.stateVersion = "25.05";

  services = {
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
    xserver = {
      enable = true;
      xkb = {
        layout = "us"; # Ou votre disposition habituelle
        options = "compose:ralt"; # Définit Alt Gr comme touche de composition
      };
    };
    resolved = {
      enable = true;
      dnssec = "true";
      domains = [ "~." ]; # Utilise ce DNS pour toutes les requêtes
      fallbackDns = [ "1.1.1.1" ]; # DNS de secours si le vôtre est hors ligne
      extraConfig = ''
        DNS=157.90.170.95#dns.nairi.cloud
        DNSOverTLS=yes
      '';
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

    dconf = {
      enable = true;
      profiles = {
        user = {
          databases = [
            {
              settings = {
                "org/gnome/desktop/input-sources" = {
                  xkb-options = [ "compose:ralt" ];	
                };
              };
            }
          ];
        };
      };
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
      nil
      nixfmt-rfc-style
      kitty
    ];
    gnome = {
      excludePackages = with pkgs; [
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
    };
  };

  users.users.amin = {
    isNormalUser = true;
    description = "Amin NAIRI";
    extraGroups = [ 
      "video" 
      "wheel"
      "networkmanager" 
    ];
    shell = pkgs.fish;
    home = "/home/amin";
  }; 

  fonts = {
    packages = [
      pkgs.nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      amin = {
        home = {
          stateVersion = "25.11";
          packages = with pkgs; [
            ripgrep
            fd
          ];
        };
        programs = {
          fish = {
            enable = true;
            shellAbbrs = {
              dkcpdn = "docker compose down --remove-orphans --volumes --timeout 0";
              nrs = "sudo nixos-rebuild switch";
              ncg = "sudo nix-collect-garbage -d";
              ndg = "sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +5";
            };
          };
          vim = {
            enable = true;
            plugins = with pkgs.vimPlugins; [
              vim-nix
              vim-airline
              vim-airline-themes
              nerdtree
            ];
            extraConfig = ''
                syntax on
                colorscheme catppuccin

                " Enable airline support for powerline fonts
                let g:airline_powerline_fonts = 1

                " Ensure encoding is always set to UTF-8
                set encoding=utf-8

                nmap <silent> gd <Plug>(coc-definition)
                nmap <silent> gy <Plug>(coc-type-definition)
                nmap <silent> gi <Plug>(coc-implementation)
                nmap <silent> gr <Plug>(coc-references)

                set expandtab        " Utilise des espaces au lieu des tabulations
                set shiftwidth=2     " Indentation automatique de 2 espaces
                set softtabstop=2    " 2 espaces pour la touche Tab
                set tabstop=2        " Une tabulation = 2 espaces
                set smartindent      " Indentation intelligente selon le langage

                set number           " Numéros de ligne
                set relativenumber   " Numéros relatifs (crucial pour sauter des lignes)
                set cursorline       " Surligne la ligne actuelle
                set scrolloff=8      " Garde toujours 8 lignes au-dessus/en dessous du curseur
                set signcolumn=yes   " Garde la marge des erreurs/git fixe
                set nowrap           " Ne pas couper les lignes automatiquement

                set ignorecase       " Recherche insensible à la casse
                set smartcase        " Sauf si on utilise une majuscule
                set incsearch        " Recherche en temps réel
                set hlsearch         " Surligne les résultats
                set mouse=a          " Permet d'utiliser la souris

                set clipboard=unnamedplus

                let mapleader = " "

                nnoremap <leader>h :nohlsearch<CR>

                nnoremap <C-h> <C-w>h
                nnoremap <C-j> <C-w>j
                nnoremap <C-k> <C-w>k
                nnoremap <C-l> <C-w>l
                nnoremap <leader>n :NERDTreeToggle<cr>

                set noswapfile       " Pas de fichiers .swp gênants
                set undofile         " Historique persistant des modifications
                set undodir=~/.vim/undo
            '';
          };
          kitty = {
            enable = true;
            enableGitIntegration = true;
            shellIntegration = {
              enableFishIntegration = true;
            };
            font = {
              name = "JetBrainsMono Nerd Font Mono";
              size = 12;
            };
            settings = {
              background_opacity = "0.9"; # Little transparency
              linux_display_server = "x11"; # Use x11 for gnome
              hide_window_decorations = "no"; # Keep title bars from Gnome
              window_padding_width = "4"; # Little padding inside
              confirm_os_window_close = 0;
            };
          };
        };
      };
    };
  };

}
