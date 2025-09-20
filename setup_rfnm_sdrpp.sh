#!/usr/bin/env bash
set -euo pipefail

JOBS="$(nproc)"
WORKDIR="$HOME/rfnm_sdrpp_setup"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y build-essential cmake git pkg-config libusb-1.0-0-dev libspdlog-dev libsoapysdr-dev soapysdr-tools qtbase5-dev qtmultimedia5-dev libvolk-dev libfftw3-dev libglfw3-dev libglew-dev soapysdr-module-audio

if [ -d librfnm ]; then rm -rf librfnm; fi
git clone https://github.com/rfnm/librfnm.git
cd librfnm
mkdir -p build
cd build
cmake ..
cmake --build . --config Release -j"$JOBS"
sudo cmake --install .
sudo ldconfig
cd "$WORKDIR"

if [ -d soapy-rfnm ]; then rm -rf soapy-rfnm; fi
git clone https://github.com/rfnm/soapy-rfnm.git
cd soapy-rfnm
mkdir -p build
cd build
cmake ..
cmake --build . --config Release -j"$JOBS"
sudo cmake --install .
sudo ldconfig
sudo udevadm control --reload-rules
sudo udevadm trigger
cd "$WORKDIR"

if [ -d SDRPlusPlus ]; then rm -rf SDRPlusPlus; fi
git clone https://github.com/AlexandreRouma/SDRPlusPlus.git
cd SDRPlusPlus
git submodule update --init --recursive
mkdir -p build
cd build
cmake .. -DOPT_BUILD_SOAPY_SOURCE=ON
cmake --build . --config Release -j"$JOBS"
sudo cmake --install .

if [ -d "$HOME/.config/sdrpp" ]; then mv "$HOME/.config/sdrpp" "$HOME/.config/sdrpp.bak-$(date +%s)"; fi

echo "==== CHECK: pkg-config librfnm ===="
pkg-config --libs --cflags librfnm || true
echo "==== CHECK: SoapySDRUtil --info ===="
SoapySDRUtil --info || true
echo "==== CHECK: SoapySDRUtil --find ===="
SoapySDRUtil --find || true
echo "==== CHECK: SDR++ plugin path ===="
ls -l /usr/lib/sdrpp/plugins/soapy_source.so
echo "==== DONE. Launch with: sdrpp ===="

