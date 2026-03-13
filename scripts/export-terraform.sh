#!/bin/bash
set -e

echo "Starting Terraform export using aztfexport..."

BASE_DIR="terraform-export"
mkdir -p "$BASE_DIR"

# Get subscription id
SUB_ID=$(az account show --query id -o tsv)

# Get all resource groups
RESOURCE_GROUPS=$(az group list --query "[].name" -o tsv)

for RG in $RESOURCE_GROUPS
do
  echo "Processing Resource Group: $RG"

  RG_DIR="$BASE_DIR/$RG"
  mkdir -p "$RG_DIR"

  cd "$RG_DIR"

  RG_ID="/subscriptions/$SUB_ID/resourceGroups/$RG"

  echo "Exporting resources from $RG_ID..."

  yes Y | aztfexport resource-group "$RG_ID" --hcl-only

  cd - > /dev/null
done

echo "Terraform export completed successfully!"
