#!/bin/bash

set -e
/usr/bin/mysql_install_db --datadir=/var/lib/mysql --user=mysql
# Workaround for some versions of /etc/init.d/mysqld
touch /etc/sysconfig/network
rpm -ivh http://ftp.otrs.org/pub/otrs/RPMS/rhel/6/otrs-5.0.4-01.noarch.rpm 
/etc/init.d/mysqld start
mysql -u root mysql < /opt/setup-otrs/create_otrs_db.sql
mysql -u root otrs < /opt/setup-otrs/otrs_tables.sql
/opt/setup-otrs/set-config-pm-value.pl Database=otrs \
      DatabaseUser=otrs DatabasePw=otrs DatabaseHost=127.0.0.1 SecureMode=1
/opt/otrs/bin/otrs.SetPassword.pl root@localhost root
/opt/otrs/bin/otrs.PackageManager.pl -a install \
       -p http://ftp.otrs.org/pub/otrs/packages/:FAQ-5.0.2.opm
/opt/otrs/bin/otrs.PackageManager.pl -a install \
       -p http://ftp.otrs.org/pub/otrs/packages/:Support-1.5.4.opm
/opt/otrs/bin/otrs.PackageManager.pl -a install \
       -p http://ftp.otrs.org/pub/otrs/itsm/bundle32/:ITSM-3.2.9.opm
/etc/init.d/mysqld stop
chown -R otrs:apache /opt/otrs
chmod -R g+rwX /opt/otrs
ls -l /
exit 0

