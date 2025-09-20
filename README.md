# RFNM SDR++ Setup

This repository provides an installation script to set up **SDR++** together with **RFNM hardware support**.  
The script automates the process of fetching and building the required software from the official repositories.

## Description

The included script `setup_rfnm_sdrpp.sh` installs and configures:
- **SDR++**: a fast and modular SDR software  
- **RFNM drivers**: enabling compatibility with RFNM SDR hardware  

By running the script, you will automatically clone the official repositories, build them, and prepare the environment to run SDR++ with RFNM support.

## Usage

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/rfnm-sdrpp-setup.git
   cd rfnm-sdrpp-setup
   ```

2. Run the setup script:
   ```bash
   chmod +x setup_rfnm_sdrpp.sh
   ./setup_rfnm_sdrpp.sh
   ```

3. Start **SDR++** after installation:
   ```bash
   cd ~/SDRPlusPlus/build
   sdrpp
   ```

## References

This project uses the following official repositories:

- [SDR++](https://github.com/AlexandreRouma/SDRPlusPlus)  
- [RFNM driver](https://github.com/rfnm-labs/rfnm-driver)  
