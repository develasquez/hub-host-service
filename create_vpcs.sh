#!/bin/sh

# This is not an official Google project.

#This script is for educational purposes only, is not certified and is not recommended for production environments.

## Copyright 2021 Google LLC
#Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

#  http://www.apache.org/licenses/LICENSE-2.0
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


create_vpc() {
    #https://cloud.google.com/vpc/docs/using-vpc#gcloud 
    #https://cloud.google.com/sdk/gcloud/reference/compute/routers/create
    #https://cloud.google.com/sdk/gcloud/reference/compute/routers/nats/create
    
    VPC_NAME=$1
    PROJECT_ID=$2
    SUBNET_RANGE=$3
    REGION=$4


    gcloud compute networks create $VPC_NAME \
    --project=$PROJECT_ID \
    --subnet-mode=custom \
    --mtu=1460 \
    --bgp-routing-mode=regional &
    gcloud compute networks subnets create $VPC_NAME-subnet \
    --project=$PROJECT_ID \
    --range=$SUBNET_RANGE \
    --network=$VPC_NAME \
    --region=$REGION &
    gcloud compute routers create $VPC_NAME-nat-route \
    --network=$VPC_NAME \
    --region=$REGION \
    --project=$PROJECT_ID;

    gcloud compute routers nats create $VPC_NAME-nat \
    --project=$PROJECT_ID \
    --router=$VPC_NAME-nat-route \
    --router-region=$REGION \
    --auto-allocate-nat-external-ips \
    --nat-custom-subnet-ip-ranges=$VPC_NAME-subnet \
    --enable-dynamic-port-allocation;
}

