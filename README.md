# alluxio-ce-client-integration-tutorial

Learn how to integrate Trino, Spark and other workloads with the Alluxio CE caching file system

---

## INTRO

This git repo provides a complete environment for learning how to configure client workloads such as Trino and Spark to be able to access the Alluxio CE caching file system.

This docker compose package deploys Alluxio Community Edition with 3 master nodes with High Availability (HA) enabled and deploys 2 worker nodes. It will also deploy Trino, Spark, Hive metastore, and MinIO. 

## USAGE

### Step 1. Install Docker desktop 

Install Docker desktop on your laptop, including the docker-compose command.

     See: https://www.docker.com/products/docker-desktop/

### Step 2. Clone this repo

Use the git command to clone this repo (or download the zip file from the github.com site).

     git clone https://github.com/gregpalmr/alluxio-ce-client-integration-tutorial

     cd alluxio-ce-client-integration-tutorial

### Step 5. Launch the docker containers.

Launch the Docker containers defined in the docker-compose.yml file using the command:

     docker-compose up -d

The command will create the network object and the docker volumes, then it will take some time to pull the various docker images. When it is complete, you see this output:

     $ docker-compose up -d
     Creating network "alluxio-ce-client-integration-tutorial_custom" with driver "bridge"
     Creating volume "alluxio-ce-client-integration-tutorial_alluxio-master-1-journal-data" with local driver
     Creating volume "alluxio-ce-client-integration-tutorial_alluxio-master-1-metastore-data" with local driver
     Creating volume "alluxio-ce-client-integration-tutorial_alluxio-master-2-journal-data" with local driver
     Creating volume "alluxio-ce-client-integration-tutorial_alluxio-master-2-metastore-data" with local driver
     Creating volume "alluxio-ce-client-integration-tutorial_alluxio-master-3-journal-data" with local driver
     Creating volume "alluxio-ce-client-integration-tutorial_alluxio-master-3-metastore-data" with local driver
     Creating volume "alluxio-ce-client-integration-tutorial_trino-coordinator-data" with local driver
     Creating volume "alluxio-ce-client-integration-tutorial_trino-worker-1-data" with local driver
     Creating volume "alluxio-ce-client-integration-tutorial_spark-master-data" with local driver
     Creating volume "alluxio-ce-client-integration-tutorial_spark-worker-1-data" with local driver
     Creating volume "alluxio-ce-client-integration-tutorial_hive-metastore-data" with local driver
     Creating volume "alluxio-ce-client-integration-tutorial_mariadb-data" with local driver
     Creating volume "alluxio-ce-client-integration-tutorial_minio-data" with local driver
     Creating mariadb-azi           ... done
     Creating spark-master-azi      ... done
     Creating spark-worker-1-azi    ... done
     Creating trino-worker-1-azi    ... done
     Creating trino-coordinator-azi ... done
     Creating minio-azi             ... done
     Creating minio-create-buckets-azi ... done
     Creating hive-metastore-azi       ... done
     Creating alluxio-master-2-azi     ... done
     Creating alluxio-master-3-azi     ... done
     Creating alluxio-master-1-azi     ... done
     Creating alluxio-worker-2-azi     ... done
     Creating alluxio-worker-1-azi     ... done
     
### Step 5. Access the Alluxio Master nodes and Worker nodes

This Docker Compose package deploys three Alluxio master node containers and two worker node containers, and it starts the Alluxio master node processes and the worker node processes.

To access the Alluxio master node containers, use these commands:

     docker exec -it alluxio-master-1 bash
     docker exec -it alluxio-master-2 bash
     docker exec -it alluxio-master-3 bash

To access the Alluxio worker node containers, use these commands:

     docker exec -it alluxio-worker-1 bash
     docker exec -it alluxio-worker-2 bash

## Step 6. Inspect the TLS configuration

Open a bash shell to one of the master nodes and view the cert files and the Alluxio properties. Open the bash shell with this command:

     docker exec -it alluxio-master-1 bash

Inspect the TLS keystore and trustore files with these commands:

     ls -al /alluxio/certs/
     total 20
     drwxr-xr-x 2 root root 4096 Jul 18 22:03 .
     drwxr-xr-x 3 root root 4096 Jul 18 22:03 ..
     -r--r----- 1 root root 2862 Jul 18 22:03 all-alluxio-nodes-keystore.jks
     -r--r--r-- 1 root root 1366 Jul 18 22:03 all-alluxio-nodes-truststore.jks
     -r--r----- 1 root root 1387 Jul 18 22:03 all-alluxio-nodes.cert

These keystore and trustore files were created by the create-tls-certs service in the docker-compose.yaml file and it called the script located here:

     cat /scripts/create-tls-certs.sh

You can view the contents of the main keystore file (which contains the keys for each of the alluxio nodes) by using these commands:

     keytool -list -v -keystore /alluxio/certs/all-alluxio-nodes-keystore.jks -storepass changeme123 | more

or

     keytool -list -v -keystore /alluxio/certs/all-alluxio-nodes-keystore.jks -storepass changeme123 | grep 'Owner:'

You can view the Alluxio properties file that references these keystore and trustore files using this command:

     cat /opt/alluxio/conf/alluxio-site.properties | more

The key section that references the keystore and trustore files looks like this:

     # Master TLS properties
     alluxio.network.tls.enabled=true
     alluxio.network.tls.keystore.path=/etc/alluxio/certs/all-alluxio-nodes-keystore.jks
     alluxio.network.tls.keystore.password=changeme123
     alluxio.network.tls.keystore.key.password=changeme123
     alluxio.network.tls.keystore.alias=alluxio-master-1

     # Client TLS properties (worker to master, or master to master, client app to master/worker )
     alluxio.network.tls.enabled=true
     alluxio.network.tls.truststore.path=/etc/alluxio/certs/all-alluxio-nodes-truststore.jks
     alluxio.network.tls.truststore.password=changeme123
     alluxio.network.tls.truststore.alias=alluxio-master-1


View the Alluxio master nodes status using the following two commands:

     bin/alluxio fs masterInfo

and

     bin/alluxio fsadmin report

These commands should show the leading master node and the standby master nodes as well as the "live" worker nodes.

### Step 7. Destroy the containers

When finished, destroy the docker containers and clean up the docker volumes using these commands:

     docker-compose down

     docker volume prune

---

Please direct questions or comments to greg.palme@alluxio.com
