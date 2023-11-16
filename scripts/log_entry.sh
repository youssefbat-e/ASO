#!/bin/bash

log_entry=$(echo "$QUERY_STRING" | sed -n 's/^.*log_entry=\([^&]*\).*$/\1/p' | sed "s/%20/ /g")

log_file="/var/log/user_operations.log"

echo "$(date +"%Y-%m-%d %H:%M:%S") - $log_entry" >> "$log_file"

echo "Location: /src/logsManagement.html"
echo ""
