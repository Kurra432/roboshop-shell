script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then

   echo Mysql Root Password  missing
exit
   fi
component="shipping"
schema_setup=mysql

java_func