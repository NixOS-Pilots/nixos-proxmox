_:

{
  # enable openssh
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # enable qemu-guest-agent
  services.qemuGuest.enable = true;
}
