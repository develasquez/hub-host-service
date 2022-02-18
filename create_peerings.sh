#!/bin/bash
# This is not an official Google project.

#This script is for educational purposes only, is not certified and is not recommended for production environments.

## Copyright 2021 Google LLC
#Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

#  http://www.apache.org/licenses/LICENSE-2.0
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


create_peerings() {
    #https://cloud.google.com/vpc/docs/using-vpc-peering
    PROJECT_ID=$1
    NETWORK=$2
    PEER_PROJECT_ID=$3
    PEER_NETWORK_NAME=$4

    gcloud compute networks peerings create $PEER_NETWORK_NAME-peering \
    --network=$NETWORK \
    --peer-project $PEER_PROJECT_ID \
    --peer-network $PEER_NETWORK_NAME \
    --import-custom-routes \
    --export-custom-routes \
    --project $PROJECT_ID;
}