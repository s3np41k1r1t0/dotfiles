{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
  };

  outputs = inputs:
    let 
      system = "x86_64-linux";
    
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
    nixosConfigurations = {
      lynx = inputs.nixpkgs.lib.nixosSystem {
        inherit system pkgs;

        modules = [
          ./configuration.nix
        ];
        
        specialArgs = { inherit inputs; };
      };
    };
  };
}