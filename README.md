<h1 align="center">❄️  NixOS on Proxmox</h1>
<p align="center">
    <em>Deploy a minimum NixOS VM on Proxmox at speed</em>
</p>
<p align="center">
  <img src="https://custom-icon-badges.herokuapp.com/github/license/yqlbu/nixos-config?style=flat&logo=law&colorA=24273A&color=blue" alt="License"/>
  <img src="https://img.shields.io/badge/NixOS-25.05-informational.svg?style=flat&logo=nixos&logoColor=CAD3F5&colorA=24273A&colorB=8AADF4">
  <img src="https://custom-icon-badges.herokuapp.com/github/last-commit/yqlbu/nixos-config?style=flat&logo=history&colorA=24273A&colorB=C4EEF2" alt="lastcommit"/>
</p>

---

> [!NOTE]
> The image can be build locally, or by using the included GitHub action.

Credit to [@Mayniklas](https://github.com/Mayniklas), [@NixOS-Pilots](https://github.com/NixOS-Pilots) and inspired by [Mayniklas/nixos-proxmox](https://github.com/Mayniklas/nixos-proxmox).

## Table of Contents

<!-- vim-markdown-toc GFM -->

* [Prerequisites](#prerequisites)
  * [Update user ssh-keys](#update-user-ssh-keys)
* [Deployment](#deployment)
  * [Build the image](#build-the-image)
  * [Upload the image to Proxmox](#upload-the-image-to-proxmox)
* [Apply config changes](#apply-config-changes)
* [Contribution](#contribution)
* [References](#references)

<!-- vim-markdown-toc -->

## Prerequisites

### Update user ssh-keys

In `./system/users.nix`, update the `keyFiles` attribute with your own ssh key.

```nix
{
  keyFiles = [
    (pkgs.fetchurl {
      # replace <github_user> with your own ssh key!
      # command to generate the hash:
      # nix-prefetch-url --type sha256 'https://github.com/<github_user>.gpg' | xargs nix hash to-sri --type sha256
      url = "https://github.com/<github_user>.keys";
      hash = "sha256-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    })
  ];
}
```

## Deployment

### Build the image

```bash
# build VMA image
nix build .#proxmox-image
```

### Upload the image to Proxmox

Upload the image to a location, that is accessible by Proxmox.

```bash
# scp build artifact to Proxmox
scp ./result/*.vma.zst root@<proxmox-ip>:/root/
```

Create a VM using `qmrestore`

```bash
# import the VM from VMA image
# unique is required to randomize the MAC address of the network interface
# storage is the name of the storage, where we create the VM
qmrestore ./vzdump-qemu-nixos-*.vma.zst 999 --unique true --storage <storage, e.g. local-lvm>
```

## Apply config changes

```bash
nixos-rebuild switch --flake .#proxmox-host
```

## Contribution

## References

- [github.com/MayNiklas/nixos-proxmox](https://github.com/MayNiklas/nixos-proxmox/)
- [github.com/NixOS/nixpkgs/.../proxmox-image.nix](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/proxmox-image.nix#L272-L274)
