#!/bin/bash
set -e

echo "Starting Terraform export using aztfexport..."

BASE_DIR="terraform-export"
mkdir -p "$BASE_DIR"

# Get all resource groups
RESOURCE_GROUPS=$(az group list --query "[].name" -o tsv)

for RG in $RESOURCE_GROUPS
do
  echo "Processing Resource Group: $RG"

  RG_DIR="$BASE_DIR/$RG"
  mkdir -p "$RG_DIR"

  cd "$RG_DIR"

  echo "Exporting resources from $RG..."

  # Export resource group terraform configuration
  yes Y | aztfexport resource-group "$RG" \
      --hcl-only

  cd - > /dev/null
done

echo "Terraform export completed successfully!"
