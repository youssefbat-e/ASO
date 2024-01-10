#!/bin/bash

# Create a timestamp for the backup folder
currentUser=$(cat usr_loggedIn)
sudo logger -t $currentUser "user backed up logs"
timestamp=$(date +"%Y%m%d%H%M%S")
backup_folder="/var/logBackups/backup_$timestamp"

# Create the backup folder
sudo mkdir -p "$backup_folder"

# Copy log files to the backup folder
sudo cp /var/log/*.log "$backup_folder"


echo "Content-type: text/html"
echo

echo "<!DOCTYPE html>"
echo "<html lang=\"en\">"
echo "<head>"
echo "    <meta charset=\"UTF-8\">"
echo "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
echo "    <title>Backup Logs</title>"
echo "</head>"
echo "<body>"
echo "<h6>Logs backed up to: $backup_folder</h6>"
echo "<a href=\"/scripts/logManager.sh\">Back</a></li>"
echo "</body>"
echo "</html>"
