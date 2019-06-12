FROM openjdk:7-jdk
MAINTAINER devops-docker.team

ENV DEBIAN_FRONTEND noninteractive
ENV TOMCAT_MAJOR_VERSION=8
ENV TOMCAT_VERSION=8.5.33
ENV TOMCAT_HOME=/opt/apache-tomcat-$TOMCAT_VERSION
RUN echo "deb [check-valid-until=no] http://cdn-fastly.deb.debian.org/debian jessie main" > /etc/apt/sources.list.d/jessie.list
RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/deb http:\/\/\(deb\|httpredir\).debian.org\/debian jessie.* main/d' /etc/apt/sources.list
RUN apt-get -o Acquire::Check-Valid-Until=false update
RUN echo "Acquire::Check-Valid-Until no;" > /etc/apt/apt.conf.d/99no-check-valid-until

# Install mysql-server and tomcat 7

RUN apt-get update && apt-get install -y lsb-release && \
  wget https://dev.mysql.com/get/mysql-apt-config_0.8.4-1_all.deb && \
  dpkg -i mysql-apt-config_0.8.4-1_all.deb && rm -f mysql-apt-config_0.8.4-1_all.deb && \
  mkdir -p $TOMCAT_HOME && cd /opt && \
  wget http://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR_VERSION/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz && \
  tar -xvf apache-tomcat-$TOMCAT_VERSION.tar.gz && rm -f apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN apt-key adv --recv-keys --keyserver ha.pool.sks-keyservers.net 65FFB764
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 5072E1F5
RUN apt-get clean
RUN apt-get autoclean
# Install packages
RUN apt-get update && \
  apt-get -y install mysql-server pwgen supervisor && \
  apt-get clean && \
  apt-get -y install openjdk-7-jdk && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Add image configuration and scripts
ADD start-tomcat.sh /start-tomcat.sh
ADD start-mysqld.sh /start-mysqld.sh
ADD run.sh /run.sh
RUN chmod 777 /*.sh
ADD my.cnf /etc/mysql/my.cnf
ADD supervisord-tomcat.conf /etc/supervisor/conf.d/supervisord-tomcat.conf
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL utils
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod 777 /*.sh

WORKDIR $TOMCAT_HOME

#add sailpoint
ADD identityiq.war $TOMCAT_HOME/webapps/iiq/identityiq.war
RUN chmod 777 $TOMCAT_HOME/webapps/iiq/*

# Add volumes for MySQL 
VOLUME  ["/etc/mysql", "/var/lib/mysql"]

EXPOSE 8080 3306

ENTRYPOINT ["/run.sh"]
