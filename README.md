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
