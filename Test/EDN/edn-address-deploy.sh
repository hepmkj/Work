#!/bin/bash
#
# deploy script for EDN Address Standardizer
#

# assumptions:
# Have to be root to run this.
# This script expects edn-addrall-install to be
# in home directory of user 'dep'.
# Assumes /home/dep

check_file ()
{
   if [ ! -f $1 ]; then
        echo "Does this server have $2 installed?($1)" 1>&2
        ls -l $1
        exit 44
   fi
}

# fix the LD_LIBRARY_PATH
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
install_dir=$script_dir/..
source $script_dir/config-edn-address.sh

# cp library to hard-coded name (yes copy not move)
# softlink will not work
# for now I want a copy of the original
cp $script_dir/../lib/libaddrstddso.so $script_dir/../lib/sb_dso_xmladdrstd.so
group=$(stat -c "%G" $script_dir/../lib/libaddrstddso.so)
chown $SUDO_USER:$group $script_dir/../lib/sb_dso_xmladdrstd.so

cp $script_dir/../lib/libaddrsuggdso.so $script_dir/../lib/sb_dso_adslist.so
group=$(stat -c "%G" $script_dir/../lib/libaddrsuggdso.so)
chown $SUDO_USER:$group $script_dir/../lib/sb_dso_adslist.so

# set up the service script
stda_port=$(grep Server.Port $install_dir/etc/stdanetsvc.cfg | grep -Eo [1-9][0-9]+)
http_port=$(($stda_port+10))

cp $script_dir/../etc/stdanetsvc.RHEL /etc/rc.d/init.d/stdanetsvc$stda_port
chmod 755 /etc/rc.d/init.d/stdanetsvc$stda_port

# set root path for app in service script
perl -pi -e "s%APPETL_HOME=fixme%APPETL_HOME=$install_dir%g;"  /etc/rc.d/init.d/stdanetsvc$stda_port

# set user name for launching app in service script
echo "edit statement is: s%APPETL_USER=fixme%APPETL_USER=$USER%g;"
perl -pi -e "s%APPETL_USER=fixme%APPETL_USER=root%g;"  /etc/rc.d/init.d/stdanetsvc$stda_port
# DEBUG: cat /etc/rc.d/init.d/stdanetsvc

# now start the service
echo "before service stdanetsvc start"
/sbin/service stdanetsvc$stda_port start
echo "after service stdanetsvc start"

# check the service
/sbin/service stdanetsvc$stda_port status

sleep 2
#$install_dir/bin/apachectl -I XMLADDRSTD start
sleep 2
#$install_dir/bin/apachectl -I ADSL start

# create the metrics report directory if not exists
#mkdir -p $install_dir/metrics
#group=$(stat -c "%G" logs/)
#chown -hR $SUDO_USER:$group $install_dir/metrics
#chmod 775 $install_dir/metrics

#create the crontab entry for capturing reports
# remove...
#crontab -u $SUDO_USER -l | grep -v $script_dir/edn-report-metrics.sh | crontab -u $SUDO_USER -
# re-add...
#(crontab -u $SUDO_USER -l ; echo "30 23 * * * $script_dir/edn-report-metrics.sh localhost $http_port") | crontab -u $SUDO_USER -

# run dev stress test
$install_dir/bin/stdactest localhost $stda_port 1
if [ "$?" == 1 ]; then
     echo "Dev EDN address standardizer self test failed" 1>&2
     exit 11
fi

#java - jar /app/ednweb-1.5-SNAPSHOT.jar

#echo "Hello" && tail -f /dev/null

[mxj142:df-usdn-service-files]$
[mxj142:df-usdn-service-files]$ cat edn-address-deploy.sh
#!/bin/bash
#
# deploy script for EDN Address Standardizer
#

# assumptions:
# Have to be root to run this.
# This script expects edn-addrall-install to be
# in home directory of user 'dep'.
# Assumes /home/dep

check_file ()
{
   if [ ! -f $1 ]; then
        echo "Does this server have $2 installed?($1)" 1>&2
        ls -l $1
        exit 44
   fi
}

# fix the LD_LIBRARY_PATH
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
install_dir=$script_dir/..
source $script_dir/config-edn-address.sh

# cp library to hard-coded name (yes copy not move)
# softlink will not work
# for now I want a copy of the original
cp $script_dir/../lib/libaddrstddso.so $script_dir/../lib/sb_dso_xmladdrstd.so
group=$(stat -c "%G" $script_dir/../lib/libaddrstddso.so)
chown $SUDO_USER:$group $script_dir/../lib/sb_dso_xmladdrstd.so

cp $script_dir/../lib/libaddrsuggdso.so $script_dir/../lib/sb_dso_adslist.so
group=$(stat -c "%G" $script_dir/../lib/libaddrsuggdso.so)
chown $SUDO_USER:$group $script_dir/../lib/sb_dso_adslist.so

# set up the service script
stda_port=$(grep Server.Port $install_dir/etc/stdanetsvc.cfg | grep -Eo [1-9][0-9]+)
http_port=$(($stda_port+10))

cp $script_dir/../etc/stdanetsvc.RHEL /etc/rc.d/init.d/stdanetsvc$stda_port
chmod 755 /etc/rc.d/init.d/stdanetsvc$stda_port

# set root path for app in service script
perl -pi -e "s%APPETL_HOME=fixme%APPETL_HOME=$install_dir%g;"  /etc/rc.d/init.d/stdanetsvc$stda_port

# set user name for launching app in service script
echo "edit statement is: s%APPETL_USER=fixme%APPETL_USER=$USER%g;"
perl -pi -e "s%APPETL_USER=fixme%APPETL_USER=root%g;"  /etc/rc.d/init.d/stdanetsvc$stda_port
# DEBUG: cat /etc/rc.d/init.d/stdanetsvc

# now start the service
echo "before service stdanetsvc start"
/sbin/service stdanetsvc$stda_port start
echo "after service stdanetsvc start"

# check the service
/sbin/service stdanetsvc$stda_port status

sleep 2
#$install_dir/bin/apachectl -I XMLADDRSTD start
sleep 2
#$install_dir/bin/apachectl -I ADSL start

# create the metrics report directory if not exists
#mkdir -p $install_dir/metrics
#group=$(stat -c "%G" logs/)
#chown -hR $SUDO_USER:$group $install_dir/metrics
#chmod 775 $install_dir/metrics

#create the crontab entry for capturing reports
# remove...
#crontab -u $SUDO_USER -l | grep -v $script_dir/edn-report-metrics.sh | crontab -u $SUDO_USER -
# re-add...
#(crontab -u $SUDO_USER -l ; echo "30 23 * * * $script_dir/edn-report-metrics.sh localhost $http_port") | crontab -u $SUDO_USER -

# run dev stress test
$install_dir/bin/stdactest localhost $stda_port 1
if [ "$?" == 1 ]; then
     echo "Dev EDN address standardizer self test failed" 1>&2
     exit 11
fi

#java - jar /app/ednweb-1.5-SNAPSHOT.jar

#echo "Hello" && tail -f /dev/null

