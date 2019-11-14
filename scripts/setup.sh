#!/bin/sh
OCP_USERNAME=ocp20
DIRECTORY=lab
mkdir $DIRECTORY
echo "
catalog.http.port: 8080
connection_string: mongodb://catalog-mongodb:27017
db_name: catalogdb
username: mongo
password: mongo" > $DIRECTORY/app-config.yaml
echo "
swarm:
  datasources:
    data-sources:
      InventoryDS:
        driver-name: postgresql
        connection-url: jdbc:postgresql://inventory-postgresql:5432/inventorydb
        user-name: jboss
        password: jboss"  >  $DIRECTORY/inventory-config.yaml
oc new-project $OCP_USERNAME-coolstore \
     --display-name="CoolStore API" \
     --description="CoolStore API Business Services"
oc create configmap app-config \
 --from-file=lab/app-config.yaml \
 -n $OCP_USERNAME-coolstore
oc policy add-role-to-user \
view -z default -n $OCP_USERNAME-coolstore
oc create -f https://raw.githubusercontent.com/gpe-mw-training/3scale_development_labs/master/CoolStore/coolstore-catalog-mongodb-persistent.yaml  \
-n $OCP_USERNAME-coolstore
oc new-app \
        --template=coolstore-catalog-mongodb \
        -p CATALOG_DB_USERNAME=mongo \
        -p CATALOG_DB_PASSWORD=mongo \
        -n $OCP_USERNAME-coolstore
oc get pods -w -n $OCP_USERNAME-coolstore
oc rollout resume deploy/catalog-service -n $OCP_USERNAME-coolstore
oc get pods -w -n $OCP_USERNAME-coolstore
curl -k http://`oc get route -n $OCP_USERNAME-coolstore  catalog-unsecured --template {{.spec.host}}`/docs/coolstore-catalog-microservice-swagger.yaml
curl -k http://`oc get route -n $OCP_USERNAME-coolstore  catalog-unsecured --template {{.spec.host}}`/products
oc create configmap inventory-config \
--from-file=lab/inventory-config.yaml -n $OCP_USERNAME-coolstore
oc create -f https://raw.githubusercontent.com/gpe-mw-training/3scale_development_labs/master/CoolStore/coolstore-inventory-persistent.yaml \
-n $OCP_USERNAME-coolstore
oc new-app \
    --template=coolstore-inventory-postgresql \
    -p INVENTORY_SERVICE_NAME=inventory-service \
    -p INVENTORY_DB_USERNAME=jboss \
    -p INVENTORY_DB_PASSWORD=jboss \
    -p INVENTORY_DB_NAME=inventorydb
oc get pods -w -n $OCP_USERNAME-coolstore
oc rollout resume deploy/inventory-service -n $OCP_USERNAME-coolstore
curl -k -X GET http://`oc get route -n $OCP_USERNAME-coolstore \
 inventory-unsecured --template {{.spec.host}}`/swagger.json
curl -k -X GET http://`oc get route -n $OCP_USERNAME-coolstore \
  inventory-unsecured --template {{.spec.host}}`/inventory/165613


 