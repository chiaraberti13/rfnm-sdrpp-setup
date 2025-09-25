# RFNM SDR++ Setup

This repository provides an **automated installation script** that sets up **SDR++** with full **RFNM hardware support**.
It downloads, builds, and installs all required dependencies, ensuring that SDR++ runs with the **RFNM source module** and the **Soapy RFNM driver** enabled.

---

## ✨ What the script does

The provided script `setup_rfnm_sdrpp.sh` performs the following steps:

1. **Installs system dependencies**
   Installs all required libraries and tools for SDR++ and RFNM support (CMake, libusb, FFTW, Volk, SoapySDR, etc.).

2. **Builds and installs RFNM driver (librfnm)**
   Fetches the official [librfnm](https://github.com/rfnm/librfnm), builds it, and installs it system-wide.

3. **Builds and installs Soapy RFNM module**
   Fetches [soapy-rfnm](https://github.com/rfnm/soapy-rfnm), builds it, and installs the SoapySDR driver for RFNM devices.

4. **Builds SDR++ with RFNM support**
   Clones [SDR++](https://github.com/chiaraberti13/SDRPlusPlus) (this fork includes the **RFNM source module fix**) and compiles it with:

   * `OPT_BUILD_RFNM_SOURCE=ON` (RFNM direct support)
   * `OPT_BUILD_SOAPY_SOURCE=ON` (Soapy devices support)

5. **Resets SDR++ configuration**
   Removes any existing SDR++ configuration that could cause the software to freeze on first launch.
   A clean configuration folder will be created automatically at first run.

---

## 🚀 Usage

### 1. Clone this repository

```bash
git clone https://github.com/chiaraberti13/rfnm-sdrpp-setup.git
cd rfnm-sdrpp-setup
```

### 2. Run the setup script

```bash
chmod +x setup_rfnm_sdrpp.sh
./setup_rfnm_sdrpp.sh
```

The script will:

* Download and build **librfnm**
* Download and build **soapy-rfnm**
* Download and build **SDR++ with RFNM support**
* Install everything into your system

---

## ▶️ Running SDR++

### Recommended first run (clean temporary profile)

```bash
sdrpp --root /tmp/sdrpp-clean
```

This ensures SDR++ starts with a clean profile and avoids configuration issues.

### Normal run

```bash
sdrpp
```

---

## 🔧 Cleanup / Reset

If you want to completely remove SDR++, librfnm, and soapy-rfnm, use the **reset script**:

```bash
chmod +x reset_rfnm_sdrpp.sh
./reset_rfnm_sdrpp.sh
```

This script will:

* Remove `librfnm` libraries
* Remove Soapy RFNM driver
* Remove SDR++ binaries and plugins
* Refresh the system library cache

---

## 📂 Installed components

* **librfnm** → `/usr/local/lib/` and `/usr/local/include/librfnm`
* **soapy-rfnm** → `/usr/local/lib/SoapySDR/modules0.8/`
* **SDR++** → `/usr/lib/sdrpp/` and `/usr/bin/sdrpp`

---

## 📖 References

This setup uses the following official repositories:

* [SDR++ (upstream)](https://github.com/AlexandreRouma/SDRPlusPlus)
* [SDR++ (this fork with RFNM support)](https://github.com/chiaraberti13/SDRPlusPlus)
* [librfnm](https://github.com/rfnm/librfnm)
* [soapy-rfnm](https://github.com/rfnm/soapy-rfnm)

---

## 🔌 Recommended USB-C Cable (for best performance)

* **Standard:** USB 3.2 Gen 2x2
* **Data Transfer Speed:** up to 20Gbps (backward compatible with USB 3.1/3.0/2.0)
* **Video Output:** up to 8K\@30Hz, 5K\@60Hz, 4K\@144Hz
* **Compatibility:** requires devices supporting USB 3.2 or higher (USB4 / Thunderbolt 3/4)
* **Note:** video output requires USB-C ports with **DP Alt Mode** support
