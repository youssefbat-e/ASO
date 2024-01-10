#!/bin/bash

echo "Content-type: text/html"
echo

currentUser=$(cat usr_loggedIn)
sudo logger -t $currentUser "user managing users"

systemUsernames=$(awk -F: '{ print $1 }' /etc/passwd)
IFS=$'\n' read -d '' -ra systemUsernamesArray < <(awk -F: '{ print $1 }' /etc/passwd)
IFS='&'
read -r -d ' ' USER_INPUT
# Use functions as needed

    if [ -n "$USER_INPUT" ]; then
        decoded_input=$(printf '%b' "${USER_INPUT//%/\\x}")
        read -ra array <<< "$decoded_input"
        username="${array[0]:9}"
        password="${array[1]:9}"
        userdel="${array[2]:8}"
        if [ -n "$username" ] && [ -n "$password" ]; then
            user_valid=true
            for user in "${systemUsernamesArray[@]}"; do
                # Check if entered credentials are valid
                if [ "$username" == "$user" ]; then
                    echo "user $username already exists!"
                    user_valid=false;
                fi
            done
            if [ "$user_valid" = true ]; then
                sudo useradd $username
                sudo echo "$username:$password" > temp_file
                # Use chpasswd to update /etc/shadow
                sudo chpasswd -c SHA256 < temp_file
                rm temp_file
                systemUsernames=$(awk -F: '{ print $1 }' /etc/passwd)
            fi
        fi
        if [ -n "$userdel" ]; then
            if id "$userdel" &>/dev/null; then
                sudo userdel "$userdel"
                echo "User deleted successfully"
                systemUsernames=$(awk -F: '{ print $1 }' /etc/passwd)
            else
                echo "User $userdel does not exist."
            fi
        fi
    fi

# HTML header
echo "<!DOCTYPE html>"
echo "<html lang='en'>"
echo "<head>"
echo "    <meta charset='UTF-8'>"
echo "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>"
echo "    <title>Process Info</title>"
echo "</head>"
echo "<body>"
echo "<h1>USERS IN THE SYSTEM</h1>"
echo "<br>"
if [ -n "$systemUsernames" ]; then
    echo "<table>"
    echo "<pre>"
    echo "$systemUsernames"
    echo "</pre>"
    echo "</table>"
fi
echo "<br></br>"
echo "<p><b>Do you want to add a new user?</b></p>"
echo "<br>"
echo "<form action='/scripts/userManagement.sh' method='post'>"
echo "      <label for=\"username\">Username:</label>"
echo "      <input type=\"text\" id=\"username\" name=\"username\" placeholder=\"username\"><br>"
echo "      <label for=\"password\">Password:</label>"
echo "      <input type=\"password\" id=\"password\" name=\"password\" placeholder=\"password\"><br>"
echo "  <input type='submit' value='Add User' /></br>"
echo "<p><b>Do you want to delete a user?</b></p>"
echo "      <label for=\"userdel\">Enter its username:</label>"
echo "      <input type=\"text\" id=\"userdel\" name=\"userdel\" placeholder=\"username\"><br>"
echo "  <input type='submit' value='Delete User' /></br>"
echo "</form>"
echo "<a href=\"/scripts/mainMenu.sh\">Back</a>"
echo "</body>"
echo "</html>"