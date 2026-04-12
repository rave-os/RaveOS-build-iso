# RaveOS — ISO Build - 1 -

Arch Linux alapú egyedi disztribúció tőbb asztali környezettel, automatizált telepítővel és teljes témarendszerrel.

> **Build rendszer:** Forgejo CI → `mkarchiso` → automatikus kiadás
> **Alap:** Arch Linux (rolling) + CachyOS kernel + Chaotic-AUR
> **Asztali környezet:** GNOME 47+ (Wayland), Hyprland támogatás béta állapotban!

----

## Változásnapló

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
