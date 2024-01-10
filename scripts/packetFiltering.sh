#!/bin/bash

echo "Content-type: text/html"
echo

currentUser=$(cat usr_loggedIn)
sudo logger -t $currentUser "user filtering packets"
IFS='&'
read -r -d '' QUERY_STRING
echo "$QUERY_STRING"
iptables=$(sudo iptables -L -v -n --line-numbers)
# Check if the form is submitted
if [ -n "$QUERY_STRING" ]; then
    decoded_input=$(printf '%b' "${QUERY_STRING//%/\\x}")
# Use the read command to split the input string
    read -ra array <<< "$decoded_input"
    protocol="${array[0]:9}"
    echo "protocol: $protocol"
    source_ip="${array[1]:10}"
     echo "source ip: $source_ip"
    destination_ip="${array[2]:15}"
     echo "destination ip: $destination_ip"
    port="${array[3]:5}"
     echo "port: $port"
    number="${array[4]:7}"
     echo "number: $number"
    if [ -n "$protocol" ] && [ -n "$source_ip" ] && [ -n "$destination_ip" ] && [ -n "$port" ]; then
        sudo iptables -A INPUT -p "$protocol" --source "$source_ip" --destination "$destination_ip" --dport "$port" -j ACCEPT
        logger -t $currentUser "user added rule: $protocol $source_ip $destination_ip $port"
    elif  [ -n "$protocol" ] && [ -n "$source_ip" ] && [ -n "$destination_ip" ]; then
        sudo iptables -A INPUT -p "$protocol" --source "$source_ip" --destination "$destination_ip" -j ACCEPT
        logger -t $currentUser "user added rule: $protocol $source_ip $destination_ip"
    elif [ -n "$protocol" ] && [ -n "$source_ip" ]; then
        sudo iptables -A INPUT -p "$protocol" --source "$source_ip" -j ACCEPT
        logger -t $currentUser "user added rule: $protocol $source_ip"
    elif [ -n "$protocol" ]; then 
        sudo iptables -A INPUT -p "$protocol" -j ACCEPT
        logger -t $currentUser "user added rule: $protocol"
    fi
    if [ -n "$number" ]; then 
        logger -t $currentUser "user deleted packet rule number: $number"
        sudo iptables -D INPUT $number
    fi
    iptables=$(sudo iptables -L -v -n --line-numbers) 
fi

# HTML header
echo "<!DOCTYPE html>"
echo "<html lang=\"en\">"

echo "<head>"
echo "    <meta charset=\"UTF-8\">"
echo "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
echo "    <title>Packet Filtering</title>"
echo "</head>"
echo "<body>"
echo "<h2>Current Firewall Rules</h2>"
echo "<pre>$iptables</pre>"
# Display form to add a new firewall rule
echo "<h2>Add Firewall Rule</h2>"
echo "<form method=\"post\" action=\"/scripts/packetFiltering.sh\">"
echo "  <label for=\"protocol\">Protocol:</label>"
echo "  <input type=\"text\" id=\"protocol\" name=\"protocol\" placeholder=\"tcp/udp\" ><br>"
echo "  <label for=\"source_ip\">Source IP:</label>"
echo "  <input type=\"text\" id=\"source_ip\" name=\"source_ip\" placeholder=\"Optional\"><br>"
echo "  <label for=\"destination_ip\">Destination IP:</label>"
echo "  <input type=\"text\" id=\"destination_ip\" name=\"destination_ip\" placeholder=\"Optional\"><br>"
echo "  <label for=\"port\">Port:</label>"
echo "  <input type=\"text\" id=\"port\" name=\"port\" placeholder=\"Optional\"><br>"
echo "  <br>"
echo "  <input type=\"submit\" value=\"Add Rule\">"
echo "<h2>Delete Firewall Rule</h2>"
echo "  <label for=\"number\">Number:</label>"
echo "  <input type=\"text\" id=\"number\" name=\"number\" placeholder=\"rule num\" ><br>"
echo "  <br>"
echo "  <input type=\"submit\" value=\"Delete Rule\">"
echo "</form>"
echo "<br></br>"
echo "<a href=\"/scripts/mainMenu.sh\">Back</a></li>"
echo "</body>"
echo "</html>"
