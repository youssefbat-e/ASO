#!/bin/bash

echo "Content-type: text/html"
echo

check_credentials() {
    IFS=$'\n' read -d '' -ra systemUsernames < <(awk -F: '{ print $1 }' /etc/passwd)
    valid_user=false
    login_correct=false

    for user in "${systemUsernames[@]}"; do
        # Check if entered credentials are valid
        if [ "$username" == "$user" ]; then
            valid_user=true
            break
        fi
    done

    if [ "$valid_user" = true ]; then
        stored_password=$(sudo getent shadow $username)
        IFS=':' read -ra passwdString <<< "$stored_password"
        stored_final="${passwdString[1]}" 
        # Hash the provided password using OpenSSL
        IFS='$' read -ra elements <<< "$stored_password"
        salt="${elements[2]}"
        #echo "stored: $stored_final"
        hashed_password=$(sudo openssl passwd -6 -salt $salt $password)
       # echo "hashed: $hashed_password"
        # Compare the stored password with the hashed provided password
        if [ "$stored_final" == "$hashed_password" ]; then
            login_correct=true;
            echo "correct!"
            username=""
            password=""
        else
            echo "Password is not correct. Try again :("
        fi
    else
        echo "User not found. Try again :("
    fi
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
echo "  <form method=\"post\" action=\"/scripts/logout.sh\">"
echo "      <input type=\"submit\" value=\"Logout\">"
echo "    </form>"
if [ "$login_correct" = true ]; then
    echo "<a href=\"/scripts/mainMenu.sh\">Go to Main Menu</a>"
fi
echo "  </body>"
echo "</html>"