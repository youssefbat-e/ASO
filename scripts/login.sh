#!/bin/bash

validate_credentials() {
    local input_username="$1"
    local input_password="$2"
    local valid_username="admin"  
    local valid_password="admin"  

    if [ "$input_username" = "$valid_username" ] && [ "$input_password" = "$valid_password" ]; then
        return 0  
    else
        return 1  
    fi
}

read -r input
IFS='&' read -ra params <<< "$input"

input_username=$(echo "${params[0]}" | sed 's/username=//')
input_password=$(echo "${params[1]}" | sed 's/password=//')

if validate_credentials "$input_username" "$input_password"; then
    echo "Content-type: text/html"
    echo ""
    echo "<html><head><title>Login Success</title></head><body>"
    echo "<h2>Login Successful</h2>"
    echo "<p>Welcome, $input_username!</p>"
    echo "</body></html>"
else
    echo "Content-type: text/html"
    echo ""
    echo "<html><head><title>Login Failed</title></head><body>"
    echo "<h2>Login Failed</h2>"
    echo "<p>Invalid username or password.</p>"
    echo "</body></html>"
fi
