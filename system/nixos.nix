{ pkgs, lib, user, ... }:

{
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

  system.stateVersion = "24.05";
}
