#!/bin/bash

echo "Content-type: text/html"
echo

#get server resources (CPU, memory, disk)
get_server_resources() {
    echo "<h2>Server Resources</h2>"
    echo "<h3>CPU Information</h3>"
    echo "<pre>$(uptime)</pre>"
    echo "<h3>Memory Information</h3>"
    echo "<pre>$(free -m)</pre>"
    echo "<h3>Disk Information</h3>"
    echo "<pre>$(df -h)</pre>"
}

#get last 10 accesses
get_last_accesses() {
    echo "<h2>Last 10 Accesses</h2>"
    last -n 10
}

#get server uptime
get_server_uptime() {
    echo "<h2>Server Uptime</h2>"
    uptime
}

# HTML header
echo "<!DOCTYPE html>"
echo "<html lang=\"en\">"
echo "<head>"
echo "    <meta charset=\"UTF-8\">"
echo "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
echo "    <title>Monitoring</title>"
echo "</head>"
echo "<body>"
get_server_resources
get_last_accesses
get_server_uptime
get_additional_info
echo "<br></br>"
echo "<a href=\"/scripts/mainMenu.sh\">Back</a></li>"
echo "</body>"
echo "</html>"
