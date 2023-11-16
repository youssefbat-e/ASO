#!/bin/bash

log_file="/var/log/user_operations.log"

filter_text=$(echo "$QUERY_STRING" | sed -n 's/^.*filter_text=\([^&]*\).*$/\1/p' | sed "s/%20/ /g")
if [ -n "$filter_text" ]; then
    grep "$filter_text" "$log_file"
else
    cat "$log_file"
fi
