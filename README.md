# Bluetooth NAP Autoconnect

This project automates the process of establishing a Bluetooth Network Access Point (NAP) connection between a Raspberry Pi and a smartphone. It ensures that the devices are paired, trusted, and an IP address is obtained automatically.

Tested on RPi Zero 2W + Kali linux + Motorola Edge 40

## Prerequisites

Before you start, make sure you have:
- A Raspberry Pi with Bluetooth capability.
- A smartphone with Bluetooth and capability to act as a NAP server.

## Initial Setup

### Pairing and Trusting Devices

1. **Manual Pairing**: On the Raspberry Pi, start by opening the terminal and running `bluetoothctl` (or with blueman-manager via UI). Use the following commands to pair and trust your smartphone with bluetiithctl:

    ```bash
    power on
    agent on
    scan on
    # Wait for your device's MAC address to appear, then
    pair [YOUR_DEVICE_MAC_ADDRESS]
    trust [YOUR_DEVICE_MAC_ADDRESS]
    connect [YOUR_DEVICE_MAC_ADDRESS]
    scan off
    ```

    Replace `[YOUR_DEVICE_MAC_ADDRESS]` with the actual MAC address of your smartphone.

3. **Set a Static IP (Optional)**: It might be helpful to set a static IP address on your smartphone for the Bluetooth network interface for a more reliable connection.

   To set a static IP address for your Bluetooth network interface on the Raspberry Pi, you can modify the dhclient.conf file. Here’s how to set a static IP address, for example, 192.168.44.42

   Open the dhclient configuration file:
   ```sudo nano /etc/dhcp/dhclient.conf```

   Add the following lines at the end of the file:
   ```
   interface "bnep0" {
    send host-name "raspberrypi";
    fixed-address 192.168.44.42;
    }
   ```
   
   Save and close the file. Restart the Bluetooth service or reboot your Raspberry Pi to apply the changes:
   ```sudo systemctl restart bluetooth.service```

### Configuring the Autoconnect Script

1. **Script Setup**: Place the following script in `/usr/local/bin/BT_NAP_autoconnect.sh`:

    Ensure to replace `[YOUR_DEVICE_MAC_ADDRESS]` with your device's actual MAC address in the script.

2. **Make the Script Executable**:
    ```bash
    sudo chmod +x /usr/local/bin/BT_NAP_autoconnect.sh
    ```

### Automating the Script

1. **Add to Cron**: To ensure the script runs at every system startup, add it to the `cron` job scheduler:

    ```bash
    sudo crontab -e
    ```

    Add the following line to the end of the file:
    ```
    @reboot sleep 15 && /usr/local/bin/BT_NAP_autoconnect.sh
    ```

    This line will delay the execution by 15 seconds after each reboot to ensure that all system services have started.

## Usage

Once everything is set up, your Raspberry Pi will attempt to automatically connect to your smartphone's NAP service on every system startup. If the connection is lost, restarting the Raspberry Pi will trigger the connection process again.

## Troubleshooting

If the connection fails to establish automatically, consider checking the following:
- Ensure the MAC address in the script matches that of your smartphone.
- Verify that Bluetooth tethering is enabled on your smartphone.
- Verify that the smartphone's Bluetooth is turned on and visible.
- Check the Raspberry Pi's Bluetooth service status using `systemctl status bluetooth`.

For more detailed logs, you can modify the script to include logging statements or run the commands manually to see any error messages.

