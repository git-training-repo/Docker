#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

USERNAME=${MYSQL_USER:-"admin"}
PASS=${MYSQL_PASS:-$(pwgen -s 12 1)}
_userword=$( [ ${MYSQL_USER} ] && echo "preset" || echo "random" )
_password=$( [ ${MYSQL_PASS} ] && echo "preset" || echo "random" )
echo "=> Creating MySQL admin user with ${_userword} user and ${_password} password"

mysql -uroot -e "CREATE USER '$USERNAME'@'%' IDENTIFIED BY '$PASS'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '$USERNAME'@'%' IDENTIFIED BY '$PASS' WITH GRANT OPTION; FLUSH PRIVILEGES"

mysql -u$USERNAME -p$MYSQL_PASS -e 'CREATE DATABASE devops CHARACTER SET UTF8'

echo "=> Done!"

echo "========================================================================"
echo "You can now connect to this MySQL Server using:"
echo ""
echo "    mysql -u$USERNAME -p$PASS -h<host> -P<port>"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "MySQL user 'root' has no password but only allows local connections"
echo "========================================================================"

#mysqladmin -uroot shutdown
