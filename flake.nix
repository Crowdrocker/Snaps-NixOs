# WehttamSnaps NixOS Flake Configuration
# Main entry point for the NixOS system

{
  description = "WehttamSnaps NixOS Configuration - Gaming, Streaming & Photography Workstation";

  inputs = {
    # NixOS Unstable - Better for gaming and latest packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Home Manager - User environment management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Chaotic-Nyx - CachyOS kernel and bleeding edge packages
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    
    # Niri compositor
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Stylix - System-wide theming
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, chaotic, niri, stylix, ... }@inputs: {
    
    nixosConfigurations = {
      # Main PC Configuration
      snaps-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        specialArgs = { 
          inherit inputs; 
          username = "wehttamsnaps";
          hostname = "snaps-pc";
        };
        
        modules = [
          # Core system configuration
          ./hosts/snaps-pc/configuration.nix
          ./hosts/snaps-pc/hardware-configuration.nix
          
          # Chaotic-Nyx for CachyOS kernel and optimizations
          chaotic.nixosModules.default
          
          # Niri compositor
          niri.nixosModules.niri
          
          # Stylix for theming
          stylix.nixosModules.stylix
          
          # Home Manager integration
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              
              extraSpecialArgs = { 
                inherit inputs; 
                username = "wehttamsnaps";
              };
              
              users.wehttamsnaps = import ./hosts/snaps-pc/home.nix;
              
              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            };
          }
          
          # Custom modules
          ./modules/gaming
          ./modules/audio
          ./modules/desktop
          ./modules/streaming
          ./modules/work
        ];
      };
    };
    
    # Development shell for working on the configuration
    devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
      buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
        git
        nixpkgs-fmt
        nil # Nix LSP
      ];
      
      shellHook = ''
        echo "WehttamSnaps NixOS Development Environment"
        echo "Run 'sudo nixos-rebuild switch --flake .#snaps-pc' to apply changes"
      '';
    };
  };
}