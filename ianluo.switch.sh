nix --extra-experimental-features "nix-command flakes" build '.#darwinConfigurations.ianluo.system'

# Check if darwin-rebuild is available
if command -v darwin-rebuild &> /dev/null; then
  echo "Using darwin-rebuild..."
  darwin-rebuild switch --flake . --show-trace
else
  echo "darwin-rebuild not found. Using nix run nix-darwin for initial setup..."
  nix run nix-darwin -- switch --flake .#ianluo --show-trace
fi
