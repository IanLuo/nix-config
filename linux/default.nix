{ 
pkgs
, lib
, user
, inputs
, systemPackages
, stateVersion
, ... 
}:

{
  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = stateVersion;
    packages = systemPackages.packages;
  };
  
  imports = (import ../programs).packages 
    ++ [ 
    #inputs.nix-doom-emacs.hmModule 
    ../programs/others.nix
  ];
}
