<h1 align="center">❄️  NixOS on Proxmox</h1>
<p align="center">
    <em>Deploy a minim NixOS VM on Proxmox at speed</em>
</p>
<p align="center">
  <img src="https://custom-icon-badges.herokuapp.com/github/license/yqlbu/nixos-config?style=flat&logo=law&colorA=24273A&color=blue" alt="License"/>
  <img src="https://img.shields.io/static/v1?label=Nix Flake&message=check&style=flat&logo=nixos&colorA=24273A&colorB=9173ff&logoColor=CAD3F5">
  <img src="https://img.shields.io/badge/NixOS-23.11-informational.svg?style=flat&logo=nixos&logoColor=CAD3F5&colorA=24273A&colorB=8AADF4">
  <img src="https://custom-icon-badges.herokuapp.com/github/last-commit/yqlbu/nixos-config?style=flat&logo=history&colorA=24273A&colorB=C4EEF2" alt="lastcommit"/>
</p>

---

> [!NOTE]
> The image can be build locally, or by using the included GitHub action.

Credit to @Mayniklas,@techprober and inspired by [Mayniklas/nixos-proxmox].

## Table of Contents

<!-- vim-markdown-toc GFM -->

* [Deployment](#deployment)
    * [Build the image](#build-the-image)
    * [Upload the image to Proxmox](#upload-the-image-to-proxmox)
* [Apply config changes](#apply-config-changes)
* [Contribution](#contribution)
* [References](#references)

<!-- vim-markdown-toc -->

## Deployment

### Build the image

```bash
# build VMA image
nix build '.#proxmox-image'
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
