nix --extra-experimental-features "nix-command flakes" build '.#nixosConfigurations.ian.system' 
home-manager switch --flake . 
