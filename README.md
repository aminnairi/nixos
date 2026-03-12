# nixos

## Symbolic link

```bash
ln -sf $PWD/configuration.nix /etc/nixos/configuration.nix
```

## Build

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
