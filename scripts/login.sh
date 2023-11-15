#!/bin/bash

echo "Content-Type: text/html"
echo ""

# HTML header
cat <<EOL
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Result</title>
</head>
<body>
EOL

read -p "Enter username: " username
read -s -p "Enter password: " password

if [ "$username" == "youssef" ] && [ "$password" == "admin" ]; then
    echo "<p>Login successful!</p>"
else
    echo "<p>Login failed. Invalid username or password.</p>"
fi

cat <<EOL
</body>
</html>
EOL
