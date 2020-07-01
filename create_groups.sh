#!/bin/bash
#Create AD Groups
WEB_GROUP_NAME="aks-web-dev"
API_GROUP_NAME="aks-api-dev"
WEBDEV_ID=$(az ad group create --display-name $WEB_GROUP_NAME --mail-nickname $WEB_GROUP_NAME --query objectId -o tsv)
APIDEV_ID=$(az ad group create --display-name $API_GROUP_NAME --mail-nickname $API_GROUP_NAME --query objectId -o tsv)
RG_AKS="teamResources"
AKS_NAME="SecuredAKSCluster"

AKS_ID=$(az aks show \
    --resource-group $RG_AKS \
    --name $AKS_NAME \
    --query id -o tsv)

az role assignment create \
  --assignee $WEBDEV_ID \
  --role "Azure Kubernetes Service Cluster User Role" \
  --scope $AKS_ID

az role assignment create \
  --assignee $APIDEV_ID \
  --role "Azure Kubernetes Service Cluster User Role" \
  --scope $AKS_ID

#Assign users to groups
WEB_USER="webdev@OTAPRD1637ops.onmicrosoft.com"
API_USER="apidev@OTAPRD1637ops.onmicrosoft.com"

WEB_USER_ID=$(az ad user show --id $WEB_USER --query objectId -o tsv)
API_USER_ID=$(az ad user show --id $API_USER --query objectId -o tsv)

az ad group member add --group $WEB_GROUP_NAME --member-id $WEB_USER_ID
az ad group member add --group $API_GROUP_NAME --member-id $API_USER_ID


