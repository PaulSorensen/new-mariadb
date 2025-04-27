#!/bin/bash
################################################################################
# Script Name   : New MariaDB
# Author        : Paul Sørensen
# Website       : https://paulsorensen.io
# GitHub        : https://github.com/paulsorensen
# Version       : 1.1
# Last Modified : 2025/04/27 04:52:10
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
RED='\033[38;5;203m'
NC='\033[0m'
echo -e "${BLUE}New MariaDB by paulsorensen.io${NC}"
echo ""

# Function to display usage
usage() {
    echo "Usage: $0 -u <admin_user>"
    exit 1
}

# Function to check ~/.my.cnf credentials
check_my_cnf() {
    if [ -f ~/.my.cnf ]; then
        if mysql -e "SELECT 1" >/dev/null 2>&1; then
            if mysql -e "SELECT 1 FROM mysql.user LIMIT 1" >/dev/null 2>&1; then
                return 0
            else
                echo -e "${RED}Credentials in ~/.my.cnf lack sufficient privileges (SUPER or GRANT OPTION required)${NC}"
                exit 1
            fi
        else
            echo -e "${RED}Credentials in ~/.my.cnf are invalid${NC}"
            exit 1
        fi
    fi
    return 1
}

# Parse command-line arguments
while getopts ":u:" opt; do
    case "$opt" in
        u)
            ADMIN_USER="$OPTARG"
            echo -n "Enter password for MariaDB $ADMIN_USER: "
            read -s ADMIN_PASS
            echo
            ;;
        *) usage ;;
    esac
done

# Check argument conditions
if [ $# -eq 0 ]; then
    # No parameters: check ~/.my.cnf
    check_my_cnf || usage
elif [ -z "$ADMIN_USER" ] || [ -z "$ADMIN_PASS" ]; then
    # If -u is missing or password not entered, call usage
    usage
else
    # Verify credentials and admin privileges
    if mysql -u "$ADMIN_USER" -p"$ADMIN_PASS" -e "SELECT 1" >/dev/null 2>&1; then
        if mysql -u "$ADMIN_USER" -p"$ADMIN_PASS" -e "SELECT 1 FROM mysql.user LIMIT 1" >/dev/null 2>&1; then
            # Credentials valid and have admin privileges
            :
        else
            echo -e "${RED}Provided credentials lack sufficient privileges (SUPER or GRANT OPTION required)${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Provided credentials are invalid${NC}"
        exit 1
    fi
fi

# Request input for the new database, user, and password
read -p "Enter the new database name: " DB_NAME
read -p "Enter the new username: " DB_USER
read -s -p "Enter the new password for $DB_USER: " DB_PASS
echo

# SQL command to create the database, user, and grant privileges
SQL_COMMAND="CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';
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