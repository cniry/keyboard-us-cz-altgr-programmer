# US-CZ AltGr Programmer Keyboard Layout

US QWERTY rozložení klávesnice pro programátory s českými znaky přes AltGr.

Anglická verze: [README.md](./README.md)

Repozitář:

```text
github.com/cniry/keyboard-us-cz-altgr-programmer
```

Technické názvy:

```text
XKB layout ID:  us-cz-altgr-programmer
Nix package:    us-cz-altgr-programmer-xkb
Flake input:    keyboard-us-cz-altgr-programmer
```

Verze: `0.0.2`

Pravidlo verzování: každá změna projektu zvyšuje patch verzi.
Viz [CHANGELOG.md](./CHANGELOG.md).

## Cíle

- Zachovat standardní US rozložení pro programování.
- Přidat české znaky přes AltGr.
- Zachovat část svalové paměti z české klávesnice na číselné řadě.
- Vyhnout se kombinacím Ctrl+AltGr, aby je aplikace nepovažovaly za zkratky.
- Fungovat na NixOS, Ubuntu, Linux Mintu, X11 a GNOME/Wayland při správné konfiguraci desktopu.
- Umožnit vzdálenou instalaci z GitHubu jako Nix flake balíček a NixOS modul.
- Obsahovat self-testy pro rozložení, metadata balíčku a XKB syntaxi.

## Rozložení

Viz [layout.cs.md](./layout.cs.md).

Důležité příklady:

```text
AltGr + c = č
AltGr + 4 = č
AltGr + 5 = ř
AltGr + ; = ů
AltGr + \\ = ň
AltGr + Shift + e = €
AltGr + Shift + ` = °
```

## Instalační návody

- [Instalace na NixOS](./docs/README-NixOS.cs.md)
- [Instalace na Ubuntu / Linux Mint](./docs/README-Ubuntu-Mint.cs.md)

## Výstupy Nix flaku

Repozitář exportuje:

```text
packages.x86_64-linux.default
packages.x86_64-linux.us-cz-altgr-programmer-xkb
packages.aarch64-linux.default
packages.aarch64-linux.us-cz-altgr-programmer-xkb
nixosModules.default
nixosModules.us-cz-altgr-programmer
devShells.x86_64-linux.default
devShells.aarch64-linux.default
checks.*.package
checks.*.self-tests
```

## Vzdálené použití Nixu z GitHubu

Sestavení balíčku přímo z GitHubu:

```bash
nix build github:cniry/keyboard-us-cz-altgr-programmer
```

Instalace balíčku do profilu, pokud chcete mít soubory dostupné pouze v Nix profilu:

```bash
nix profile install github:cniry/keyboard-us-cz-altgr-programmer
```

Pro skutečnou aktivaci klávesnice na NixOS použijte exportovaný NixOS modul, ne pouze instalaci balíčku.

Zobrazení exportovaných výstupů flaku:

```bash
nix flake show github:cniry/keyboard-us-cz-altgr-programmer
```

Použití jako vstup NixOS flaku:

```nix
inputs.keyboard-us-cz-altgr-programmer = {
  url = "github:cniry/keyboard-us-cz-altgr-programmer";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Potom importujte modul:

```nix
inputs.keyboard-us-cz-altgr-programmer.nixosModules.default
```

Kompletní příklad najdete v [instalaci na NixOS](./docs/README-NixOS.cs.md).

## Vývojový shell

S flaky:

```bash
nix develop
```

Bez flaku:

```bash
nix-shell
```

Vývojový shell obsahuje `xkbcomp`, `setxkbmap`, `shellcheck`, `nixfmt` a běžné shellové nástroje.

## Self-testy

Spuštění všech self-testů ve vývojovém shellu:

```bash
./tests/run-self-tests.sh
```

Spuštění flake kontrol:

```bash
nix flake check
```

Self-testy ověřují:

- existenci požadovaných souborů,
- konzistentní použití přejmenovaného projektu, balíčku a rozložení,
- absenci starých názvů projektu,
- verzi balíčku a README `0.0.2`,
- přítomnost důležitých mapování kláves,
- kompilaci XKB rozložení pomocí `xkbcomp`, pokud je dostupný.

## Rychlý test v X11

Přiložený testovací skript je určený pouze pro X11 session, ne pro nativní Wayland aplikace:

```bash
./scripts/test-local.sh
```

Návrat zpět:

```bash
setxkbmap us
```
