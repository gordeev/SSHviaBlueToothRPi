# SSH via BlueTooth Android + Raspberry Pi
Get access to your RPi from Android via BT
tested on RPi zero 2 W

1) pair devices via blueman-manager or bluetoothctl
2) add smartphone as trusted device
3) put this script to the /usr/local/bin/BT_NAP_autoconnect.sh
4) make executable - ```sudo chmod +x /usr/local/bin/BT_NAP_autoconnect.sh```
5) open crontab as sudo - ```sudo crontab -e```
6) add task to run this script in 20 seconds after system start - ```@reboot sleep 20 && /usr/local/bin/BT_NAP_autoconnect.sh```
7) on your phone turn on tethering via Bluetooth
8) restert raspberry pi and wait
9) connect via ssh to your rpi
