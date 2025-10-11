#!/usr/bin/env bash
set -euo pipefail

# Full RESET script for RFNM + SDR++ stack on Ubuntu.
# It removes system-wide installs (under /usr and /usr/local)
# AND wipes user configuration (~/.config/sdrpp).
# Use with care.

echo ">>> Stopping any running SDR++ (best effort)"
pkill -x sdrpp || true

echo ">>> Removing librfnm (library, headers, pkg-config)"
sudo rm -f /usr/local/lib/librfnm* /usr/lib/librfnm* || true
sudo rm -rf /usr/local/include/librfnm /usr/include/librfnm || true
sudo rm -f /usr/local/lib/pkgconfig/librfnm.pc /usr/lib/pkgconfig/librfnm.pc || true

echo ">>> Removing Soapy RFNM module"
sudo rm -f /usr/local/lib/SoapySDR/modules0.8/libsoapy-rfnm.so || true
sudo rm -f /usr/lib/SoapySDR/modules0.8/libsoapy-rfnm.so || true

echo ">>> Removing SDR++ binaries, plugins and shared assets"
sudo rm -f /usr/bin/sdrpp || true
sudo rm -f /usr/lib/libsdrpp_core.so || true
sudo rm -rf /usr/lib/sdrpp || true
sudo rm -rf /usr/share/sdrpp || true
sudo rm -f /usr/share/applications/sdrpp.desktop || true

echo ">>> Removing RFNM udev rules (if installed)"
sudo rm -f /usr/local/lib/udev/rules.d/rfnm.rules || true
sudo udevadm control --reload-rules || true
sudo udevadm trigger || true

echo ">>> Refreshing dynamic linker cache"
sudo ldconfig || true

echo ">>> Resetting user config for SDR++"
rm -rf "$HOME/.config/sdrpp" || true
rm -rf "$HOME/.cache/sdrpp" || true

echo ">>> Optional: remove local build workspace (press Enter to skip)"
echo "    If you used:  $HOME/rfnm_sdrpp_setup"
read -r -t 10 -p "    Delete $HOME/rfnm_sdrpp_setup ? [y/N] " ANSWER || ANSWER="n"
if [[ "${ANSWER,,}" == "y" || "${ANSWER,,}" == "yes" ]]; then
  rm -rf "$HOME/rfnm_sdrpp_setup" || true
  echo "    Workspace removed."
else
  echo "    Skipped workspace removal."
fi

echo ">>> RESET completed."
echo "You can now run your fresh install script again."

