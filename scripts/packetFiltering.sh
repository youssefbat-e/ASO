#!/bin/bash

#display current firewall rules
display_firewall_rules() {
    echo "<h2>Current Firewall Rules</h2>"
    iptables -L -n -v --line-numbers
}

# add a new firewall rule
add_firewall_rule() {
    protocol="$1"
    source_ip="$2"
    destination_ip="$3"
    port="$4"

    # Add rule creation logic using iptables
    iptables -A INPUT -p "$protocol" --source "$source_ip" --destination "$destination_ip" --dport "$port" -j ACCEPT

    echo "<p>Firewall rule added successfully:</p>"
    echo "<pre>Protocol: $protocol, Source IP: $source_ip, Destination IP: $destination_ip, Port: $port</pre>"
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
echo "    <title>Packet Filtering</title>"
echo "</head>"
echo "<body>"

# Check if the form is submitted
if [ -n "$QUERY_STRING" ]; then
    # Extract form data
    protocol=$(echo "$QUERY_STRING" | grep -oP 'protocol=\K[^&]*')
    source_ip=$(echo "$QUERY_STRING" | grep -oP 'source_ip=\K[^&]*')
    destination_ip=$(echo "$QUERY_STRING" | grep -oP 'destination_ip=\K[^&]*')
    port=$(echo "$QUERY_STRING" | grep -oP 'port=\K.*')

    # Add a new firewall rule
    add_firewall_rule "$protocol" "$source_ip" "$destination_ip" "$port"
fi

# Display current firewall rules
display_firewall_rules

# Display form to add a new firewall rule
echo "<h2>Add Firewall Rule</h2>"
echo "<form method=\"get\" action=\"/scripts/packetFiltering.sh\">"
echo "  <label for=\"protocol\">Protocol:</label>"
echo "  <input type=\"text\" id=\"protocol\" name=\"protocol\" placeholder=\"tcp/udp\" required><br>"
echo "  <label for=\"source_ip\">Source IP:</label>"
echo "  <input type=\"text\" id=\"source_ip\" name=\"source_ip\" placeholder=\"Optional\"><br>"
echo "  <label for=\"destination_ip\">Destination IP:</label>"
echo "  <input type=\"text\" id=\"destination_ip\" name=\"destination_ip\" placeholder=\"Optional\"><br>"
echo "  <label for=\"port\">Port:</label>"
echo "  <input type=\"text\" id=\"port\" name=\"port\" placeholder=\"Optional\"><br>"
echo "  <input type=\"submit\" value=\"Add Rule\">"
echo "</form>"

echo "</body>"
echo "</html>"
