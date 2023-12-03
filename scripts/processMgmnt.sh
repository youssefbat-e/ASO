#!/bin/bash

echo "Content-type: text/html"
echo
IFS='&'
read -r -d ' ' USER_INPUT
outputPs=$(ps -aux)
header=$(echo "$outputPs" | head -n 1)
outputPs=$(echo "$outputPs" | tail -n +2)

if [ -n "$USER_INPUT" ]; then
    decoded_input=$(printf '%b' "${USER_INPUT//%/\\x}")
# Use the read command to split the input string
    read -ra array <<< "$decoded_input"
    pid="${array[0]:4}"
    status="${array[1]:7}"
    seconds="${array[2]:8}"
    choice="${array[3]:7}"
    user="lfs"

    if [ -n "$pid" ]; then
        outputPs=$(echo "$outputPs" | awk -v pid="$pid" '$2 == pid')
        if [ -n "$seconds" ]; then
            kill -SIGSTOP "$pid"
            sleep $seconds
            kill -SIGCONT "$pid"
            outputPs=$(ps -aux | tail -n +2)
        fi
    fi
    
    if [ -n "$status" ]; then
        outputPs=$(echo "$outputPs" | awk -v status="$status" '$8 == status')
    fi

    if [ -n "$choice" ]; then
        if [ "$choice" == "yes" ]; then
            outputPs=$(echo "$outputPs" | grep -vE "^\s*$user\s")
        fi
    fi
fi

# HTML header
echo "<!DOCTYPE html>"
echo "<html lang='en'>"
echo "<head>"
echo "    <meta charset='UTF-8'>"
echo "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>"
echo "    <title>Process Info</title>"
echo "</head>"
echo "<body>"
echo "<h1>PROCESSES INFO</h1>"
echo "<br>"
echo "<h3>Filters to Apply</h3>"
echo "<form action='/scripts/processMgmnt.sh' method='post'>"
echo "      <label for=\"pid\">PID:</label>"
echo "      <input type=\"text\" id=\"pid\" name=\"pid\" placeholder=\"pid\"><br>"
echo "      <label for=\"status\">Status:</label>"
echo "      <input type=\"text\" id=\"status\" name=\"status\" placeholder=\"status\"><br>"
echo "      <label for=\"seconds\">Seconds to stop:</label>"
echo "      <input type=\"text\" id=\"seconds\" name=\"seconds\" placeholder=\"Seconds\"><br>"
echo "      <br>"
echo "      <h3>Remove all my Processes?</h3>"
echo "      <label for=\"choice_yes\">YES</label>"
echo "      <input type="checkbox" id="choice_yes" name="choice" value="yes">"
echo "      <label for=\"choice_no\">NO</label>"
echo "      <input type="checkbox" id="choice_no" name="choice" value="no">"
echo "      <br>"
echo "  <input type='submit' value='Apply' />"
echo "</form>"
echo "<br></br>"
if [ -n "$outputPs" ]; then
    echo "<table>"
    echo "<pre>"
    echo "$header"
    echo "$outputPs"
    echo "</pre>"
    echo "</table>"
fi
echo "</body>"
echo "</html>"