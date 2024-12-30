{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flatpaks.url = "github:gmodena/nix-flatpak/?ref=latest";


    disko = {
    url = "github:nix-community/disko/latest";
    inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "git+https://github.com/mxckdev/dotfiles-nixos";
      flake = false;
    };



  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    flatpaks,
    disko,
    dotfiles,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {

      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;
        hostname = "laptop";
        };
        modules = [./nixos/laptop/configuration.nix];
      };

      laptop-hypr = nixpkgs.lib.nixosSystem {
        specialArgs = {
        inherit inputs outputs;
        hostname = "laptop-hypr";
        };
        modules = [./nixos/laptop-hypr/configuration.nix];
      };
    };

    homeConfigurations = {
      "mick@laptop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/laptop.nix
          flatpaks.homeManagerModules.nix-flatpak
        ];
      };

        "mick@laptop-hypr" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {inherit inputs outputs;};
          modules = [
            ./home-manager/laptop-hypr.nix
            flatpaks.homeManagerModules.nix-flatpak
          ];
        };
      };
    };
}
