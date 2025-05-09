# New MariaDB

## Overview

**New MariaDB** is a Bash script that automates the creation of a new database and user in MariaDB. It simplifies the process by prompting for necessary credentials and applying appropriate privileges.

## Features

- Creates a new MariaDB database.
- Creates a new user and assigns privileges.
- Ensures database and user creation only if they do not already exist.
- Supports using credentials from ~/.my.cnf if available.
- Secure password handling during input.

## Requirements

Before running the script, ensure that:

- You have MariaDB installed and running.
- You have SUPER or GRANT OPTION privileges to MariaDB.

## Usage

**Running without arguments**

If you run the script without any arguments:

```bash
./new-mariadb.sh
```

It will:

- Check if ~/.my.cnf exists.
- Attempt to authenticate using credentials stored in ~/.my.cnf.
- Validate that the credentials have SUPER or GRANT OPTION privileges.

If valid, the script will proceed.

**Running with admin user argument**

If ~/.my.cnf is not present or invalid, you can manually provide the admin username with:

```bash
./new-mariadb.sh -u <admin_user>
```

You will then be prompted securely during execution for:

- **Admin password** (for authentication)
- **New Database Name**
- **New Username**
- **New Password** (entered securely)

## Important Notes

- The script ensures that the database and user are created only if they do not already exist.
- User credentials are entered securely and not exposed in the command line.
- The script validates that the admin user has sufficient privileges before proceeding.

## Enjoying This Script?

**If you found this script useful, a small tip is appreciated ❤️**
[https://buymeacoffee.com/paulsorensen](https://buymeacoffee.com/paulsorensen)

## License

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.

**Legal Notice:** If you edit and redistribute this code, you must mention the original author, **Paul Sørensen** ([paulsorensen.io](https://paulsorensen.io)), in the redistributed code or documentation.

**Copyright (C) 2025 Paul Sørensen ([paulsorensen.io](https://paulsorensen.io))**

See the LICENSE file in this repository for the full text of the GNU General Public License v3.0, or visit [https://www.gnu.org/licenses/gpl-3.0.txt](https://www.gnu.org/licenses/gpl-3.0.txt).
