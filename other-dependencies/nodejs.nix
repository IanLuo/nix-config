{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Node.js and package managers
    nodejs_20  # LTS version (includes npm)
    yarn
    pnpm
  ];

  # Create a minimal global tools package.json
  home.file.".config/npm-global-tools/package.json".text = ''
    {
      "name": "global-tools",
      "version": "1.0.0",
      "description": "Global Node.js tools managed by npm",
      "private": true,
      "dependencies": {},
      "devDependencies": {
      },
      "engines": {
        "node": ">=18.0.0"
      }
    }
  '';

  # NPM configuration
  home.file.".npmrc".text = ''
    prefix=$HOME/.npm-global
    fund=false
  '';

  # Environment variables for Node.js/npm
  home.sessionVariables = {
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
  };
}
