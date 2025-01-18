{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = import nixpkgs { system = "${system}"; config.allowUnfree = true; };
      in {
        devShells.default = with pkgs; mkShell {
          packages = [ 
            marp-cli 
            google-chrome
            noto-fonts
            noto-fonts-extra
            noto-fonts-cjk-sans
            noto-fonts-emoji
          ];
        };
      }
    );
}
