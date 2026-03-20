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

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  powerManagement = {
    # Enable CPU profiles (powersave, balanced, performance)
    enable = true;
  };

  zramSwap = {
    # Compresses the ram used in memory
    enable = true;
  };

  time = {
    # Timezone for the clock
    timeZone = "Europe/Paris";
  };

  i18n = {
    # Locale used by the system
    defaultLocale = "en_US.UTF-8";
    # Default character set for the system
    defaultCharset = "UTF-8";
  };

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
      defaultSession = "gnome";
      gdm = {
        # Enable GDM login manager
        enable = true;
        # Banner displayed above the text input
        banner = "Welcome back, have a great day";
      };
    };
    desktopManager = {
      gnome = {
        # Enable Gnome desktop environment
        enable = true;
      };
    };
    xserver = {
      enable = true;
      # Reduce screen tearing
      enableTearFree = true;
      # Delay after first keystroke before repeating keys
      autoRepeatDelay = 100;
      # Delay between keystorkes repeats
      autoRepeatInterval = 100;
      xkb = {
        # Keyboard layout
        layout = "us";
        # Keyboard options (compose key)
        options = "compose:ralt";
      };
      excludePackages = [
        # Exclude Xterm from being installed
        pkgs.xterm
      ];
    };
    resolved = {
      # Enable DNS over TLS
      enable = true;
      # Enable DNSSec
      dnssec = "true";
      # Domains that will use this DNS (everything)
      domains = [ "~." ];
      # Fallback DNS
      fallbackDns = [ "1.1.1.1" ];
      # Extra configuration (DoT sever)
      extraConfig = ''
        DNS=157.90.170.95#dns.nairi.cloud
        DNSOverTLS=yes
      '';
    };
  };

  programs = {
    fish = {
      # Enable fish shell
      enable = true;
    };

    git = {
      # Enable git
      enable = true;
      config = {
        init = {
          # Default branch for when creating a new git repository
          defaultBranch = "development";
        };
        user = {
          # Global user name
          name = "aminnairi";
          # Global email
          email = "18418459+aminnairi@users.noreply.github.com";
        };
      };
    };

    nixvim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        (nvim-treesitter.withPlugins (p: with p; [
          typescript
          html
          css
          javascript
          json
          tsx
          jsx
        ]))
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        vim-vsnip
        cmp-vsnip
        nvim-autopairs
        nvim-ts-autotag
        typescript-nvim
      ];
      treesitter = {
        enable = true;
        settings = {
          highlight = { enable = true; };
          indent = { enable = true; };
        };
      };
      lsp = {
        enable = true;
        servers = [ "tsserver" "html" "cssls" "jsonls" ];
      };
      cmp = {
        enable = true;
        mapping = {
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), { 'i': cmp.mapping.select_next_item(), 's': cmp.mapping.select_next_item() })";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), { 'i': cmp.mapping.select_prev_item(), 's': cmp.mapping.select_prev_item() })";
          "<CR>" = "cmp.mapping(cmp.mapping.confirm({ select = true }), { 'i': cmp.mapping.confirm({ select = true }), 's': cmp.mapping.confirm({ select = true }) })";
          "<C-e>" = "cmp.mapping(cmp.mapping.close(), { 'i': cmp.mapping.close(), 's': cmp.mapping.close() })";
        };
      };
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
      EDITOR = "nvim";
    };
    systemPackages = with pkgs; [
      git
      vim
      fish
      chromium
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
