{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # UV - Fast Python package installer and resolver
    uv
    
    # Python version
    python312
  ];
  
  # Create a minimal global tools project
  home.file.".config/uv-global-tools/pyproject.toml".text = ''
    [project]
    name = "global-tools"
    version = "0.1.0"
    description = "Global Python tools managed by UV"
    requires-python = ">=3.11"
    
    # Add your global tools here:
    dependencies = [
        # Example: "black>=23.0.0",
        "speckit"
    ]
    
    [build-system]
    requires = ["setuptools>=61.0"]
    build-backend = "setuptools.build_meta"
  '';

  # UV global configuration
  home.file.".config/uv/uv.toml".text = ''
    [global]
    python-preference = "system"
  '';

  # Environment variables for Python/UV
  home.sessionVariables = {
    UV_PYTHON_PREFERENCE = "system";
  };
}