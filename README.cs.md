# US-CZ AltGr Programmer Keyboard Layout

US QWERTY rozložení klávesnice pro programátory s českými znaky přes AltGr.

Anglická verze: [README.md](./README.md)

Technické názvy:

```text
XKB layout ID:  us-cz-altgr-programmer
```

## Cíle

- Zachovat standardní US rozložení pro programování.
- Přidat české znaky přes AltGr.
- Zachovat část svalové paměti z české klávesnice na číselné řadě.
- Vyhnout se kombinacím Ctrl+AltGr, aby je aplikace nepovažovaly za zkratky.
- Fungovat na NixOS, Ubuntu, Linux Mintu, X11 a GNOME/Wayland při správné konfiguraci desktopu.
- Obsahovat self-testy pro rozložení a XKB syntaxi.

## Rozložení

Viz [layout.md](./layout.md).

Důležité příklady:

```text
AltGr + c = č
AltGr + 4 = č
AltGr + 5 = ř
AltGr + ; = ů
AltGr + \\ = ň
AltGr + Shift + e = É
AltGr + ' = €
AltGr + ` = °
```

## Instalační návody

- [Instalace na NixOS](./docs/README-NixOS.cs.md)
- [Instalace na Ubuntu / Linux Mint](./docs/README-Ubuntu-Mint.cs.md)

## Vývoj

### Self-testy

Spuštění všech self-testů:

```bash
./tests/run-self-tests.sh
```

Self-testy ověřují:

- existenci požadovaných souborů,
- konzistentní použití přejmenovaného projektu, balíčku a rozložení,
- absenci starých názvů projektu,
- verzi balíčku a souboru `VERSION`,
- přítomnost důležitých mapování kláves,
- kompilaci XKB rozložení pomocí `xkbcomp`, pokud je dostupný.

### Rychlý test v X11

Přiložený testovací skript je určený pouze pro X11 session, ne pro nativní Wayland aplikace:

```bash
./scripts/test-local.sh
```

Návrat zpět:

```bash
setxkbmap us
```
