#!/bin/bash

display_firewall_rules() {
    echo "<h2>Current Firewall Rules</h2>"
    echo "<pre>"
    iptables -L
    echo "</pre>"
}


add_firewall_rule() {
    if [ -n "$QUERY_STRING" ]; then
        IFS='&' read -ra params <<< "$QUERY_STRING"

        protocol=""
        source_ip=""
        destination_ip=""
        port=""

        for param in "${params[@]}"; do
            IFS='=' read -r key value <<< "$param"

            case "$key" in
                "protocol")
                    protocol="$value"
                    ;;
                "source_ip")
                    source_ip="$value"
                    ;;
                "destination_ip")
                    destination_ip="$value"
                    ;;
                "port")
                    port="$value"
                    ;;
            esac
        done

        iptables -A INPUT -p "$protocol" --source "$source_ip" --destination "$destination_ip" --dport "$port" -j ACCEPT

        echo "<p>Firewall rule added successfully:</p>"
        echo "<pre>Protocol: $protocol, Source IP: $source_ip, Destination IP: $destination_ip, Port: $port</pre>"
    fi
}

read -r -d ' ' QUERY_STRING

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

if [ -n "$QUERY_STRING" ]; then
    add_firewall_rule "$protocol" "$source_ip" "$destination_ip" "$port"
fi

display_firewall_rules

echo "<h2>Add Firewall Rule</h2>"
echo "<form method=\"post\" action=\"/cgi-bin/packetFiltering.sh\">"
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

