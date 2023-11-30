#!/bin/bash

log_operation() {
    operation="$1"
    logger -t "$operation"
}

display_logs() {
    filter="$1"

    echo $filter
    echo "<h2>Display Logs</h2>"
    echo "<pre>"

    if [ -n "$filter" ]; then
        grep "$filter" /var/log/sys.log
    else
        cat /var/log/sys.log
    fi

    echo "</pre>"
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


log_operation "User performed operation: $QUERY_STRING"
echo "<p>Operation logged successfully.</p>"

# Debug: Display the QUERY_STRING
echo "<p>Debug: QUERY_STRING = $QUERY_STRING</p>"

echo "<h2>Display Logs</h2>"
echo "<form method=\"get\" action=\"/scripts/logManager.sh\">"
echo "  <label for=\"filter\">Filter (optional):</label>"
echo "  <input type=\"text\" id=\"filter\" name=\"filter\">"
echo "  <input type=\"submit\" value=\"Display Logs\">"
echo "</form>"

filter_criteria=$(echo "$QUERY_STRING" | grep -o 'filter=\K.*')
display_logs "$filter_criteria"

echo "</body>"
echo "</html>"
