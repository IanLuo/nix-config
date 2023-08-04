nix --extra-experimental-features "nix-command flakes" build '.#darwinConfigurations.ianluo.system' 
darwin-rebuild switch --flake .
