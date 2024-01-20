#!/bin/bash

echo "Choose max CPU % performance:"
echo "1. Default"
echo "2. 90%"
echo "3. 80%"
echo "4. 70%"
echo "5. 60%"
echo "6. 50%"
echo "7. 40%"
echo "8. 30%"

read -p "Enter your choice: " choice

case $choice in
    1) setting="100" ;;
    2) setting="90" ;;
    3) setting="80" ;;
    4) setting="70" ;;
    5) setting="60" ;;
    6) setting="50" ;;
    7) setting="40" ;;
    8) setting="30" ;;
    *) exit 1 ;;
esac

if [ ! -f /etc/rc.local ]; then
    sudo touch /etc/rc.local
    sudo chmod +x /etc/rc.local
fi

previous_setting=$(grep -oP "(?<=echo \")[0-9]+(?=\" > /sys/devices/system/cpu/intel_pstate/max_perf_pct)" /etc/rc.local)

if grep -q "echo \"$setting\" > /sys/devices/system/cpu/intel_pstate/max_perf_pct" /etc/rc.local; then
    echo "Setting already exists"
else
    sudo bash -c "echo -e \"#!/bin/bash\necho \\\"$setting\\\" > /sys/devices/system/cpu/intel_pstate/max_perf_pct\nexit 0\" > /etc/rc.local"
    sudo chmod +x /etc/rc.local

    read -p "Restart to Apply? (y/n): " confirm
    if [ "$confirm" == "y" ]; then
        echo -e "\nRebooting the system..."
        sudo reboot
    else
        sudo bash -c "echo -e \"#!/bin/bash\necho \\\"$previous_setting\\\" > /sys/devices/system/cpu/intel_pstate/max_perf_pct\nexit 0\" > /etc/rc.local"
        echo "Canceled."
    fi
fi
