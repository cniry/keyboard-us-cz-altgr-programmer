{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    bash
    git
    gnugrep
    coreutils
    xkbcomp
    setxkbmap
    xkeyboard_config
    nixfmt
    shellcheck
  ];

  shellHook = ''
    echo "US-CZ AltGr Programmer Keyboard Layout dev shell"
    echo "Run self-tests: ./tests/run-self-tests.sh"
    echo "Run flake checks: nix flake check"
  '';
}
