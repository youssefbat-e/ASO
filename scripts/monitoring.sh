#!/bin/bash
echo "Content-type: text/html"
echo
output=$(df -h)
outputCpu=$(uptime)

# HTML header

echo "<!DOCTYPE html>"
echo "<html lang="en">"
echo "<head>"
echo "    <meta charset="UTF-8">"
echo "    <meta name="viewport" content="width=device-width, initial-scale=1.0">"
echo "    <title>Login Result</title>"
echo "</head>"
echo "<body>"
echo "<p>DISK INFO</p>"
echo $output
echo "<p>CPU INFO</p>"
echo $outputCpu
echo "</body>"
echo "</html>"