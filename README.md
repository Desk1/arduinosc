# DIY Rubber Ducky Project

A cybersecurity demonstration that showcases the capabilities of a Digispark Attiny85 USB microcontroller acting as a keystroke injection device. The project is designed to raise awareness about potential security vulnerabilities that can arise from improper USB device usage.


## How It Works

The Digispark Attiny85 is programmed to run a PowerShell payload script when connected to a target computer. The script gathers various information and exports it to text files. The collected data includes:
- Network adapter details
- Computer information
- Browser history
- Credential manager entries

The collected data is then compressed into a zip file, which is uploaded to a remote file sharing service. This allows the attacker (in a controlled environment) to retrieve the dumped information from the target computer.

## Usage

1. Program the Digispark ATtiny85 with the provided payload script.
2. Connect the Digispark to the target computer's USB port.
3. The payload script will run automatically and gather data.
4. The gathered data will be compressed and uploaded to a remote server.
5. Retrieve the uploaded data from the provided link.

**Note:** This project is intended for educational and cybersecurity demonstration purposes only. Ensure you have proper authorization before conducting any tests.
