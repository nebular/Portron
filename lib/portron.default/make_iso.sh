#!/bin/bash
# ---------------------------------------------------------
# Script to create bootable Portron ISO
# BAsed on scripts for Porteus Kiosk ISO.
# Author: T.Jokiel <http://porteus-kiosk.org>
# ---------------------------------------------------------

echo "This script will create Protron ISO from files in current directory."
[ "${1}" ] || {
    echo "ERROR: Must provide destination"
    exit 1
}

# UEFI check:
[ -e boot/isolinux/efi/efiboot.img ] && efi="-eltorito-alt-boot -eltorito-platform 0xEF -eltorito-boot boot/isolinux/efi/efiboot.img -no-emul-boot"

mkisofs -o ${1} -l -J -joliet-long -R -D -A "Kiosk" \
-V "Kiosk" -no-emul-boot -boot-info-table -boot-load-size 4 \
-b boot/isolinux/isolinux.bin -c boot/isolinux/isolinux.boot $efi . > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "Saved as [1;33m`pwd | rev | cut -d/ -f2- | rev`/${1}[0m."
else
    echo "Something went wrong - could not create the ISO. Please use 'mkisofs' utility from latest 'cdrtools' package rather than 'cdr-kit'."
    echo "You can download 'mkisofs' utility directly from this location: http://porteus-kiosk.org/public/files/mkisofs"
    echo "make it executable, move to /usr/local/bin folder and rerun this script."
    sleep 2
fi
