#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mysqld --initialize-insecure --user=mysql > /dev/null 2>&1
    echo "=> Done!"  
    /create_mysql_admin_user.sh
else
    echo "=> Using an existing volume of MySQL"
fi

echo "Current path is: "
echo $PWD
cd webapps

echo $PWD
for entry in "$PWD"/*
do
  echo "$entry"
done

cd iiq
echo $PWD
for entry in "$PWD"/*
do
  echo "$entry"
done


echo $PWD
yum install java-devel
jar -xvf identityiq.war
echo $PWD
cd WEB-INF/bin
chmod +x iiq
./iiq schema
echo "Create IIQ Schema"
echo $PWD

cd ..
chmod 777 classes/*
cd classes
sed -i 's/dataSource.password=Qwerty12!/dataSource.password=1:iCAlakm5CVUe7+Q6hVJIBA==/g' iiq.properties

echo $PWD
cd ..
cd database
echo $PWD
#mysql -u$USERNAME -p$PASS -h<host> -P<port>
echo "DB connect"
mysql -uroot -e "source create_identityiq_tables.mysql"
mysql -uroot -e "show databases"
echo "DB connect success"
echo $PWD
cd ..

echo "Initializing IIQ"
cd bin
echo "import init.xml" >> iiq-init.sh
chmod 777 iiq-init.sh
echo $PWD
./iiq console < iiq-init.sh
echo "IIQ is ready"

mysqladmin -uroot shutdown


exec supervisord -n