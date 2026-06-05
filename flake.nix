{
  description = "US-CZ AltGr Programmer Keyboard Layout";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        rec {
          us-cz-altgr-programmer-xkb = pkgs.callPackage ./package {};
          default = us-cz-altgr-programmer-xkb;
        }
      );

      formatter = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.nixfmt-rfc-style
      );

      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = import ./shell.nix { inherit pkgs; };
        }
      );

      checks = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          package = self.packages.${system}.default;

          self-tests = pkgs.runCommand "us-cz-altgr-programmer-self-tests" {
            nativeBuildInputs = with pkgs; [
              bash
              gnugrep
              coreutils
              xorg.xkbcomp
              xkeyboard_config
            ];
          } ''
            cp -r ${self} source
            chmod -R u+w source
            cd source
            ./tests/run-self-tests.sh
            touch $out
          '';
        }
      );

      nixosModules.default = ./nixos/us-cz-altgr-programmer.nix;
      nixosModules.us-cz-altgr-programmer = ./nixos/us-cz-altgr-programmer.nix;
    };
}
