{ user, ... }:
{
  assertions = [
    {
      assertion = user != "";
      message = "Home Manager user must not be empty.";
    }
    {
      assertion = builtins.match "/home/.*" "/home/${user}" != null;
      message = "Linux home directory must stay under /home.";
    }
  ];

  imports = [
    ../shared/home.nix
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";
  };
}
