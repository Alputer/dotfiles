{ ... }:

{
  networking.hostName = "alputer";
  time.timeZone = "Europe/Istanbul";

  nixpkgs.hostPlatform = "aarch64-darwin";

  security.pam.services.sudo_local.touchIdAuth = true;

  system.primaryUser = "alputer";
  system.stateVersion = 7;

  users.users.alputer = {
    name = "alputer";
    home = "/Users/alputer";
  };

  # Determinate Nix, installed by bootstrap.sh, owns the daemon and Nix
  # configuration. nix-darwin should only manage the macOS system here.
  nix.enable = false;

  system.defaults = {
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };

    dock = {
      autohide = true;
      mineffect = "scale";
      minimize-to-application = true;
      persistent-apps = [
        { app = "/Applications/Brave Browser.app"; }
        { app = "/Applications/Slack.app"; }
        { app = "/Applications/Notion.app"; }
        { app = "/Applications/WezTerm.app"; }
      ];
      show-recents = false;
      tilesize = 48;
    };

    finder = {
      AppleShowAllFiles = true;
      FXDefaultSearchScope = "SCcf";
      FXPreferredViewStyle = "clmv";
      _FXShowPosixPathInTitle = true;
    };

    loginwindow.GuestEnabled = false;
    screencapture.location = "~/Pictures/Screenshots";
    trackpad.Clicking = true;
  };
}
