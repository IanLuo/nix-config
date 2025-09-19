# Global Tools Configuration
#
# Python packages are managed by uv, and nodejs packages are managed by npm.
# The source is automatically determined by the category.

{
  python = {
    black = {
      version = "24.4.2";
    };
  };

  nodejs = {
    "gemini-cli" = {
      package = "@google/gemini-cli";
      version = "0.5.3";
    };
  };
}
