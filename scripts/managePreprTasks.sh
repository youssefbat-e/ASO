#!/bin/bash

echo "Content-type: text/html"
echo

currentUser=$(cat temp_file)
preprTasks=$(fcrontab -l)

IFS='&'
read -r -d ' ' USER_INPUT

if [ -n "$USER_INPUT" ]; then
    decoded_input=$(printf '%b' "${USER_INPUT//%/\\x}")
    cleaned_input=$(echo "$decoded_input" | tr '+' ' ')
    read -ra array <<< "$cleaned_input"
    frequency="${array[0]:10}"
    command="${array[1]:8}"
    numLine="${array[2]:8}"
    
    # Validate and sanitize user input before appending to the file
    if [ -n "$frequency" ] && [ -n "$command" ]; then
        lineToWrite="$frequency  $command"
        (fcrontab -l; echo "$lineToWrite") | fcrontab -
        preprTasks=$(fcrontab -l)
    fi
    if [ -n "$numLine" ]; then
        (echo "$preprTasks" | sed -e "${numLine}d") | fcrontab -
        preprTasks=$(fcrontab -l)
    fi
fi

# HTML header
echo "<!DOCTYPE html>"
echo "<html lang='en'>"
echo "<head>"
echo "    <meta charset='UTF-8'>"
echo "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>"
echo "    <title>Preprogrammed tasks</title>"
echo "</head>"
echo "<body>"
echo "<h1>PREPROGRAMMED TASKS INFO</h1>"
echo "<br>"
echo "<h3>Add a task</h3>"
echo "<form action='/scripts/managePreprTasks.sh' method='post'>"
echo "      <label for=\"frequency\">Frequency:</label>"
echo "      <input type=\"text\" id=\"frequency\" name=\"frequency\" placeholder=\"enter frequency in format * * * * *\"><br>"
echo "      <label for=\"command\">Task to schedule:</label>"
echo "      <input type=\"text\" id=\"command\" name=\"command\" placeholder=\"task\"><br>"
echo "      <br>"
echo "  <input type='submit' value='Add Task' />"
echo "<h3>Delete a task</h3>"
echo "<form action='/scripts/managePreprTasks.sh' method='post'>"
echo "      <label for=\"numLine\">Number of line to delete:</label>"
echo "      <input type=\"text\" id=\"numLine\" name=\"numLine\" placeholder=\"line number\"><br>"
echo "      <br>"
echo "  <input type='submit' value='Delete Task' />"
echo "</form>"
echo "<br></br>"
echo "<pre>$preprTasks</pre>"
echo "<br></br>"
echo "<a href=\"/scripts/mainMenu.sh\">Back</a></li>"
echo "</body>"
echo "</html>"