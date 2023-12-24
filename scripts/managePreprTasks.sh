#!/bin/bash

echo "Content-type: text/html"
echo
IFS='&'
read -r -d ' ' USER_INPUT

currentUser=$(whoami)

preprTasksFilesHourly=$(ls /etc/cron.hourly)
preprTasksFilesDaily=$(ls /etc/cron.daily)
preprTasksFilesWeekly=$(ls /etc/cron.weekly)
preprTasksFilesMonthly=$(ls /etc/cron.monthly)

if [ -n "$USER_INPUT" ]; then
    decoded_input=$(printf '%b' "${USER_INPUT//%/\\x}")
# Use the read command to split the input string
    read -ra array <<< "$decoded_input"
    name="${array[0]:5}"
    frequency="${array[1]:9}"
    echo "$frequency"
    path="${array[2]:5}"
    IFS=' '
    read -ra my_frequency <<< "$frequency"
    echo "$my_frequency[0]"

    if [ -n "$my_frequency[1]" ]; then
        if [ -n "$path" ]; then
            if [ "$my_frequency[1]" == "sec" ]; then
                cd /etc/cron.hourly
                touch $name
                echo "#!/bin/bash while true; do $path sleep $my_frequency[0] done" >> $name
            fi
            if [ "$my_frequency[1]" == "min" ]; then
            fi
            if [ "$my_frequency[1]" == "h" ]; then
            fi
            if [ "$my_frequency[1]" == "day" ]; then
            fi
            if [ "$my_frequency[1]" == "week" ]; then
            fi
            if [ "$my_frequency[1]" == "month" ]; then
            fi
        fi
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
echo "      <label for=\"name\">Name your task:</label>"
echo "      <input type=\"text\" id=\"name\" name=\"name\" placeholder=\"name\"><br>"
echo "      <label for=\"frequency\">Every:</label>"
echo "      <input type=\"text\" id=\"frequency\" name=\"frequency\" placeholder=\"x min/sec/h/day/week/month\"><br>"
echo "      <label for=\"path\">Path to task:</label>"
echo "      <input type=\"text\" id=\"path\" name=\"path\" placeholder=\"path to task\"><br>"
echo "      <br>"
echo "  <input type='submit' value='Add Task' />"
echo "</form>"
echo "<br></br>"
if [ -n "$preprTasksFilesHourly" || -n "$preprTasksFilesDaily" || -n "$preprTasksFilesWeekly" || -n "$preprTasksFilesMonthly"]; then
    echo "<table>"
    echo "<pre>"
    echo "$preprTasksFilesHourly"
    echo "$preprTasksFilesDaily"
    echo "$preprTasksFilesWeekly"
    echo "$preprTasksFilesMonthly"
    echo "</pre>"
    echo "</table>"
fi
echo "<br></br>"
echo "<a href=\"/scripts/mainMenu.sh\">Back</a></li>"
echo "</body>"
echo "</html>"