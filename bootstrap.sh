#!/bin/sh
# vim:set et sts=0 sw=2 ts=2:

set -x

# Load SSH keys

printf "%s" "Enter your SSH key (press <C-D> when done): "
mkdir -p $HOME/.ssh
cat > $HOME/.ssh/authorized_keys
echo "SSH keys:"
cat $HOME/.ssh/authorized_keys

# Change default password

passwd

# Disable password login over SSH

sed -i "/PasswordAuthentication/d" /etc/ssh/sshd_config
echo "PasswordAuthentication no" > /etc/ssh/sshd_config
