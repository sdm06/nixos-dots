{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };
  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.sdnixos = nixpkgs.lib.nixosSystem {
        inherit system;
        
        # Pass inputs to modules
        specialArgs = { inherit inputs; };
        
        modules = [
         ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.sdmnix = import ./home.nix;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
          # 3. ENABLE MACBOOK PRO 11,4 DRIVERS
          nixos-hardware.nixosModules.apple-macbook-pro-11-4
        ];
      };
    };
}
