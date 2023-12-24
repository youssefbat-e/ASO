#!/bin/bash

echo "Content-type: text/html"
echo

/etc/init.d/httpd stop

echo "<!DOCTYPE html>"
echo "<html lang=\"en\">"
echo "<head>"
echo "      <meta charset=\"UTF-8\">"
echo "      <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
echo "      <title>Stop</title>"
echo "</head>"
echo "<body>"
echo "  <h3>Click to restart the server</h3>"
echo "  <form method=\"post\" action=\"/scripts/restart.sh\">"
echo "      <input type=\"submit\" value=\"Restart\">"
echo "  </form>"
echo "</body>"
echo "</html>"
