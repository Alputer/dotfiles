{ ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = false;
  home-manager.backupFileExtension = "hm-backup";

  home-manager.users.alputer = {
    home.username = "alputer";
    home.homeDirectory = "/Users/alputer";
    home.stateVersion = "26.05";
  };
}
