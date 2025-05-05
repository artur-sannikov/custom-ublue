#!/bin/bash

set -ouex pipefail

# Copy files to container
rsync -rvK /ctx/system_files/ /

# Install tailscale
dnf5 install -y tailscale

# Install base packages
dnf5 install -y alacritty wireguard-tools syncthing edk2-ovmf

# Install libvirt
dnf5 install -y libvirt libvirt-daemon-config-network libvirt-daemon-kvm \
    qemu-kvm virt-manager virt-viewer

# Required for nix installation later
mkdir /nix

# Enable systemd units
systemctl enable podman.socket
systemctl enable libvirtd
systemctl enable tailscaled
