#!/bin/bash

# Vault KV Path where the TFC Token and Address is stored, if these values are to be obtained from Vault
#export VAULT_TFE_TOKEN_PATH=${VAULT_TFE_TOKEN_PATH:-kv/tfe/app.terraform.io}

# Use TFE_TOKEN and TFE_ADDR as defined in the environment, or obtain from Vault at $VAULT_TFE_TOKEN_PATH
#export TFE_TOKEN=${TFE_TOKEN:-$(vault kv get -field TFE_USER_TOKEN ${VAULT_TFE_TOKEN_PATH})}
#export TFE_ADDR=${TFE_ADDR:-$(vault kv get -field TFE_ADDR ${VAULT_TFE_TOKEN_PATH})}

# Obtain TFE_TOKEN and TFE_ADDR as defined in the environment
export TFE_TOKEN=${TFE_TOKEN:-NOT_SET}
export TFE_ADDR=${TFE_ADDR:-https://app.terraform.io}

# TFE_TOKEN must be passed from environment
if [ "${TFE_TOKEN}" == "NOT_SET" ]
then
  echo "ERROR: Please set TFE_TOKEN to your Terraform Cloud Bearer Token"
  exit 1
fi

total_workspace_counter=0
for org in $(
  curl \
    -s \
    --header "Authorization: Bearer ${TFE_TOKEN}" \
    --header "Content-Type: application/vnd.api+json" \
    ${TFE_ADDR}/api/v2/organizations | \
    jq -r .data[].id
)
do
  echo "Org: $org"
  echo "  Workspaces:"
  workspace_counter_current=0
  workspaces=$(
    curl \
      -s \
      --header "Authorization: Bearer ${TFE_TOKEN}" \
      --header "Content-Type: application/vnd.api+json" \
      ${TFE_ADDR}/api/v2/organizations/$org/workspaces | \
      jq -r '.data[] | "\(.id)###\(.attributes.name)"' )
  for workspace in $workspaces
  do
    workspace_counter_current=$(expr ${workspace_counter_current} + 1)
    total_workspace_counter=$(expr ${total_workspace_counter} + 1)
    echo $workspace | awk -F### '{print "    " $1 "\t" $2}'
  done
  echo "--------------------------------------------------------------------------------"
  echo "Subtotal: ${workspace_counter_current}"
  echo
done

echo "Total workspaces: ${total_workspace_counter}"
