{ pkgs, ... }:

{
  # Packages
  environment.systemPackages = with pkgs; [
    nixpkgs-fmt
    bash-completion
    git
    vim
    wget
  ];
}
