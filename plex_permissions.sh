#!/bin/bash
# Justin Mason
# Fix permissions to work with Plex Server

# Ensure the script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo."
  exit 1
fi

# Check if the directory path is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/directory"
  exit 1
fi

# Set the target directory
TARGET_DIR="$1"

# Display the target directory and prompt for confirmation
echo "Target directory is: $TARGET_DIR"
read -p "Are you sure you want to change permissions and group ownership to Plex for this directory? (y/n): " confirm

# Check if the user confirmed
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Operation canceled."
  exit 0
fi

# Recursively set permissions and group ownership, excluding 'lost+found' directory
find "$TARGET_DIR" -type d ! -name "lost+found" -exec chmod g=rx {} + -exec chgrp plex {} +   # Set group to read and execute for directories and change group to 'plex'
find "$TARGET_DIR" -type f ! -path "$TARGET_DIR/lost+found/*" -exec chmod g=r {} + -exec chgrp plex {} +    # Set group to read only for files and change group to 'plex'

echo "Permissions and group ownership updated: Directories (g=rx), Files (g=r), Group (plex), excluding 'lost+found'"
