#!/bin/bash

echo "Content-type: text/html"
echo

check_credentials() {
    # Replace the following with your actual username and password
    passwdFile=$(cat /etc/passwd | cut -d: -f1) 
    IFS=' ' read -ra usernames <<< "$passwdFile"

    for user in "${usernames[@]}"; do
        # Check if entered credentials are valid
        if [ "$username" == "$user" ]; then
            if echo "$password" | passwd --stdin "$username" >/dev/null 2>&1; then
                echo "Hello $username!"
            else
                echo "User or password incorrect. Try again :("
            fi
        fi
    done
}
# Parse the form data
IFS='&'
read -r -d ' ' QUERY_STRING
if [ -n "$QUERY_STRING" ]; then
    decoded_input=$(printf '%b' "${QUERY_STRING//%/\\x}")
    # Use the read command to split the input string
    read -ra array <<< "$decoded_input"
    username="${array[0]:9}"
    password="${array[1]:9}"
    check_credentials
fi

# Output HTML content

echo "<!DOCTYPE html>"
echo "<html lang=\"en\">"
echo "  <head>"
echo "    <meta charset=\"UTF-8\">"
echo "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
echo "    <title>Login</title>"
echo "  </head>"
echo "  <body>"
echo "    <h1>WELCOME TO LFS!</h1>"
echo "    <h2>Login</h2>"
echo "    <form method=\"post\" action=\"/scripts/index.sh\">"
echo "      <label for=\"username\">Username:</label>"
echo "      <input type=\"text\" id=\"username\" name=\"username\" placeholder=\"username\" required><br>"
echo "      <label for=\"password\">Password:</label>"
echo "      <input type=\"password\" id=\"password\" name=\"password\" placeholder=\"password\" required><br>"
echo "      <br>"
echo "      <input type=\"submit\" value=\"Login\">"
echo "    </form>"
echo "  </body>"
echo "</html>"