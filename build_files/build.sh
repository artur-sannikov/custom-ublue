#!/bin/bash

set -ouex pipefail

NIX_INSTALLER_VERSION="v3.4.1"
INSTALLER_URL="https://github.com/determinateSystems/nix-installer/releases/download/${NIX_INSTALLER_VERSION}/nix-installer-x86_64-linux"
INSTALLER_PATH="/tmp/nix-installer"
EXPECTED_SHA256="b174ba0340f220ff8be63e8178177d5d46deff42c0ad88d66833f6ba2befbf86"

# Download Nix Determinate Systems installer
curl -fsSL -o "${INSTALLER_PATH}" "${INSTALLER_URL}"
chmod +x "${INSTALLER_PATH}"

# Verify the checksum
echo "${EXPECTED_SHA256}  ${INSTALLER_PATH}" | sha256sum -c -

# Install Nix
"${INSTALLER_PATH}" install --no-confirm

# Clean up
rm -f "${INSTALLER_PATH}"
### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y alacritty tailscale wireguard-tools syncthing edk2-ovmf

dnf5 install -y libvirt libvirt-daemon-config-network libvirt-daemon-kvm \
    qemu-kvm virt-manager virt-viewer

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

# Install nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix |
    sh -s -- install --no-confirm

#### Example for enabling a System Unit File

systemctl enable podman.socket
systemctl enable libvirtd
