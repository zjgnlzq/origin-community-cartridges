#!/bin/sh

wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz
tar xvf jboss-as-7.1.1.Final.tar.gz --directory=/opt
rm jboss-as-7.1.1.Final.tar.gz

git clone  https://github.com/openshift/jboss-as7-modules.git
cp -r jboss-as7-modules/mysql/modules/* /opt/jboss-as-7.1.1.Final/modules
cp -r jboss-as7-modules/mongodb/modules/* /opt/jboss-as-7.1.1.Final/modules
rm -rf jboss-as7-modules

ln -s /opt/jboss-as-7.1.1.Final /etc/alternatives/jbossas-7

wget https://github.com/openshift/origin-community-cartridges/blob/master/openshift-origin-cartridge-jbossas-7/openshift-origin-cartridge-jbossas-7.tar.gz?raw=true
mkdir -p /usr/libexec/openshift/cartridges/jbossas-7
tar xvf openshift-origin-cartridge-jbossas-7.tar.gz --directory=/usr/libexec/openshift/cartridges/jbossas-7
rm openshift-origin-cartridge-jbossas-7.tar.gz

cd /var/www/openshift/broker/
bundle exec rake tmp:clear
cd

