#!/bin/bash

set -ouex pipefail

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y alacritty tailscale wireguard-tools syncthing edk2-ovmf

dnf5 install -y libvirt libvirt-daemon-config-network libvirt-daemon-kvm \
    qemu-kvm virt-manager virt-viewer

# Remove old tailscale from base image (it's out-of-date)
dnf5 remove tailscale

# Install tailscale according to official instructions
dnf5 config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
dnf5 install tailscale

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

mkdir /nix

#### Example for enabling a System Unit File

systemctl enable podman.socket
systemctl enable libvirtd
systemctl enable tailscaled
