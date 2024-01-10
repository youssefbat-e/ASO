#!/bin/bash

echo "Content-type: text/html"
echo

currentUser=$(cat usr_loggedIn)
sudo logger -t $currentUser "user restaring system"

/etc/init.d/httpd restart

echo "<!DOCTYPE html>"
echo "<html lang=\"en\">"
echo "<head>"
echo "    <meta charset=\"UTF-8\">"
echo "    <meta http-equiv=\"refresh\" content=\"0;url=http://192.168.21.10/scripts/index.sh\">"
echo "    <title>Redirecting...</title>"
echo "</head>"
echo "<body>"
echo "    <p>If you are not redirected, <a href=\"/scripts/index.sh\">click here</a>.</p>"
echo "</body>"
echo "</html>"

