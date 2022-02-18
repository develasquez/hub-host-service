#!/bin/bash
# This is not an official Google project.

#This script is for educational purposes only, is not certified and is not recommended for production environments.

## Copyright 2021 Google LLC
#Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

#  http://www.apache.org/licenses/LICENSE-2.0
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.



#We need to create a set of projects 
# In this example we'll create the next projects structure

#[1] communication-hub-project
#   - [2] host-project-prod
#       - [3] sample-service-project-prod
#   - [2] host-project-qa
#       - [3] sample-service-project-qa
#   - [2] host-project-dev
#       - [3] sample-service-project-dev

create_projects() {
    gcloud projects create $HUB_PROJ --name="Communications Hub Project" > /dev/null &
    gcloud projects create $HOST_PROD --name="Host Project Prod" > /dev/null &    
    gcloud projects create $SERVICE_PROD --name="Service Project Prod" > /dev/null &
    gcloud projects create $HOST_QA --name="Host Project Qa" > /dev/null &
    gcloud projects create $SERVICE_QA --name="Service Project Qa" > /dev/null &
    gcloud projects create $HOST_DEV --name="Host Project Dev" > /dev/null &
    gcloud projects create $SERVICE_DEV --name="Service Project Dev" > /dev/null;
    
    gcloud beta billing projects link $HUB_PROJ --billing-account=$BILLING_ID &
    gcloud beta billing projects link $HOST_PROD --billing-account=$BILLING_ID & 
    gcloud beta billing projects link $SERVICE_PROD --billing-account=$BILLING_ID & 
    gcloud beta billing projects link $HOST_QA --billing-account=$BILLING_ID & 
    gcloud beta billing projects link $SERVICE_QA --billing-account=$BILLING_ID &
    gcloud beta billing projects link $HOST_DEV --billing-account=$BILLING_ID & 
    gcloud beta billing projects link $SERVICE_DEV --billing-account=$BILLING_ID;



    gcloud services enable orgpolicy.googleapis.com --project $HUB_PROJ &
    gcloud services enable orgpolicy.googleapis.com --project $HOST_PROD &
    gcloud services enable orgpolicy.googleapis.com --project $SERVICE_PROD &
    gcloud services enable orgpolicy.googleapis.com --project $HOST_QA &
    gcloud services enable orgpolicy.googleapis.com --project $SERVICE_QA &
    gcloud services enable orgpolicy.googleapis.com --project $HOST_DEV &
    gcloud services enable orgpolicy.googleapis.com --project $SERVICE_DEV &
    gcloud services enable compute.googleapis.com --project $HUB_PROJ &
    gcloud services enable compute.googleapis.com --project $HOST_PROD &
    gcloud services enable compute.googleapis.com --project $SERVICE_PROD &
    gcloud services enable compute.googleapis.com --project $HOST_QA &
    gcloud services enable compute.googleapis.com --project $SERVICE_QA &
    gcloud services enable compute.googleapis.com --project $HOST_DEV &
    gcloud services enable compute.googleapis.com --project $SERVICE_DEV ;
}




