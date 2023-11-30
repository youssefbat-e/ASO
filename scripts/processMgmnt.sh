#!/bin/bash

echo "Content-type: text/html"
echo
IFS='&'
read -r -d ' ' USER_INPUT
echo "user input: $USER_INPUT"
outputPs=$(ps -aux)
header=$(echo "$outputPs" | head -n 1)
outputPs=$(echo "$outputPs" | tail -n +2)

if [ -n "$USER_INPUT" ]; then
# Use the read command to split the input string
    read -ra array <<< "$USER_INPUT"
    pid="${array[0]:4}"
    status="${array[1]:7}"
    echo "pid: $pid status: $status"
    outputFinal=$(echo "$outputPs" | grep "[ ]$pid")
    outputPs=$outputFinal
fi

PrintTable() {
    echo "<table>"
    echo "<tr>"
    for ((j = 1; j <= 11; j++)); do
        column=$(echo "$header" | awk -v col=$j '{print $col}')
        echo "<td>$column</td>"
    done
    echo "</tr>"
    while read -r line; do
        echo "<tr>"
        for ((i = 1; i <= 11; i++)); do
            column=$(echo "$line" | awk -v col=$i '{print $col}')
            echo "<td>$column</td>"
        done
        echo "</tr>"
    done <<< "$outputPs"
    echo "</table>"
}

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
echo "<br></br>"
echo "<form action='/scripts/processMgmnt.sh' method='post'>"
echo "      <label for=\"pid\">PID:</label>"
echo "      <input type=\"text\" id=\"pid\" name=\"pid\" placeholder=\"pid\" required><br>"
echo "      <label for=\"status\">Status:</label>"
echo "      <input type=\"text\" id=\"status\" name=\"status\" placeholder=\"Optional\"><br>"
echo "  <input type='submit' value='Search' />"
echo "</form>"
echo "<br></br>"
if [ -n "$outputPs" ]; then
    echo "<table border='1'>"
    PrintTable
    echo "</table>"
fi
echo "</body>"
echo "</html>"