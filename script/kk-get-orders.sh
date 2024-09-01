#!/bin/bash
# Script to get all orders from Shopware Shop, write them into a file and remove from database. Also Remove Logs and customer data.

WHEREAMI="/home/${USER}/kaoskvlt.de"
PASSWORD="$(base64 -d $WHEREAMI/mysql.key)"
TIMESTAMP=$(date +%Y_%m_%d-%H-%M-%S)
REMOTEUSER=""
DOMAIN=""
DBUSER=""

if [[ $(ssh ${REMOTEUSER}@${DOMAIN} -i /home/${USER}/.ssh/kaoskvlt.de "mysql --silent --binary-as-hex  -e 'SELECT EXISTS(SELECT 1 FROM \`order\`);' -u ${DBUSER} -p"$PASSWORD" db-1") == 1 ]];
  then
    echo $TIMESTAMP": New Orders"
    ssh -i /home/${USER}/.ssh/ssh.key ${REMOTEUSER}@${DOMAIN} "mysql --binary-as-hex -udb-user-1 -p"$PASSWORD" db-1" < $WHEREAMI/get-order-querie.sql > /home/${USER}/kaoskvlt.de/order/$TIMESTAMP.txt
    ssh -i /home/${USER}/.ssh/ssh.key ${REMOTEUSER}@${DOMAIN} 'php bin/console cache:clear'
    /bin/bash $WHEREAMI/mail.sh
    cd /home/${USER}/kaoskvlt.de/order
    awk '/\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*/{filename=NR"'$TIMESTAMP'.txt"}; {print >filename}' $TIMESTAMP.txt
    mv $TIMESTAMP.txt ../done-orders/
  else
    echo $TIMESTAMP": No Orders" 
fi
