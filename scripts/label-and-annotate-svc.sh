#!/bin/sh
PROJECT=ocp20-coolstore
SERVICES="catalog-service inventory-service"
for SERVICE in $SERVICES
do
  oc label svc $SERVICE discovery.3scale.net=true -n $PROJECT
  oc annotate svc $SERVICE discovery.3scale.net/scheme=http -n $PROJECT
  oc annotate svc $SERVICE discovery.3scale.net/port=8080 -n $PROJECT
done
