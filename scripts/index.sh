#!/bin/bash
echo "Content-type: text/html"
echo
read -p "Enter username: " username
read -s -p "Enter password: " password

if [ "$username" == "youssef" ] && [ "$password" == "admin" ]; then
    echo "<p>Login successful!</p>"
else
    echo "<p>Login failed :( </p>"
fi

# HTML header

echo "<!DOCTYPE html>"
echo "<html lang="en">"
echo "<head>"
echo "    <meta charset="UTF-8">"
echo "    <meta name="viewport" content="width=device-width, initial-scale=1.0">"
echo "    <title>Login</title>"
echo "</head>"
echo "<body>"
echo "  <h2>Login</h2>"
echo "  <form action="/scripts/index.sh" method="post">"
echo "      Username: <input type="text" name="username" required /></br />"
echo "      Password: <input type="password" name="password" required /></br />"
echo "      <input type="submit" value="Login" />"
echo "  </form>"
echo "</body>"
echo "</html>"