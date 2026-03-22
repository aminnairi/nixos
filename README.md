# nixos

My own NixOS configuration

## Installation

### 1. Clone the repository

```bash
cd ~
nix-shell -p git
git clone https://github.com/aminnairi/nixos ~/git/github.com/aminnairi/nixos
```

### 2. Setup the configuration

```nix
{ config, pkgs, ... }:

{
  ...

  imports = [
    ...

    # Replace the path below if you changed the path to the cloned repository
    /home/amin/git/github.com/aminnairi/nixos/configuration.nix
  ];

  ...
}
```

### 3. Install the system

```bash
sudo nixos-rebuild switch
```

## Maintenance

### 1. Remove all generations but the last 5

```bash
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +5
```

### 2. Remove unused packages

```bash
sudo nix-collect-garbage -d
```
