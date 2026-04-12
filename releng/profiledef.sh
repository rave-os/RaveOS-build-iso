#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="raveos"
iso_label="raveos_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="RaveOS"
iso_application="RaveOS Live/Rescue DVD"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux'
           'uefi.systemd-boot')
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/root/.loader.conf"]="0:0:755"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/local/bin/Installation_guide"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"
  ["/etc/pacman.d/chaotic-mirrorlist"]="0:0:644"
  ["/etc/pacman.d/mirrorlist"]="0:0:644"
  ["/etc/pacman.d/hooks/reflector-mirrorlist.hook"]="0:0:644"
  ["/etc/group"]="0:0:400"
  ["/root/.config/openbox/autostart"]="0:0:755"
  ["/etc/profile.d/autostart.sh"]="0:0:755"
  ["/usr/share/calamares/kernel-install/95-raveos.install"]="0:0:755"
)
