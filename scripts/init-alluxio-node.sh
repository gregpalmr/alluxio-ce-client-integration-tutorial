#!/bin/bash
#
# SCRIPT: init-alluxio-node.sh
#

     # Copy the Alluxio conf files from tmp dir
     cp /tmp/config-files/alluxio/alluxio-site.properties /opt/alluxio/conf/alluxio-site.properties
     cp /tmp/config-files/alluxio/masters /opt/alluxio/conf/masters
     cp /tmp/config-files/alluxio/workers /opt/alluxio/conf/workers
     chmod 744 /opt/alluxio/conf/*

     # If deploying Alluxio Enterprise Edition, create the license key file
     if [[ -n "${ALLUXIO_LICENSE_BASE64}" ]]; then
       echo "${ALLUXIO_LICENSE_BASE64}" | base64 -d > /opt/alluxio/license.json
     fi

     # Replace the template variable in alluxio-site.properties file with this hostname
     myhostname=$(hostname)
     sed -i "s/THIS_HOSTNAME/${myhostname}/g" /opt/alluxio/conf/alluxio-site.properties

     # Turn on Alluxio DEBUG mode in log4j
     # sed -i "s/=INFO/=DEBUG/g" /opt/alluxio/conf/log4j.properties
     
# end of script
