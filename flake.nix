{
	description = "My computer setup";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
		home-manager.url = "github:nix-community/home-manager";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
		darwin.url = "github:lnl7/nix-darwin";
		darwin.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { self, nixpkgs, home-manager, darwin }: {
		darwinConfigurations = {
			"CDU-L737HCJ9FJ" = darwin.lib.darwinSystem {
				system = "aarch64-darwin";
				modules = [
					home-manager.darwinModules.home-manager
						./macos/default.nix 
				];
			};

			"ianluo" = darwin.lib.darwinSystem {
				system = "aarch64-darwin";
				modules = [
					home-manager.darwinModules.home-manager
						./macos/default.nix 
				];
			};
		};
	};
}

