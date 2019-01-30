#!/usr/bin/env bash

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ ! -d /var/lib/mysql/mysql ]; then
	# MySQL data directory not found, creating initial DBs
	chown -R mysql:mysql /var/lib/mysql

	# init database
	mysql_install_db --user=mysql > /dev/null

	# create temp file
	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
	    return 1
	fi

	# save sql
	cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
EOF


	# Create new database
	if [ "$MYSQL_DATABASE" != "" ]; then
		# Creating database: $MYSQL_DATABASE
		echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile
	fi

	echo 'FLUSH PRIVILEGES;' >> $tfile

	# run sql in tempfile
	/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 < $tfile
	rm -f $tfile
fi
