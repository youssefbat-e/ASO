#!/bin/bash

currentUser=$(cat usr_loggedIn)
sudo logger -t $currentUser "user managing logs"

display_logs() {
    filter="$1"
    echo "<h4>Logs Info</h4>"
    echo "<pre>"

    if [ -n "$filter" ]; then
        grep "$filter" /var/log/sys.log
    else
        #cat /var/log/sys.log
        outputPs=$(cat "/var/log/sys.log" | tail -n +2)
        echo "$outputPs"
    fi

    echo "</pre>"
}


read -r -d ' ' filter
operation="${filter:7}"
# HTML header
echo "Content-type: text/html"
echo

echo "<!DOCTYPE html>"
echo "<html lang=\"en\">"
echo "<head>"
echo "    <meta charset=\"UTF-8\">"
echo "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
echo "    <title>Managing Logs</title>"
echo "</head>"
echo "<body>"

if [ -n "$operation" ]; then
    logger -t $currentUser "user applied filter: $operation"
    echo "<p>Operation logged successfully.</p>"
fi

echo "<h2>Display Logs</h2>"
echo "<form method=\"post\" action=\"/scripts/logManager.sh\">"
echo "  <label for=\"filter\">Filter (optional):</label>"
echo "  <input type=\"text\" id=\"filter\" name=\"filter\">"
echo "  <input type=\"submit\" value=\"Display Logs\">"
echo "</form>"
echo "<br>"

#filter_criteria=$(echo "$QUERY_STRING" | grep -o 'filter=\K.*')
echo "<h3>Do you want to backup your logs?"
echo "<form method=\"post\" action=\"/scripts/backupLogs.sh\">"
echo "  <input type=\"submit\" value=\"Backup Logs\">"
echo "</form>"
echo "<br>"
echo "<a href=\"/scripts/mainMenu.sh\">Back</a>"
display_logs "$operation"
echo "</body>"
echo "</html>"
