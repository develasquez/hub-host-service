#!/bin/sh

# This is not an official Google project.

#This script is for educational purposes only, is not certified and is not recommended for production environments.

## Copyright 2021 Google LLC
#Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

#  http://www.apache.org/licenses/LICENSE-2.0
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


gcloud components install beta;

export ORG_ID=;
export BILLING_ID=""
export USER=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
export RANDOM_ID=$RANDOM; 

source utils.sh;
source create_projects.sh
source enable_org_policies.sh
source create_vpcs.sh
source set_shared_vpc.sh
source create_peerings.sh 


#Please set your projects names, leave it as is to generate these names automatically
export HUB_PROJ=hub-project-$RANDOM_ID;
export HOST_PROD=host-project-prod-$RANDOM_ID;
export SERVICE_PROD=service-project-prod-$RANDOM_ID;
export HOST_QA=host-project-qa-$RANDOM_ID;
export SERVICE_QA=service-project-qa-$RANDOM_ID;
export HOST_DEV=host-project-dev-$RANDOM_ID;
export SERVICE_DEV=service-project-dev-$RANDOM_ID;

export REGION=southamerica-west1
export ZONE=a
export SUBNET_HUB=10.128.0.0/20 
export SUBNET_PROD=10.126.0.0/20 
export SUBNET_QA=10.124.0.0/20 
export SUBNET_DEV=10.122.0.0/20 

create_projects;
sleep 15;
set_org_policies ${HUB_PROJ} &
set_org_policies ${HOST_PROD} &
set_org_policies ${SERVICE_PROD} &
set_org_policies ${HOST_QA} &
set_org_policies ${SERVICE_QA} &
set_org_policies ${HOST_DEV} &
set_org_policies ${SERVICE_DEV};
clean_policies_files;

HUB_VPC_NAME="vpc-host";
PROD_VPC_NAME="vpc-prod";
QA_VPC_NAME="vpc-qa";
DEV_VPC_NAME="vpc-dev";
#https://cloud.google.com/vpc/docs/using-vpc#gcloud
create_vpc $HUB_VPC_NAME $HUB_PROJ $SUBNET_HUB $REGION &
create_vpc $PROD_VPC_NAME $HOST_PROD $SUBNET_PROD $REGION &
create_vpc $QA_VPC_NAME $HOST_QA $SUBNET_QA $REGION &
create_vpc $DEV_VPC_NAME $HOST_DEV $SUBNET_DEV $REGION ;

#https://cloud.google.com/vpc/docs/provisioning-shared-vpc#org-policies
gcloud beta resource-manager org-policies enable-enforce \
    --organization $ORG_ID compute.restrictXpnProjectLienRemoval;

#https://cloud.google.com/vpc/docs/provisioning-shared-vpc#gcloud
set_shared_vpc $HOST_PROD $SERVICE_PROD &
set_shared_vpc $HOST_QA $SERVICE_QA &
set_shared_vpc $HOST_DEV $SERVICE_DEV;

#https://cloud.google.com/vpc/docs/using-vpc-peering
create_peerings $HUB_PROJ $HUB_VPC_NAME $HOST_PROD $PROD_VPC_NAME;
create_peerings $HUB_PROJ $HUB_VPC_NAME $HOST_QA $QA_VPC_NAME;
create_peerings $HUB_PROJ $HUB_VPC_NAME $HOST_DEV $DEV_VPC_NAME;

#in both directions 
create_peerings $HOST_PROD $PROD_VPC_NAME $HUB_PROJ $HUB_VPC_NAME ;
create_peerings $HOST_QA $QA_VPC_NAME $HUB_PROJ $HUB_VPC_NAME ;
create_peerings $HOST_DEV $DEV_VPC_NAME $HUB_PROJ $HUB_VPC_NAME ;


#Crear reglas de firewall para Hub y Hosts
#crear HA VPN en Hub con proyecto dummy
#Propagar prefijos desde Hub hacia On Premise (BGP)



