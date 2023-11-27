#!/bin/bash

echo "Content-type: text/html"
echo
outputPs=$(ps -aux)

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
echo "<table border='1'>"

# Print table header
while read -r line; do
    echo "<tr>"
    for ((i = 1; i <= 11; i++)); do
        column=$(echo "$line" | awk -v col=$i '{print $col}')
        echo "<td>$column</td>"
    done
    echo "</tr>"
done <<< "$outputPs"
echo "</table>"
echo "</body>"
echo "</html>"