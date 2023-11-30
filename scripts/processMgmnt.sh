#!/bin/bash

echo "Content-type: text/html"
echo
read -p "Enter PID: " pid
pidCorrect="${pid:4}"
outputPs=$(ps -aux)
header=$(echo "$outputPs" | head -n 1)
outputPs=$(echo "$outputPs" | tail -n +2)

if [ -n "$pidCorrect" ]; then
    outputFinal=$(echo "$outputPs" | grep "[ ]$pidCorrect ")
    outputPs=$outputFinal
fi

if [ -n "$statusCorrect" ]; then
    outputFinal=$(echo "$outputPs" | awk -v status="$statusCorrect" '$10 == status')
    outputPs=$outputFinal
fi
# HTML header
echo "<!DOCTYPE html>"
echo "<html lang='en'>"
echo "<head>"
echo "    <meta charset='UTF-8'>"
echo "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>"
echo "    <title>Process Info</title>"
echo "</head>"
echo "<br></br>"
echo "<form action="/scripts/processMgmnt.sh" method="post">"
echo "      PID: <input type="text" name="pid" /></br />"
echo "      <input type="submit" value="Search" />"
echo "</form>"
echo "<br></br>"
function PrintTable {
    echo "<table border='1'>"
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

echo "<body>"
echo "<h1>PROCESSES INFO</h1>"
if [ -n "$outputPs" ]; then
echo "<table border='1'>"
PrintTable
echo "</table>"
fi
echo "</body>"
echo "</html>"