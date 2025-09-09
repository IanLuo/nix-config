# Global Tools Configuration
# Add tools here with their source types and versions

{
  # Python tools
  python = {
    black = {
      source = "nixpkgs";
      constraint = ">=24.0.0,<26.0.0";
    };
    uv = {
      source = "nixpkgs";
    };
  };

  # Node.js tools  
  nodejs = {
    gemini-cli = {
      source = "npm";
      package = "@google/gemini-cli";
      version = "0.3.4";
    };
  };
}
