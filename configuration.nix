{ lib, system, ... }:

{
  imports = [
    ./system/nixos.nix
    ./system/users.nix
    ./system/services.nix
    ./system/packages.nix
    ./system/internalisation.nix
  ];

  # set hostname
  networking.hostName = "nixos-proxmox-host";

  # Settings specific to this VM setup
  # <WARN> enable after installation!

  # # reduce size of the VM
  # services.fstrim = {
  #   enable = true;
  #   interval = "weekly";
  # };

  # fileSystems."/" = {
  #   device = "/dev/disk/by-label/nixos";
  #   autoResize = true;
  #   fsType = "ext4";
  # };

  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-label/ESP";
  #   fsType = "vfat";
  # };

  # boot.loader.grub = {
  #   version = 2;
  #   device = "nodev";
  #   efiSupport = true;
  #   efiInstallAsRemovable = true;
  # };

  # boot.initrd.availableKernelModules = [ "9p" "9pnet_virtio" "ata_piix" "uhci_hcd" "virtio_blk" "virtio_mmio" "virtio_net" "virtio_pci" "virtio_scsi" ];
  # boot.initrd.kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];
  # boot.kernelModules = [ "kvm-intel" ];

  # boot.growPartition = true;

  nixpkgs.hostPlatform = lib.mkDefault system;
}
