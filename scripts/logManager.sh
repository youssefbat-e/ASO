#!/bin/bash

log_operation() {
    operation="$1"
    logger -t "WebApp" "$operation"
}

display_logs() {
    filter="$1"
    
    if [ -n "$filter" ]; then
        grep "$filter" /var/log/syslog
    else
        cat /var/log/syslog
    fi
}

read -r -d '' QUERY_STRING

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

if [ -n "$QUERY_STRING" ]; then
    # Log the operation
    log_operation "User performed operation: $QUERY_STRING"
    echo "<p>Operation logged successfully.</p>"
fi

echo "<h2>Display Logs</h2>"
echo "<form method=\"get\" action=\"/scripts/logManager.sh\">"
echo "  <label for=\"filter\">Filter (optional):</label>"
echo "  <input type=\"text\" id=\"filter\" name=\"filter\">"
echo "  <input type=\"submit\" value=\"Display Logs\">"
echo "</form>"

filter_criteria=$(echo "$QUERY_STRING" | grep -oP '\K.*')
display_logs "$filter_criteria"

echo "</body>"
echo "</html>"
