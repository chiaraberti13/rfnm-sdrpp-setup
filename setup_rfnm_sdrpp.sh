#!/usr/bin/env bash
set -euo pipefail

# Use all CPU cores to speed up builds
JOBS="$(nproc)"

# Workspace
WORKDIR="$HOME/rfnm_sdrpp_setup"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# 1) System update + dependencies (Ubuntu 24.04)
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
  build-essential cmake git pkg-config \
  libusb-1.0-0-dev libspdlog-dev libfftw3-dev libvolk-dev \
  libglfw3-dev libglew-dev libzstd-dev librtaudio-dev \
  libairspy-dev libairspyhf-dev librtlsdr-dev libiio-dev libad9361-dev \
  libsoapysdr-dev soapysdr-tools

# 2) Build & install librfnm
if [ -d librfnm ]; then rm -rf librfnm; fi
git clone https://github.com/rfnm/librfnm.git
cd librfnm
mkdir -p build && cd build
cmake ..
cmake --build . -j"$JOBS"
sudo cmake --install .
sudo ldconfig
cd "$WORKDIR"
sudo udevadm control --reload-rules || true
sudo udevadm trigger || true

# 3) Build & install Soapy RFNM (optional but recommended)
if [ -d soapy-rfnm ]; then rm -rf soapy-rfnm; fi
git clone https://github.com/rfnm/soapy-rfnm.git
cd soapy-rfnm
mkdir -p build && cd build
cmake ..
cmake --build . -j"$JOBS"
sudo cmake --install .
sudo ldconfig
cd "$WORKDIR"

# 4) Build & install SDR++ from your fork (RFNM + Soapy sources enabled)
if [ -d SDRPlusPlus ]; then rm -rf SDRPlusPlus; fi
git clone https://github.com/chiaraberti13/SDRPlusPlus.git
cd SDRPlusPlus
git checkout master
git submodule update --init --recursive
mkdir -p build && cd build
cmake .. -DOPT_BUILD_RFNM_SOURCE=ON -DOPT_BUILD_SOAPY_SOURCE=ON
cmake --build . -j"$JOBS"
sudo cmake --install .
sudo ldconfig

# 5) Safety checks
echo "==== CHECK: librfnm pkg-config ===="
pkg-config --cflags --libs librfnm || true
echo "==== CHECK: Soapy RFNM module ===="
SoapySDRUtil --check=rfnm || true
echo "==== CHECK: SDR++ plugins ===="
ls -l /usr/lib/sdrpp/plugins | grep -E 'rfnm_source|soapy_source' || true

# 6) Reset SDR++ config to avoid first-run freeze
echo ">>> Reset SDR++ config to avoid startup freeze"
if [ -d "$HOME/.config/sdrpp" ]; then
  mv "$HOME/.config/sdrpp" "$HOME/.config/sdrpp.bak-$(date +%s)"
fi

# 7) Final message
echo "==== INSTALL DONE ===="
echo "Launch SDR++ with a clean temp profile (recommended first run):"
echo "  sdrpp --root /tmp/sdrpp-clean"
echo
echo "Or launch normally:"
echo "  sdrpp"
