#!/bin/bash

# This is not an official Google project.

#This script is for educational purposes only, is not certified and is not recommended for production environments.

## Copyright 2021 Google LLC
#Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

#  http://www.apache.org/licenses/LICENSE-2.0
#Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.



source utils.sh;

gcloud organizations add-iam-policy-binding $ORG_ID \
  --member=user:$USER \
  --role="roles/compute.xpnAdmin" > /dev/null;


set_org_policies() {

PROJECT_ID=$1;
PROJECT_NUMBER=$(get_project_number $1);

#Step 4: Enable Organization Policies 
echo $PROJECT_ID - $PROJECT_NUMBER

cat > os_login.yaml << ENDOFFILE
name: projects/$PROJECT_NUMBER/policies/compute.requireOsLogin
spec:
  rules:
  - enforce: false
ENDOFFILE



cat > shieldedVm.yaml << ENDOFFILE
name: projects/$PROJECT_NUMBER/policies/compute.requireShieldedVm
spec:
  rules:
  - enforce: false
ENDOFFILE

cat > vmCanIpForward.yaml << ENDOFFILE
name: projects/$PROJECT_NUMBER/policies/compute.vmCanIpForward
spec:
  rules:
  - allowAll: true
ENDOFFILE


#cat > vmExternalIpAccess.yaml << ENDOFFILE
#name: projects/$PROJECT_NUMBER/policies/compute.vmExternalIpAccess
#spec:
#  rules:
#  - allowAll: true
#ENDOFFILE

#gcloud org-policies set-policy vmExternalIpAccess.yaml --project $PROJECT_ID > /dev/null;

cat > restrictVpcPeering.yaml << ENDOFFILE
name: projects/$PROJECT_NUMBER/policies/compute.restrictVpcPeering
spec:
  rules:
  - allowAll: true
ENDOFFILE
gcloud org-policies set-policy os_login.yaml --project $PROJECT_ID > /dev/null &
gcloud org-policies set-policy shieldedVm.yaml --project $PROJECT_ID > /dev/null &
gcloud org-policies set-policy vmCanIpForward.yaml --project $PROJECT_ID > /dev/null &
gcloud org-policies set-policy restrictVpcPeering.yaml --project $PROJECT_ID > /dev/null;


}

clean_policies_files() {
  rm os_login.yaml shieldedVm.yaml vmCanIpForward.yaml restrictVpcPeering.yaml;
}