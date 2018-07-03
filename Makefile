IMG_URL = https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2018-04-19/2018-04-18-raspbian-stretch-lite.zip
IMG_SUM = 5a0747b2bfb8c8664192831b7dc5b22847718a1cb77639a1f3db3683b242dc96
IMG_SUM_PROGRAM = gsha256sum --check

OS = $(shell uname | tr '[:upper:]' '[:lower:]')

DISK_FILE = /dev/disk2
BOOT_PARTITION = $(DISK_FILE)s1

WGET = wget
UNZIP = unzip -p

KEYS = vandor2012@gmail.com

.PHONY: image shell-keys

all: install flash shell-keys

install: os-pre-$(OS) flash os-post-$(OS)

flash: raspbian.img
	pv < raspbian.img | sudo dd of="$(DISK_FILE)" bs=1m

# {{{ pre-write stuff | unmount partition

os-pre-darwin:
	diskutil unmount $(BOOT_PARTITION); true

os-pre-linux:
	true

# }}}

# {{{ post-write stuff | touch the boot partition's `ssh` file

os-post-darwin:
	diskutil mount $(BOOT_PARTITION)
	touch /Volumes/boot/ssh
	diskutil unmount $(BOOT_PARTITION)

os-post-linux:
	mkdir -p boot
	mount $(BOOT_PARTITION) boot
	touch ./boot/ssh
	unmount $(BOOT_PARTITION)

# }}}

shell-keys: $(foreach key,$(KEYS),$(key).pub)
	rm -rf ansible/keys
	mkdir -p ansible/keys
	mv *.pub ansible/keys

%.pub:
	gpg --export-ssh-key $(@:.pub=) > $@

raspbian.img: raspbian.img.zip
	echo "$(IMG_SUM) raspbian.img.zip" | $(IMG_SUM_PROGRAM)
	$(UNZIP) raspbian.img.zip > raspbian.img

raspbian.img.zip:
	$(WGET) $(IMG_URL) -O raspbian.img.zip
