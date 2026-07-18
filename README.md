# RaveOS — ISO Build....

Arch Linux alapú egyedi disztribúció tőbb asztali környezettel, automatizált telepítővel és teljes témarendszerrel.
#
> **Build rendszer:** Forgejo CI → `mkarchiso` → automatikus kiadás
> **Alap:** Arch Linux (rolling) + CachyOS kernel + Chaotic-AUR
> **Asztali környezet:** GNOME 47+ (Wayland), Hyprland támogatás béta állapotban!

----

## Változásnapló

## Build 2026-07-18

#### `[boot]` Plymouth boot splash bevezetve
- Egyedi RaveOS téma (bagoly logó, zöld pöttyök, időalapú fázis-szövegváltás) élő ISO-n és telepített rendszeren is
- `HOOKS+=plymouth` mind az élő ISO, mind a célrendszer `mkinitcpio.conf`-jában

#### `[calamares]` Hiányzó `root=` javítva a boot-bejegyzésben
- `95-raveos.install` (kernel-install hook) `findmnt`-alapú root-detektálása üresen térhetett vissza a pacstrap chroot kontextusban → `root=` nélküli, nem bootolható bejegyzés jött létre
- Tartalék detektálás hozzáadva: `/proc/mounts`, majd `/etc/fstab`
- Záró biztonsági háló a telepítés végén (`calamares-fix-bootentry.sh`): ha valamelyik bejegyzésből mégis hiányozna a `root=`, az `/etc/fstab`-ból pótolja

#### `[calamares]` Btrfs subvolume-elrendezés bevezetve
- Eddig `erase` módban egyetlen lapos `@` subvolume jött létre — nincs elkülönítve semmi
- Mostantól archinstall-stílusú elrendezés (`partition.conf`): `@` → `/`, `@home` → `/home`, `@log` → `/var/log`, `@pkg` → `/var/cache/pacman/pkg`, `@snapshots` → `/.snapshots`
- Előfeltétele a snapshot-alapú eszközöknek (`grub-btrfs`, Snapper)

## Build 2026-07-06

#### `[security]` GPG csomag-aláírás bevezetve
- `[raveos-core-repo]` `SigLevel` átállítva `Never TrustAll`-ról `Required DatabaseOptional`-ra — minden csomag aláírás-ellenőrzés kötelező, az adatbázis-aláírás opcionális
- `raveos-keyring` csomag hozzáadva a `packages.x86_64`-hez és a `shellprocess-pacstrap.conf` kezdeti pacstrap listájához — ez biztosítja hogy a célrendszer bizalma a kulcsban már a nagy csomag-batch előtt beálljon

#### `[iso]` `packages.x86_64` nagytakarítás
- ~70 elavult rescue/live-környezet/VM-guest csomag eltávolítva — RaveOS mára tisztán telepítő-orientált, nincs külön live/rescue pozicionálás
- `yay-bin` eltávolítva (a `packages.x86_64`-ből és a `shellprocess-pacstrap.conf`-ból is) — pacman repo-elsőbbség miatt ha nálunk van pinnelve, sosem frissül a Chaotic-AUR-ról; most szabadon a Chaotic-AUR-ról jön
- `bluez`/`bluez-libs`/`bluez-tools`/`bluez-utils` és `hblock` átkerült a `packages.x86_64`-ből (élő ISO) a `desktopselect.conf` mandatory_packages-ébe (végleges rendszer) — az élő médiumon nem kellenek, de a telepített rendszeren igen
- `cow_spacesize=75%` — a korábbi hiányzó érték miatt az archiso alapértelmezett 256M-re esett vissza (az eredeti szándék 4G volt)

#### `[calamares]` Telepítési hibajavítások (valódi telepítési tesztekkel feltárva)
- `lsb-release` visszaállítva a csomaglistába — hiánya a `shellprocess-branding.conf`-ot törte
- `raveos-kde-theme` → helyes név `raveos-plasma-theme` (két helyen: `desktopselect.conf` és `shellprocess-final.conf` auto-apply ellenőrzés)
- `plasma-bigscreen` eltávolítás `-Rns`-ről `-Rcns`-re javítva (a `-Rns` némán elhasalt függőség-ütközésen)
- `raveos-sddm-theme`: `qt6-multimedia` függőség hozzáadva (SDDM alapértelmezett megjelenésre esett vissza nélküle)
- `raveos-welcome` és `raveos-app-installer` felvéve a `desktopselect.conf` mandatory_packages közé.
- `sddm-astronaut-theme` maradék hivatkozás eltávolítva a `desktopselect.conf`-ból (csomag-ütközést okozott a törlése után)

#### `[core-repo]` Nem használt AUR-bináris csomagok eltávolítva
- `hyprshell`, `zenpower5-dkms-git` törölve a `raveos-core-repo`-ból

## Build 2026-06-18

#### `[iso]` pipewire csomagok manual hozzaadva, calamares theme frissitve

### Build 2026-05-10

#### `[iso]` chaotic-rankmirrors — automatikus mirror rangsoroló
- Boot után automatikusan teszteli az összes Chaotic-AUR mirrort válaszidő (TTFB) alapján
- A top 5 leggyorsabb mirrort írja be a `/etc/pacman.d/chaotic-mirrorlist`-be
- `After=network-online.target` — mire a Calamares indul, már a legjobb mirror aktív
- Tesztelt mirrorok: de, cdn, geo, pl, nl, ch, se, fr, gb és régióspecifikus variánsaik

#### `[iso]` Mirror optimalizálás
- Hivatalos Arch mirrorlist frissítve: HU/AT/DE/PL/CZ régió, HTTPS, rate szerint rendezve
- Chaotic-AUR: DE mirror prioritizálva közép-európai felhasználóknak

#### `[tools]` raveos-tools 1.0.0-5
- `update-flatpak` parancs eltávolítva a `rave` bash completionből

#### `[ci]` Build workflow javítások
- Runner verzió eltérésnél automatikus `pacman -Syu` fut le, nem épít hibát
- ISO mount loop eszköz hiba kezelés javítva — ha a loop eszköz nem elérhető, figyelmeztetés helyett folytatódik a build
- ISO feltöltés: részletesebb logolás, `-f` flag hozzáadva
- Régi release-ek automatikus törlése: mindig csak az utolsó 3 marad

#### `[ci]` raveos-core-repo repoadd workflow javítás
- `actions/checkout@v4` lecserélve manuális SSH klónra — az HTTPS-en keresztüli nagy bináris repo (1.8GB) SSL EOF hibát okozott Nginx mögött
- SSH klón megkerüli az SSL terminálást, stabil nagy repo esetén is

### Build 2026-04-08

#### Főbb változások

- Calamares frissítve lett a jelenlegi legújabb használt verzióra.
- Bekerült a Legacy boot támogatás az ISO-ba.
- Frissítve lett a `chaotic-mirrorlist` csomag.
- A Calamares most már MBR partíciós sémán is rendesen tud GRUB-bal telepíteni.
- A `grub` bekerült a pacstrap által telepített alapcsomagok közé.
- A Calamares fordítási készlete a szükséges nyelvekre lett szűkítve.
- Javítva lett a Calamares nyelvválasztó lenyíló menü megjelenése a sötét témában.


### Build 2026-02-27

#### `[app]` RaveOS App Installer

- **rave CLI integráció** — `rave` rendszer karbantartó parancs (upgrade, clean, autoremove, install, remove, search, stb.) és bash completion (`rave-comp.sh`) beépítve a csomagba. Orphan cleanup guard fix (`pacman -Qtdq` üres → skip).
- **13 dconf INI fájl** — 6 új beállítás fájl: `nautilus.ini` (tree-view, show-hidden), `media-keys.ini` (Ctrl+Alt+T = Terminal), `peripherals.ini` (numlock, flat mouse), `session.ini` (idle-delay 900), `app-folders.ini` (System mappa), `gtk4-file-chooser.ini` (sort-directories-first). 2 frissített: `shell.ini`, `extensions.ini`.
- **Hidden apps** — 6 felesleges alkalmazás (`bssh`, `bvnc`, `avahi-discover`, `vim`, `qvidcap`, `qv4l2`) elrejtése NoDisplay=true override-dal a `~/.local/share/applications/` mappában.
- **dash-to-dock frissítés** — fekete háttér, 33% átlátszóság, 44px ikonok, DOTS running indicator stílus, minimize-or-overview kattintás.
- **burn-my-windows** — `aura-glow-animation-time=444` hozzáadva.
- **blur-my-shell, vitals, shutdowntimer** beállítások frissítése.
- **SHA256 manifest** — 623 fájl, 0 FAIL.

#### `[theme]` profile.d export fix

- **profile.d export bug javítás** — `export _RAVEOS_GREETING_DONE=1` → `_RAVEOS_GREETING_DONE=1` (export nélkül). A GDM login shellje source-olja a `/etc/profile.d/` scripteket → `export` esetén a változó öröklődik a gnome-session és minden gyerek processzhez → a guard blokkolta a fastfetch-et minden terminálon. Fix: shell-local változó, nem öröklődik.

#### `[iso]` Csomagok

- **`hblock` hozzáadva** a `packages.x86_64`-hez — a `rave upgrade` parancs használja, nélküle "command not found" hiba volt.

#### `[theme]` Terminál és SHA256 javítások
- **GNOME Console terminál téma javítás** — a `/etc/profile.d/` scriptek csak login shellben futnak, de a GNOME Console (kgx) nem login shellt indít. Megoldás: `.bashrc` snippet hozzáadva, ami source-olja a profile.d scriptet. Guard változó (`_RAVEOS_GREETING_DONE`) megakadályozza a dupla futást login shelleknél.
- **GNOME kitty telepítés javítás** — a GNOME téma többé nem telepíti automatikusan a kitty csomagot (csak `fastfetch`). A kitty konfig fájlok a témában maradnak, így ha a felhasználó kézzel felrakja a kitty-t, a téma azonnal érvényes.
- **Hyprland terminál támogatás bővítés** — a Hyprland `theme-data.tar.gz` mostantól tartalmazza a fastfetch, kitty és profile.d fájlokat (korábban hiányoztak). A `metadata.json` kiegészítve terminal szekciókkal, a kitty automatikusan települ.
- **SHA256 metadata.json javítás** — mindkét metadata.json (GNOME + Hyprland) frissítve, manifest újragenerálva, 437/437 fájl hash egyezik.


### Build 2026-02-26

#### `[app]` RaveOS App Installer

- **SHA256 integritásvédelem** — minden művelet (telepítés, törlés, mentés, visszaállítás, téma alkalmazás) blokkolva van, ha bármely követett fájl módosult. Az Infó oldalon valós idejű integritás állapot látható a módosult fájlok listájával. ISO telepítés alatt (Calamares) még nincs manifest, így az ellenőrzés nem blokkol.
- **Terminál üdvözlő rendszer** — a téma alkalmazás mostantól telepíti a fastfetch + kitty csomagokat és beállít egy rendszerszintű terminál üdvözlőt az `/etc/profile.d/`-n keresztül. GNOME Console-ban ASCII "RAVE OS" szöveges banner jelenik meg, Kitty terminálban a teljes bagoly logó PNG-ként a kitty grafikus protokollon keresztül. A kitty kép reszponzív — 8–24 sor között skálázódik a terminál magasságától függően.
- **Extension frissítés** — a `unity-like-appswitcher@gonza.com` lecserélve a karbantartott fork-ra: `unity-like-appswitcher-reforged@gabeszm` (magyar lokalizációval).
- **Téma oldal UI** — a GNOME és Hyprland téma kártyák most már vízszintesen középre igazítottak.
- **Hyprland terminál támogatás** — a `_setup_terminal()` hívás a `apply_gnome_theme()` és `apply_hyprland_theme()` függvényekből is meghívódik, így mindkét asztali környezet megkapja a fastfetch + kitty beállítást.
- **Verzió konzisztencia** — minden belépési pont (`main.py`, `bin/raveos-app-installer.py`) a központi `config.py`-ból importálja az `APP_VERSION`-t a beégetett stringek helyett.
- **Infó oldal** — alkalmazás verzió, lista verzió, téma verzió és SHA256 integritás állapot egyetlen kártya elrendezésben.

#### `[theme]` GNOME Téma (theme-data.tar.gz)

- `fastfetch/config.jsonc` — szöveges logó konfig hagyományos terminálokhoz
- `fastfetch/config-kitty.jsonc` — PNG képes logó konfig "RaveOS Beta 2.0" fejléccel
- `fastfetch/raveos-logo.txt` — színes RAVE OS blokkbetűs banner (zöld + cián)
- `fastfetch/raveos-logo.png` — 256×256 optimalizált bagoly logó kitty protokollhoz
- `kitty/kitty.conf` — Nord sötét téma, JetBrains Mono betűtípus, 0.92 átlátszóság
- `profile.d/raveos-fastfetch.sh` — rendszerszintű üdvözlő script reszponzív képpel
- Extension csere: `unity-like-appswitcher@gonza.com` → `unity-like-appswitcher-reforged@gabeszm`
- `dconf/shell.ini` enabled-extensions lista frissítve az új extension UUID-val

#### `[calamares]` Telepítő

- **IgnorePkg munkafolyamat:**
  - Build-idejű `pacman.conf`: IgnorePkg **aktív** (megakadályozza a GNOME 48/mutter frissítést ISO build alatt)
  - `airootfs/etc/pacman.conf`: IgnorePkg **kikommentelve** (inaktívan szállítva a felhasználónak)
  - `shellprocess-enableservices.conf`: első indításkor visszaállítja az IgnorePkg-t sed-del

#### `[iso]` Csomagok és rendszer

- `p7zip` → `7zip` (Arch csomagnév változás)
- `xone-dkms` → `xpadneo-dkms` (jobb Xbox kontroller támogatás)
- `zenpower` flatpak → `cpupower-gui` pacman (chaotic-aur, natív)
- Bluetooth modul eltávolítva az alkalmazáslistából (rendszerszintű, nem felhasználó által telepíthető)
- GNOME Screenshot eltávolítva (GNOME 47+-ba beépítve)
- `pamac` → `octopi` (grafikus csomagkezelő csere)
- `vulkan-radeon` megjelölve mint `removable: false`
- Reflector: első indítási szolgáltatás (`reflector-once.service`) automatikusan magyar tükröket választ
- Discord telepítő script tartalmazza a Vencord + OpenAsar modokat és pacman hookot az automatikus újratelepítéshez Discord frissítés után


### Build 2026-02-15 — Első béta

- Első nyilvános béta kiadás (`RaveOS-2.0-Beta`)
- GNOME asztali környezet Yaru-olive-dark témával, zöld akcentussal
- Adwaitaru-olive ikon téma
- blur-my-shell, dash-to-dock, burn-my-windows, rounded-window-corners, Vitals kiegészítők
- SDDM astronaut téma egyedi RaveOS háttérképpel
- Calamares telepítő RaveOS arculattal és egyedi modulokkal
- RaveOS App Installer (PyQt6) 60+ válogatott alkalmazással
- Mentés/visszaállítás rendszer kiválasztható elemekkel és méret kijelzéssel
- Többnyelvű támogatás (angol, magyar)
- Automatikus frissítési rendszer Forgejo repositoryból
- Chaotic-AUR és yay-bin előtelepítve

---

### Pre-Beta (2026-01 → 2026-02)

`[hardware]` Microcode frissítések (AMD + Intel) · Zenpower5 integráció · Automatikus VGA driver felismerés (Intel/AMD/NVIDIA) · WiFi modul támogatás (Broadcom, Atheros, MediaTek, Intel, Marvell, Qualcomm) · Bluetooth stack (bluez + eszközök)

`[kernel]` CachyOS kernel teljesítmény javításokkal · DKMS támogatás külső modulokhoz (broadcom-wl-dkms) · linux-headers modulépítéshez

---

## Mappa struktúra

```
releng/
├── airootfs/          # Gyökér fájlrendszer overlay
│   ├── etc/           # Rendszer konfiguráció (pacman, dconf, sddm, calamares)
│   └── usr/           # Binárisok, szolgáltatások, hookok
├── efiboot/           # EFI boot konfiguráció
├── grub/              # GRUB bootloader konfig - Kezdetleges config egyelőre hibát dob.
├── syslinux/          # Syslinux bootloader konfig
├── packages.x86_64   # Csomaglista (181 csomag)
├── pacman.conf        # Build-idejű pacman konfiguráció
└── profiledef.sh      # ISO metaadatok és build beállítások
```

## Build

```bash
./build.sh
```
