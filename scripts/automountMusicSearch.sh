#!/bin/bash

echo "Content-type: text/html"
echo

mount_device() {
    sudo mkdir -p /mnt/$folder
    sudo mount /dev/$check_device /mnt/$folder
    cd /mnt/$folder
}

IFS='&'
read -r -d ' ' USER_INPUT

if [ -n "$USER_INPUT" ]; then
    decoded_input=$(printf '%b' "${USER_INPUT//%/\\x}")
    # Use the read command to split the input string
    read -ra array <<< "$decoded_input"
    folder="${array[0]:7}"
    choice="${array[1]:7}"

    if [ -n "$folder" ]; then
        check_device=$(sudo lsblk -o NAME,SIZE,TYPE | grep "sd[b-z]" | awk '$3 == "part" {print $1}' | head -n 1)
        check_device="${check_device:2}"
        echo "Check Device: $check_device"
        if [ -n "$check_device" ]; then
            echo "Device being mounted"
            mount_device
            sudo find /mnt/$folder -type f -iname "*.mp3" -o -iname "*.flac" > /mnt/$folder/song_list.txt
            musicContents=$(cat /mnt/$folder/song_list.txt)
        else
            echo "Device not detected."
        fi
    fi

    if [ -n "$choice" ]; then
        if [ "$choice" == "yes" ]; then
            echo "Device being unmounted"
            sudo umount /dev/$check_device
            sudo eject /dev/$check_device
            sudo rm -Rf /mnt/$folder
        else
            echo "Not taken off"
        fi
    fi
fi

# HTML header
echo "<!DOCTYPE html>"
echo "<html lang='en'>"
echo "<head>"
echo "    <meta charset='UTF-8'>"
echo "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>"
echo "    <title>Mounting</title>"
echo "</head>"
echo "<body>"
echo "<h1>MOUNTING DEVICE</h1>"
echo "<br>"
echo "<form action='/scripts/automountMusicSearch.sh' method='post'>"
echo "      <label for=\"folder\">Folder where you want to mount your drive:</label>"
echo "      <input type=\"text\" id=\"folder\" name=\"folder\" placeholder=\"Folder\"><br>"
echo "      <br>"
echo "      <h5>Do you want to take out your device?</h5>"
echo "      <label for=\"choice_yes\">YES</label>"
echo "      <input type='radio' id='choice_yes' name='choice' value='yes'>"
echo "      <label for=\"choice_no\">NO</label>"
echo "      <input type='radio' id='choice_no' name='choice' value='no'>"
echo "      <br>"
echo "  <input type='submit' value='Apply/Delete' />"
echo "</form>"
echo "<br></br>"
echo "<h6>Music File Contents: </h6>"
if [ -n "$musicContents" ]; then
    echo "<pre>$musicContents</pre>"
fi
echo "<br></br>"
echo "<a href=\"/scripts/mainMenu.sh\">Back</a></li>"
echo "</body>"
echo "</html>"