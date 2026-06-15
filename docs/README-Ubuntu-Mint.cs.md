# Instalace na Ubuntu / Linux Mint

Ubuntu a Linux Mint mohou toto rozložení používat také. Samotné rozložení je běžný XKB symbols soubor, takže není specifické pouze pro NixOS.

Anglická verze: [README-Ubuntu-Mint.md](./README-Ubuntu-Mint.md)

## Instalace symbols souboru

Z kořene repozitáře:

```bash
sudo cp xkb/symbols/us-cz-altgr-programmer /usr/share/X11/xkb/symbols/us-cz-altgr-programmer
```

## Test v X11

V X11 session ho otestujte takto:

```bash
setxkbmap us-cz-altgr-programmer -option lv3:ralt_switch
```

Návrat na standardní US rozložení:

```bash
setxkbmap us
```

## GNOME na Ubuntu / Mint Waylandu

GNOME na Waylandu obvykle ignoruje `setxkbmap` pro nativní Wayland aplikace. Nastavte vstupní zdroj přes dconf:

```bash
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us-cz-altgr-programmer')]"
gsettings set org.gnome.desktop.input-sources xkb-options "['lv3:ralt_switch']"
```

Potom se odhlaste a znovu přihlaste.

Nastavení ověřte pomocí:

```bash
gsettings get org.gnome.desktop.input-sources sources
gsettings get org.gnome.desktop.input-sources xkb-options
```

Očekávané hodnoty obsahují:

```text
[('xkb', 'us-cz-altgr-programmer')]
['lv3:ralt_switch']
```

## Testovací klávesy

```text
AltGr + c = č
AltGr + 4 = č
AltGr + 5 = ř
AltGr + ; = ů
AltGr + \\ = ň
AltGr + Shift + e = €
AltGr + Shift + ` = °
```

## Self-testy

Pokud máte na Ubuntu/Mintu nainstalovaný Nix, můžete použít vývojový shell:

```bash
nix-shell
./tests/run-self-tests.sh
```

Se zapnutými flaky:

```bash
nix develop
./tests/run-self-tests.sh
```

Bez Nixu nainstalujte `xkbcomp` z distribuce a spusťte:

```bash
./tests/run-self-tests.sh
```

## Poznámky ke grafickému nastavení klávesnice

Bez registrace rozložení v XKB rules se rozložení nemusí hezky zobrazit v grafickém výběru klávesnice. Stále ho ale lze aktivovat přes `setxkbmap` na X11 nebo přes `gsettings` v GNOME/Wayland.

Plnohodnotný Ubuntu/Mint balíček by navíc mohl instalovat metadata XKB rules, aby se rozložení zobrazovalo ve výběru klávesnice v desktopovém prostředí.

## Odinstalace

Odstraňte symbols soubor:

```bash
sudo rm /usr/share/X11/xkb/symbols/us-cz-altgr-programmer
```

Potom přepněte zpět na jiné rozložení, například:

```bash
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us')]"
gsettings set org.gnome.desktop.input-sources xkb-options "[]"
```
