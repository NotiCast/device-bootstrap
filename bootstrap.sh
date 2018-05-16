#!/bin/sh
# vim:set et sts=0 sw=2 ts=2:

set -eux

# Load SSH keys

printf "%s" "Enter your SSH key (press <C-D> when done): "
mkdir -p $HOME/.ssh
cat > $HOME/.ssh/authorized_keys
echo "SSH keys:"
cat $HOME/.ssh/authorized_keys

# Change default password

passwd

# Disable password login over SSH

sudo sed -i "/PasswordAuthentication/d" /etc/ssh/sshd_config
echo "PasswordAuthentication no" | sudo tee -a /etc/ssh/sshd_config
