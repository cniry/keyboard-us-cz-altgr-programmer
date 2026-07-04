{ stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "us-cz-altgr-programmer-xkb";
  version = "1.0.3";

  src = ../.;

  installPhase = ''
    runHook preInstall

    install -Dm0644 xkb/symbols/us-cz-altgr-programmer \
      "$out/share/X11/xkb/symbols/us-cz-altgr-programmer"

    runHook postInstall
  '';

  passthru.layoutId = "us-cz-altgr-programmer";

  meta = {
    description = "US-CZ AltGr Programmer Keyboard Layout";
    homepage = "https://github.com/cniry/keyboard-us-cz-altgr-programmer";
  };
}
