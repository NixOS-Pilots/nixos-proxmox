{ lib, ... }:

{
  # enable openssh
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = lib.mkForce "prohibit-password"; # enable root login for remote deploy
    };
  };

  # enable qemu-guest-agent
  services.qemuGuest.enable = true;
}
