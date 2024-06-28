cp mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-org -y

# we need to update the 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf

systemctl enable mongod
systemctl restart mongod