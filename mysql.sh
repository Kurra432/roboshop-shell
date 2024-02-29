script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1
if [ -z "$mysql_root_password" ]; then

   echo My Sql Password  missing
exit
   fi

echo -e "\e[36m>>>>>>>>>>>>>>>MySQL Disable<<<<<<<<<\e[0m"
dnf module disable mysql -y
echo -e "\e[36m>>>>>>>>>>>>>>>Copying MySQL repo file<<<<<<<<<\e[0m"
cp ${script_path}/mysql.repo  /etc/yum.repos.d/mysql.repo
echo -e "\e[36m>>>>>>>>>>>>>>>Install MySQL <<<<<<<<<\e[0m"
dnf install mysql-community-server -y
echo -e "\e[36m>>>>>>>>>>>>>>>Set root Passwd for MySQL <<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass ${mysql_root_password}
echo -e "\e[36m>>>>>>>>>>>>>>>Start  MySQL <<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl restart mysqld