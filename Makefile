IMG_URL = https://dl.armbian.com/orangepizero/Debian_stretch_next.7z
IMG_SUM = b1bc3f794ddd44a86e9290b15124ca40b5cce58b5341ce7d0739c18ff93d347f
IMG_SUM_PROGRAM = gsha256sum --check

IMG_ZIP = Debian_stretch_next.7z
IMG_FILE = Armbian_5.38_Orangepizero_Debian_stretch_next_4.14.14.img

OS = $(shell uname | tr '[:upper:]' '[:lower:]')

DISK_FILE = /dev/disk2
BOOT_PARTITION = $(DISK_FILE)s1

WGET = wget
UNZIP = 7za x

KEYS = vandor2012@gmail.com

.PHONY: image shell-keys

all: install shell-keys

install: os-pre-$(OS) flash os-post-$(OS)

flash: raspbian.img
	pv < "$(IMG_FILE)" | sudo dd of="$(DISK_FILE)" bs=1m
	sync

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
	cp keys/*.pub ansible/keys

%.pub:
	gpg --export-ssh-key $(@:.pub=) > $@

$(IMG_FILE): $(IMG_ZIP)
	echo "$(IMG_SUM) $(IMG_ZIP)" | $(IMG_SUM_PROGRAM)
	$(UNZIP) $(IMG_ZIP)

$(IMG_ZIP):
	$(WGET) $(IMG_URL) -O $(IMG_ZIP)
