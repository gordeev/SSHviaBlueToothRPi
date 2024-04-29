#!/bin/bash
# Путь к утилите bluetoothctl
BLUETOOTHCTL="/usr/bin/bluetoothctl"

# MAC-адрес вашего смартфона
DEVICE_MAC="00:00:00:00:00:00"

# Проверяем, подключено ли устройство
if ! $BLUETOOTHCTL info $DEVICE_MAC | grep -q "Connected: yes"; then
    echo "Device is not connected, trying to connect..."
    $BLUETOOTHCTL connect $DEVICE_MAC
    sleep 5
fi

# Проверяем, подключено ли устройство после попытки
if $BLUETOOTHCTL info $DEVICE_MAC | grep -q "Connected: yes"; then
    echo "Device is connected. Proceeding with NAP service..."
    # Проверяем наличие сетевого интерфейса bnep0
    if ! ip link show bnep0 &>/dev/null; then
        echo "NAP service is not active. Trying to activate..."
        sudo bt-network -c $DEVICE_MAC nap
        sleep 5
    fi

    # Проверяем еще раз наличие интерфейса после попытки активации
    if ip link show bnep0 &>/dev/null; then
        # Проверяем наличие IP адреса
        if ! ip addr show bnep0 | grep -q "inet "; then
            echo "No IP address assigned to bnep0. Trying to obtain IP..."
            sudo dhclient bnep0
            sleep 5
        fi

        # Проверяем наличие IP адреса после попытки его получения
        if ip addr show bnep0 | grep -q "inet "; then
            echo "Good boy. Connection on bnep0 is active and IP is assigned."
        else
            echo "Failed to obtain IP address, even after retrying."
        fi
    else
        echo "Failed to activate NAP service, even after retrying."
    fi
else
    echo "Failed to connect the device, even after retrying."
fi
