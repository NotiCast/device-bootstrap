# Raspberry Pi Bootstrap
<!-- vim:set et sts=0 sw=2 ts=2: -->

## Environment Variables

Change these as you see fit. It is advised to go through the script to make
sure the commands look like they're supposed to. Most defaults are configured
for macOS.

- `DEFAULT_USERNAME`: The default username for the downloaded image
- `DEFAULT_PASSWORD`: The default password for the downloaded image
- `IMG_URL`: The URL of a zip file containing the image, defaulting to a
    (hopefully) recent Raspbian
- `IMG_SUM`: The sha256 sum of the zip file containing the image
- `IMG_SUM_PROGRAM`: A `sha256sum` program; `gsha256sum` on macOS
- `DISK_FILE`: The `/dev` file mapped to the SD card
- `BOOT_PARTITION`: Maps to the boot partition, defaults to `"${DISK_FILE}s1"`,
    but will likely be `1` on Linux
- `UNZIP`: A program that will write the first file of a zip file to output
- `WGET`: A `wget` compatible program
- `OS`: Either "Linux" or "Darwin"; used for configuring OS-specific mounts

## The Build Process

Several things will happen during your build which require user interaction:

- You will be asked to remove the disk and power on the device
- The device will boot, and before the login screen, will list an IP address
- You will enter the IP address, and then be prompted for a password
- You will be prompted to load SSH keys.
- You will be prompted to change the default password

After that, the script should be finished and you should be prompted to power
down the device. You should no longer use SSH with a password to connect to the
device, but instead use the SSH key.
