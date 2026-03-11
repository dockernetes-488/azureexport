#!/bin/bash
set -e

echo "Starting Terraform export..."

BASE_DIR="terraform-export"
mkdir -p "$BASE_DIR"

RESOURCE_GROUPS=$(az group list --query "[].name" -o tsv)

for RG in $RESOURCE_GROUPS
do
  echo "Processing Resource Group: $RG"

  RG_DIR="$BASE_DIR/$RG"
  mkdir -p "$RG_DIR"

  RESOURCE_IDS=$(az resource list --resource-group "$RG" --query "[].id" -o tsv)

  for RESOURCE_ID in $RESOURCE_IDS
  do
    RESOURCE_NAME=$(basename "$RESOURCE_ID")

    echo "Exporting Resource: $RESOURCE_NAME"

    RESOURCE_DIR="$RG_DIR/$RESOURCE_NAME"
    mkdir -p "$RESOURCE_DIR"

    cd "$RESOURCE_DIR"

    az terraform export-terraform \
      --full-properties full \
      --target-provider azapi \
      --export-resource "{\"resourceIds\":[\"$RESOURCE_ID\"]}" \
      --query properties.configuration \
      -o tsv > main.tf

    cd - > /dev/null
  done
done

echo "Terraform export completed!"
