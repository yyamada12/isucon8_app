#!/bin/sh

set -eux

SCRIPT_DIR=$(dirname "$0")

cd $SCRIPT_DIR

date -R
echo "Started deploying."

# rotate logs
./rotate_log.sh /var/log/h2o/access.log
./rotate_log.sh /var/log/h2o/error.log

./rotate_log.sh /var/log/mariadb/mysqld.log
./rotate_log.sh /var/log/mariadb/slow.log

./rotate_log.sh ../log/cpu.pprof
# build go app
cd ..
make
cd $SCRIPT_DIR

# restart services
sudo systemctl restart mariadb
sudo systemctl restart torb.go
sudo systemctl restart h2o

date -R
echo "Finished deploying."
