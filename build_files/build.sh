#!/bin/bash

set -ouex pipefail

NIX_INSTALLER_VERSION="v3.4.1"
INSTALLER_URL="https://install.determinate.systems/nix/tag/${NIX_INSTALLER_VERSION}"
INSTALLER_PATH="/tmp/nix-installer.sh"
EXPECTED_SHA256="7df0fa6567434afd2bc4070fc789c7f431bf6392090d69b4e1a4a1e13a181a66"

# Download Nix Determinate Systems installer scrpt
curl --proto '=https' --tlsv1.2 -sSf -L -o "${INSTALLER_PATH}" "${INSTALLER_URL}"
chmod +x "${INSTALLER_PATH}"

# Verify the checksum
echo "${EXPECTED_SHA256}  ${INSTALLER_PATH}" | sha256sum -c -

# Install Nix
"${INSTALLER_PATH}" install ostree --no-confirm -- --no-start-daemon

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

#### Example for enabling a System Unit File

systemctl enable podman.socket
systemctl enable libvirtd
