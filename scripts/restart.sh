#!/bin/bash

/etc/init.d/httpd restart

echo "Content-type: text/html"
echo

echo "<!DOCTYPE html>"
echo "<html lang=\"en\">"
echo "<head>"
echo "    <meta charset=\"UTF-8\">"
echo "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
echo "    <title>Restarting System</title>"
echo "</head>"
echo "<body>"
echo " <p>System Restarted</p>"
echo "</body>"
echo "</html>"