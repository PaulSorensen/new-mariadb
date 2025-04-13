#!/bin/bash
################################################################################
# Script Name   : New MariaDB
# Author        : Paul Sørensen
# Website       : https://paulsorensen.io
# GitHub        : https://github.com/paulsorensen
# Version       : 1.0
# Last Modified : 2025/04/14 01:12:20
#
# Description:
# Creates a new database and user on MariaDB.
#
# Usage: Refer to README.md for details on how to use this script.
#
# If you found this script useful, a small tip is appreciated ❤️
# https://buymeacoffee.com/paulsorensen
################################################################################

BLUE='\033[38;5;81m'
NC='\033[0m'
echo -e "${BLUE}New MariaDB by paulsorensen.io${NC}"
echo ""

# Function to display usage
usage() {
    echo "Usage: $0 -u <admin_user> -p"
    exit 1
}

# Parse command-line arguments
while getopts "u:p" opt; do
    case "$opt" in
        u) ADMIN_USER="$OPTARG" ;;
        p) 
            echo -n "Enter password for MariaDB $ADMIN_USER: "
            read -s ADMIN_PASS
            echo
            ;;
        *) usage ;;
    esac
done

# Ensure both username and password were provided
if [ -z "$ADMIN_USER" ] || [ -z "$ADMIN_PASS" ]; then
    usage
fi

# Request input for the new database, user, and password
read -p "Enter the new database name: " DB_NAME
read -p "Enter the new username: " DB_USER
read -s -p "Enter the new password for $DB_USER: " DB_PASS
echo

# SQL command to create the database, user, and grant privileges
SQL_COMMAND="CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;"

# Execute the SQL command
echo "Creating database and user..."
mariadb -u "$ADMIN_USER" -p"$ADMIN_PASS" -e "$SQL_COMMAND"

# Check if the command was successful
if [ $? -eq 0 ]; then
    echo -e "${BLUE}Database '$DB_NAME' and user '$DB_USER' created successfully.${NC}"
else
    echo "Error creating database or user. Check your credentials and try again."
fi