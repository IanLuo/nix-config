{ 
pkgs
, lib
, user
, inputs
, systemPackages
, stateVersion
, ... 
} : {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${user} = { pkgs, ... }:
  {
    home = {
      username = user;
      stateVersion = stateVersion;
    };

    programs.home-manager.enable = true;
    
    imports = (import ../../programs).packages 
      ++ [ 
        inputs.nix-doom-emacs.hmModule 
        ../../programs/others.nix
      ];

  };
}
