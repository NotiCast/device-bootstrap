# Raspberry Pi Bootstrap
<!-- vim:set et sts=0 sw=2 ts=2: -->

## Environment Variables

Change these as you see fit. It is advised to go through the script to make
sure the commands look like they're supposed to. Most defaults are configured
for macOS.

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

1. Run `make install` to install the image onto the SD card
2. Remove the SD card, put it in the device, and let it start booting
  - Note down the IP address for use with later steps
  - The device will print out an IP address if you can't nmap to find it
3. Log in to the device to ensure setup is finished
  - Root user/pass for Armbian is `root` and `1234`
  - Default user/pass for Raspbian is `pi` and `raspberry`
3. Run `make shell-keys` to generate the shell keys used by Ansible
4. Once the device boots up, run the following (s/'10.1.30.104'/your IP):
  - **Note:** The comma on the commands below *is* necessary
  - `ansible-playbook ansible/main.yml -i '10.1.30.104,'`
  - `ansible-playbook ansible/10-programs.yml -i '10.1.30.104,'`
