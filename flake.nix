{
  description = "A flake to bootstrap a KVM template for Proxmox";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = { self, nixpkgs, ... }@inputs: with inputs;
    let
      system = "x86_64-linux";
      inherit (import ./vars.nix) user;
      pkgs = (import nixpkgs) { inherit system; };
      inherit (nixpkgs) lib;
      specialArgs = { inherit inputs pkgs system user; };
      # function to generate pre-commit-checks
      genChecks = system: (pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          nixpkgs-fmt.enable = true; # formatter
          statix.enable = true; # linter
          deadnix.enable = true; # linter
        };
      });
    in
    {
      # checks
      checks.${system}.pre-commit-check = genChecks system;

      # See for further options:
      # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/proxmox-image.nix
      nixosConfigurations.proxmox-host = lib.nixosSystem {
        inherit specialArgs;
        modules = [
          "${nixpkgs}/nixos/modules/virtualisation/proxmox-image.nix"
          ./host/configuration.nix
          {
            proxmox = {
              # Reference: https://pve.proxmox.com/wiki/Qemu/KVM_Virtual_Machines#qm_virtual_machines_settings
              qemuConf = {
                # EFI support
                bios = "ovmf";
                cores = 4;
                memory = 1024;
                net0 = "virtio=00:00:00:00:00:00,bridge=vmbr0,firewall=1";
                diskSize = "20480"; # 20g
              };
              qemuExtraConf = {
                # start the VM automatically on boot
                # onboot = "1";
                cpu = "host";
                tags = "nixos";
              };
            };
            nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
            nix.registry.nixpkgs.flake = nixpkgs;
          }
        ];
      };

      packages.${system} = {
        # nix build .#proxmox-image
        proxmox-image = self.nixosConfigurations.proxmox-host.config.system.build.VMA;

        # nix build .#proxmox-image-uncompressed
        proxmox-image-uncompressed = pkgs.stdenv.mkDerivation {
          name = "proxmox-image-uncompressed";
          dontUnpack = true;
          installPhase = ''
            # create output directory
            mkdir -p $out/

            # basename of the vma file (without .zst)
            export filename=$(basename ${self.packages.${system}.proxmox-image}/vzdump-qemu-nixos-*.vma.zst .zst)

            # decompress the vma file and write it to the output directory
            ${pkgs.zstd}/bin/zstd -d ${self.packages.${system}.proxmox-image}/vzdump-qemu-nixos-*.vma.zst -o $out/$filename
          '';
        };
      };
    };
}
