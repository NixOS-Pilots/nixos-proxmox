{ lib, pkgs, system, user, ... }: {

  # SSH
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # Users
  users = {
    defaultUserShell = pkgs.bash;
    users = {
      root = {
        openssh.authorizedKeys.keyFiles = [
          (pkgs.fetchurl {
            # replace with your own ssh key!
            url = "https://github.com/yqlbu.keys";
            hash = "sha256-msQCFEqniCZtu+m1MMmqFuEJBdKJ3y828+w7ORf/uP4=";
          })
        ];
      };
    };
  };

  # Locales
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  # Packages
  environment.systemPackages = with pkgs; [
    nixpkgs-fmt
    bash-completion
    git
    wget
  ];

  # Networking
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

  # enable qemu-guest-agent
  services.qemuGuest.enable = true;

  # Nix settings
  # Ref: https://nixos.wiki/wiki/Nixos-rebuild
  nix = {
    # enable flake
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      # enable auto-cleanup
      auto-optimise-store = true;
      # set max-jobs
      max-jobs = lib.mkDefault 8;
      # enable ccache (local compilation)
      # extra-sandbox-paths = [ config.programs.ccache.cacheDir ];
      trusted-users = [ "root" user ];
      # trusted-public-keys = [ ];

      # substituers will be appended to the default substituters when fetching packages
      extra-substituters = [ ];
      extra-trusted-public-keys = [ ];
      # ref: https://github.com/NixOS/nix/issues/4894
      # workaround to fix ssh signature issues
      require-sigs = false;
    };

    # garbage collection
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete older-than 3d";
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault system;

  system.stateVersion = "23.11";
}
