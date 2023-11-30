#!/bin/bash

echo "Content-type: text/html"
echo
read -p "Enter PID: " pid
pidCorrect="${pid:4}"
read -p "Enter STATUS: " status
outputPs=$(ps -aux)
header=$(echo "$outputPs" | head -n 1)
outputPs=$(echo "$outputPs" | tail -n +2)

if [ -n "$pidCorrect" ]; then
    outputFinal=$(echo "$outputPs" | grep "[ ]$pidCorrect ")
    outputPs=$outputFinal
fi

if [ -n "$statusCorrect" ]; then
    outputFinal=$(echo "$outputPs" | grep "[ ]$statusCorrect ")
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
echo "<form action="/scripts/processMgmnt.sh" method="post">"
echo "      PID: <input type="text" name="pid" /></br />"
echo "      STATUS: <input type="text" name="status" /></br />"
echo "      <input type="submit" value="Search" />"
echo "</form>"
echo "<br></br>"
if [ -n "$outputPs" ]; then
echo "<table border='1'>"
PrintTable
echo "</table>"
fi
echo "</body>"
echo "</html>"