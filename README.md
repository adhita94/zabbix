# zabbix

```
$  cat /etc/os-release
$  wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+$(lsb_release -sc)_all.deb
$  sudo dpkg -i zabbix-release_5.0-1+$(lsb_release -sc)_all.deb
$  sudo apt update
$  wget https://repo.zabbix.com/zabbix/5.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.2-1+ubuntu$(lsb_release -rs)_all.deb
$  sudo dpkg -i zabbix-release_5.2-1+ubuntu$(lsb_release -rs)_all.deb
$  sudo apt update
$  sudo apt -y install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-agent
$  sudo apt -y install mariadb-common mariadb-server mariadb-client
$  sudo systemctl start mariadb
$  sudo systemctl enable mariadb
$  sudo mysql_secure_installation
$  sudo mysql -uroot -p'admin' -e "create database zabbix character set utf8 collate utf8_bin;"
$  sudo mysql -uroot -p'admin' -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';"
$  sudo mysql -uroot -p'admin' zabbix -e "set global innodb_strict_mode='OFF';"
$  sudo zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p'zabbix' zabbix
$  sudo mysql -uroot -p'rootDBpass' zabbix -e "set global innodb_strict_mode='ON';"
$  sudo mysql -uroot -p'admin' zabbix -e "set global innodb_strict_mode='ON';"
$  sudo vi /etc/zabbix/zabbix_server.conf
$  sudo systemctl restart zabbix-server zabbix-agent
$  sudo systemctl enable zabbix-server zabbix-agent
$  ps -ef | grep -i zabbix
$  sudo vi /etc/zabbix/apache.conf
$  sudo systemctl restart apache2
$  sudo systemctl enable apache2
```
