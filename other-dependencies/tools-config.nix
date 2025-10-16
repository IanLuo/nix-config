# Global Tools Configuration
#
# Python packages are managed by uv, and nodejs packages are managed by npm.
# The source is automatically determined by the category.

{
  python = {
    "specify-cli" = { 
      source = "git";
      url = "https://github.com/github/spec-kit.git";
      rev = "v0.0.62";
    };
  };

  nodejs = {
    "gemini-cli" = {
      package = "@google/gemini-cli";
      version = "0.9.0";
    };
  };
}
