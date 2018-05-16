#!/bin/bash
# vim:set et sts=0 sw=2 ts=2:

sudo echo "authenticated"

set -x

DEFAULT_USERNAME="${DEFAULT_USERNAME:-pi}"
DEFAULT_PASSWORD="${DEFAULT_PASSWORD:-raspberry}"

IMG_URL="${IMG_URL:-https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2018-04-19/2018-04-18-raspbian-stretch-lite.zip}"
IMG_SUM="${IMG_SUM:-5a0747b2bfb8c8664192831b7dc5b22847718a1cb77639a1f3db3683b242dc96}"
IMG_SUM_PROGRAM="${IMG_SUM_PROGRAM:-gsha256sum}"

DISK_FILE="${DISK_FILE:-/dev/disk2}"
BOOT_PARTITION="${BOOT_PARTITION:-${DISK_FILE}s1}"

UNZIP="${UNZIP:-unzip} -p"
WGET="${WGET:-wget}"

OS="${OS:-$(uname)}"

# Download the image

[ ! -f "img.zip" ] && $WGET $IMG_URL -O img.zip

# Verify the image zip file

if ! echo "$IMG_SUM *img.zip" | $IMG_SUM_PROGRAM --check; then
  echo "Sum verification failed"
  exit 1
fi

# Unzip and send to disk

[ ! -f raspbian.img ] && $UNZIP img.zip > raspbian.img

# Unmount auto-mounted partitions

case $OS in
  Darwin)
    diskutil unmount $BOOT_PARTITION
    break
    ;;
esac

# Write image to disk

pv < raspbian.img | sudo dd of="$DISK_FILE" || echo "Make sure disk is not mounted"

# Remount boot partition and enable SSH

case $OS in
  Darwin)
    diskutil mount $BOOT_PARTITION
    touch /Volumes/boot/ssh
    diskutil unmount $BOOT_PARTITION
    break
    ;;
  Linux)
    mkdir -p boot
    mount $BOOT_PARTITION boot
    touch ./boot/ssh
    unmount $BOOT_PARTITION
    break
    ;;
esac

# Run bootstrap.sh

cat <<EOF

Please remove the SD card and boot up the device. On bootup, the device will
list it's IP address, a few lines above the login prompt. Enter the IP address:

EOF

read ip_address
ssh_address="$DEFAULT_USERNAME@$ip_address"

echo "The default password is: '$DEFAULT_PASSWORD'."
scp bootstrap.sh "$ssh_address":
ssh -t "$ssh_address" sh bootstrap.sh  # use -t to enable terminal input

# Copy software to devices

rsync -vr vendor/ "$ssh_address":

# Run all vendor bootstraps from local machine (copying secrets, etc.)

find vendor/ -type f -name 'bootstrap-local.sh' -exec sh {} "$ip_address" \;

# Run all vendor bootstraps on remote machine

ssh -t "$ssh_address" find vendor/ -type f -name 'bootstrap.sh' -exec sh {} '\;'

echo "You can now power off your device."
