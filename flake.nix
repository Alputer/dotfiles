{
  description = "Alp's macOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nix-darwin, nix-homebrew, home-manager, ... }:
    {
      darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
        modules = [
          ./nix/darwin.nix
          nix-homebrew.darwinModules.nix-homebrew
          ./nix/homebrew.nix
          home-manager.darwinModules.home-manager
          ./nix/home-manager.nix
        ];
      };
    };
}
