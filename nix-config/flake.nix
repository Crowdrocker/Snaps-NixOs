{
  description = "WehttamSnaps NixOS Gaming & Workstation Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Gaming and performance inputs
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nix-colors.url = "github:misterio77/nix-colors";
    
    # Window manager and tools
    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, chaotic, nix-colors, niri, ... }@inputs:
    let
      system = "x86_64-linux";
      
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          chaotic.overlays.default
          nix-colors.overlays.default
          niri.overlays.default
          (import ./overlays)
        ];
      };
      
      lib = nixpkgs.lib;
      
      username = "wehttamsnaps";
      hostname = "snaps-pc";
      
    in {
      # NixOS configurations
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs username hostname; };
        
        modules = [
          ./nixos/configuration.nix
          ./nixos/hardware-configuration.nix
          
          ./modules/nixos
          
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = { inherit inputs username hostname; };
          }
        ];
      };
      
      # Home-manager configurations
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs username hostname; };
        modules = [
          ./home-manager/home.nix
          ./modules/home-manager
        ];
      };
      
      # Packages
      packages.${system} = {
        default = self.nixosConfigurations.${hostname}.config.system.build.toplevel;
      } // (import ./pkgs { inherit pkgs; });
      
      # Dev shells
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          git
          nixpkgs-fmt
          home-manager
        ];
      };
      
      # Templates
      templates.default = {
        path = ./templates;
        description = "WehttamSnaps NixOS configuration template";
      };
    };
}