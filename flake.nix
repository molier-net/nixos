{
  description = "NixOS configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nipkgs.follows = "nixpkgs";

    # Hardware
    hardware.url = "github:nixos/nixos-hardware";

    # Hyperland
    hyprland.url = "github:hyprwm/Hyprland";
  }

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs: 
  {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'

    nixosConfigurations = {
      "remko-desktop" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./systems/remko-desktop/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "remko@remko-desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home-manager/remko/home.nix
        ]
      };
    };
  };
  
}