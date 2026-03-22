# nixos

## 1. Clone the repository

```bash
cd ~
nix-shell -p git
git clone https://github.com/aminnairi/nixos ~/git/github.com/aminnairi/nixos
```

## 2. Link the configuration

> [!CAUTION]
> If you have installed the system using a crypted partition (LUKS), you should move the following line from the generated `configuration.nix` into the `hardware-configuration.nix` before creating the symbolic link as it is not done by default
>
> ```nix
> boot.initrd.luks.devices."...".device = "/dev/mapper/by-uuid/...";
> ```

```bash
sudo ln -sf $PWD/configuration.nix /etc/nixos/configuration.nix
```

## Install the system

```bash
sudo nixos-rebuild switch
```

## Remove all generations but the last 5

```bash
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +5
```

## Remove unused packages

```bash
sudo nix-collect-garbage -d
```
