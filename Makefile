IMG_URL ?= 
IMG_SUM ?= 
IMG_SUM_PROGRAM ?= 

IMG_ZIP ?= 
IMG_FILE ?= 

OS = $(shell uname | tr '[:upper:]' '[:lower:]')

DISK_FILE ?= 
BOOT_PARTITION ?= 

WGET ?= 
UNZIP_PROGRAM ?= 
UNZIP_ARGS ?=

DEVICE_USER ?= 

.PHONY: all install flash os-pre-$(OS) os-post-$(OS) echo deploy

all: install

install: os-pre-$(OS) flash os-post-$(OS)

echo:
	@echo "-- install --"
	@echo "IMG_URL: $(IMG_URL)"
	@echo "IMG_SUM: $(IMG_SUM)"
	@echo "IMG_SUM_PROGRAM: $(IMG_SUM_PROGRAM)"
	@echo "IMG_ZIP: $(IMG_ZIP)"
	@echo "IMG_FILE: $(IMG_FILE)"
	@echo "OS: $(OS)"
	@echo "DISK_FILE: $(DISK_FILE)"
	@echo "BOOT_PARTITION: $(BOOT_PARTITION)"
	@echo "WGET: $(WGET)"
	@echo "UNZIP_PROGRAM: $(UNZIP_PROGRAM)"
	@echo "UNZIP_ARGS: $(UNZIP_ARGS)"
	@echo "-- deploy --"
	@echo "DEVICE_USER: $(DEVICE_USER)"
	@echo "DEVICE_IP: $(DEVICE_IP)"
	@echo "DEVICE_PASS: $(DEVICE_PASS)"

deploy: echo
	ansible-playbook ansible/main.yml -i "$(DEVICE_USER)@$(DEVICE_IP)," \
		-e "ansible_ssh_pass=$(DEVICE_PASS)" \
		-e "ansible_sudo_pass=$(DEVICE_PASS)"
	ansible-playbook ansible/software.yml -i "$(DEVICE_IP),"

deploy-using-password: echo
	ansible-playbook ansible/main.yml -i "$(DEVICE_USER)@$(DEVICE_IP)," \
		-e "ansible_ssh_pass=$(DEVICE_PASS)" \
		-e "ansible_sudo_pass=$(DEVICE_PASS)"
	ansible-playbook ansible/software.yml -i "$(DEVICE_IP)," \
		-e "ansible_ssh_pass=$(DEVICE_PASS)" \
		-e "ansible_sudo_pass=$(DEVICE_PASS)"

flash: $(IMG_FILE)
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
	diskutil unmount $(BOOT_PARTITION); true

os-post-linux:
	umount $(BOOT_PARTITION); true

# }}}

$(IMG_FILE): $(IMG_ZIP)
	echo "$(IMG_SUM) $(IMG_ZIP)" | $(IMG_SUM_PROGRAM)
	$(UNZIP_PROGRAM)

$(IMG_ZIP):
	$(WGET) $(IMG_URL) -O $(IMG_ZIP)
