{ config, pkgs, lib, ... }:

let
  usCzAltgrProgrammerXkb = pkgs.callPackage ../package {};
in
{
  services.xserver.xkb.extraLayouts.us-cz-altgr-programmer = {
    description = "US-CZ AltGr Programmer Keyboard Layout";
    languages = [ "eng" "cze" ];
    symbolsFile = "${usCzAltgrProgrammerXkb}/share/X11/xkb/symbols/us-cz-altgr-programmer";
  };
}
