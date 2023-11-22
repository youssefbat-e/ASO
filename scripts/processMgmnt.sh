#!/bin/bash

parsePSAux() {
    local filterPID="$1"  
    local filterStatus="$2"
    local interrupt=false
    local timeInterrupt=0 
    
    outputPS=$(ps aux)

    if ( filterPID != null ) then
        outputPS=$(echo $outputPS | grep $filterPID) 
    end
    if ( filterPID != null ) then
        outputPS_PID=$(echo $outputPS | grep $filterPID) 
    end

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
