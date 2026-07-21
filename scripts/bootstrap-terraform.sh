#!/usr/bin/env bash

set -euo pipefail

LOCATION="swedencentral"

GITHUB_ORG="haveng"
GITHUB_REPO="ordinus"

TFSTATE_RESOURCE_GROUP="rg-medalj-tfstate"
TFSTATE_CONTAINER="tfstate"

APP_NAME="github-medalj-terraform"

SUBSCRIPTION_ID=$(az account show --query id --output tsv)
TENANT_ID=$(az account show --query tenantId --output tsv)

echo "Subscription: $SUBSCRIPTION_ID"
echo "Tenant:       $TENANT_ID"

# Storage Account names must be globally unique.
RANDOM_SUFFIX=$(openssl rand -hex 4)
TFSTATE_STORAGE_ACCOUNT="stmedaljtf${RANDOM_SUFFIX}"

echo "Creating Terraform state resource group..."

az group create \
  --name "$TFSTATE_RESOURCE_GROUP" \
  --location "$LOCATION"

echo "Creating Terraform state storage account..."

az storage account create \
  --name "$TFSTATE_STORAGE_ACCOUNT" \
  --resource-group "$TFSTATE_RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false

echo "Creating Terraform state container..."

az storage container create \
  --name "$TFSTATE_CONTAINER" \
  --account-name "$TFSTATE_STORAGE_ACCOUNT" \
  --auth-mode login

echo "Creating Microsoft Entra application..."

APP_ID=$(az ad app create \
  --display-name "$APP_NAME" \
  --query appId \
  --output tsv)

echo "Creating service principal..."

az ad sp create \
  --id "$APP_ID"

OBJECT_ID=$(az ad sp show \
  --id "$APP_ID" \
  --query id \
  --output tsv)

SUBSCRIPTION_SCOPE="/subscriptions/$SUBSCRIPTION_ID"

echo "Assigning Contributor..."

az role assignment create \
  --assignee-object-id "$OBJECT_ID" \
  --assignee-principal-type ServicePrincipal \
  --role "Contributor" \
  --scope "$SUBSCRIPTION_SCOPE"

echo "Assigning Role Based Access Control Administrator..."

az role assignment create \
  --assignee-object-id "$OBJECT_ID" \
  --assignee-principal-type ServicePrincipal \
  --role "Role Based Access Control Administrator" \
  --scope "$SUBSCRIPTION_SCOPE"

echo "Giving Terraform access to its state..."

STORAGE_SCOPE=$(az storage account show \
  --name "$TFSTATE_STORAGE_ACCOUNT" \
  --resource-group "$TFSTATE_RESOURCE_GROUP" \
  --query id \
  --output tsv)

az role assignment create \
  --assignee-object-id "$OBJECT_ID" \
  --assignee-principal-type ServicePrincipal \
  --role "Storage Blob Data Contributor" \
  --scope "$STORAGE_SCOPE"

echo "Creating GitHub OIDC federated credential..."

cat > federated-credential.json <<EOF
{
  "name": "github-main",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:${GITHUB_ORG}/${GITHUB_REPO}:ref:refs/heads/main",
  "audiences": [
    "api://AzureADTokenExchange"
  ]
}
EOF

az ad app federated-credential create \
  --id "$APP_ID" \
  --parameters federated-credential.json

rm federated-credential.json

echo ""
echo "Bootstrap complete."
echo ""
echo "GitHub variables:"
echo "AZURE_CLIENT_ID=$APP_ID"
echo "AZURE_TENANT_ID=$TENANT_ID"
echo "AZURE_SUBSCRIPTION_ID=$SUBSCRIPTION_ID"
echo "TFSTATE_RESOURCE_GROUP=$TFSTATE_RESOURCE_GROUP"
echo "TFSTATE_STORAGE_ACCOUNT=$TFSTATE_STORAGE_ACCOUNT"
echo "TFSTATE_CONTAINER=$TFSTATE_CONTAINER"
