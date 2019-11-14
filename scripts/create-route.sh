#!/bin/sh
OCP_WILDCARD_DOMAIN=apps.4865.open.redhat.com
OCP_USERNAME=ocp20
GW_PROJECT=$OCP_USERNAME-gw
oc create route edge inventory-service-policy-staging-route \
  --service=stage-apicast \
  --hostname=inventory-service-staging-apicast-$OCP_USERNAME.$OCP_WILDCARD_DOMAIN \
  -n $GW_PROJECT
oc create route edge catalog-service-policy-staging-route \
  --service=stage-apicast \
  --hostname=catalog-service-staging-apicast-$OCP_USERNAME.$OCP_WILDCARD_DOMAIN \
  -n $GW_PROJECT
oc create route edge inventory-service-policy-production-route \
  --service=prod-apicast \
  --hostname=inventory-service-production-apicast-$OCP_USERNAME.$OCP_WILDCARD_DOMAIN \
  -n $GW_PROJECT
oc create route edge catalog-service-policy-production-route \
  --service=prod-apicast \
  --hostname=catalog-service-production-apicast-$OCP_USERNAME.$OCP_WILDCARD_DOMAIN \
  -n $GW_PROJECT
  oc get route -n $GW_PROJECT

  
