#!/bin/bash
# Lab 02 - RBAC Role Assignment Scripts
# Purpose: Assign roles at different scopes using Azure CLI

# Prerequisites: Sign in to Azure
# az login

# ============================================================================
# VARIABLES - Update these for your environment
# ============================================================================
SUBSCRIPTION_ID=$(az account show --query id --output tsv)
RESOURCE_GROUP_NAME="rg-dev-test"
LOCATION="eastus"
USER_PRINCIPAL_NAME="user1@637djb.onmicrosoft.com"
GROUP_NAME="Dev-Team"

# ============================================================================
# FUNCTION: Assign Role at Subscription Scope
# ============================================================================
assign_role_at_subscription() {
    local principal_name=$1
    local role_name=$2
    local principal_type=$3  # User, Group, ServicePrincipal

    echo "Assigning $role_name to $principal_name at subscription scope..."

    if [ "$principal_type" == "User" ]; then
        assignee=$principal_name
    elif [ "$principal_type" == "Group" ]; then
        assignee=$(az ad group show --group "$principal_name" --query id --output tsv)
    fi

    az role assignment create \
        --assignee "$assignee" \
        --role "$role_name" \
        --scope "/subscriptions/$SUBSCRIPTION_ID"

    echo "✅ Role assigned successfully"
}

# ============================================================================
# FUNCTION: Assign Role at Resource Group Scope
# ============================================================================
assign_role_at_resource_group() {
    local principal_name=$1
    local role_name=$2
    local resource_group=$3
    local principal_type=$4

    echo "Assigning $role_name to $principal_name at resource group scope..."

    if [ "$principal_type" == "User" ]; then
        assignee=$principal_name
    elif [ "$principal_type" == "Group" ]; then
        assignee=$(az ad group show --group "$principal_name" --query id --output tsv)
    fi

    az role assignment create \
        --assignee "$assignee" \
        --role "$role_name" \
        --resource-group "$resource_group"

    echo "✅ Role assigned successfully"
}

# ============================================================================
# FUNCTION: List Role Assignments
# ============================================================================
get_role_assignment_report() {
    local scope=$1
    local resource_group=$2

    echo "Generating Role Assignment Report..."

    if [ "$scope" == "Subscription" ]; then
        az role assignment list \
            --all \
            --query "[].{Name:principalName, Role:roleDefinitionName, Type:principalType, Scope:scope}" \
            --output table
    else
        az role assignment list \
            --resource-group "$resource_group" \
            --query "[].{Name:principalName, Role:roleDefinitionName, Type:principalType, Scope:scope}" \
            --output table
    fi
}

# ============================================================================
# FUNCTION: Remove Role Assignment
# ============================================================================
remove_role_from_principal() {
    local principal_name=$1
    local role_name=$2
    local scope=$3
    local principal_type=$4

    echo "Removing $role_name from $principal_name..."

    if [ "$principal_type" == "User" ]; then
        assignee=$principal_name
    elif [ "$principal_type" == "Group" ]; then
        assignee=$(az ad group show --group "$principal_name" --query id --output tsv)
    fi

    az role assignment delete \
        --assignee "$assignee" \
        --role "$role_name" \
        --scope "$scope"

    echo "✅ Role removed successfully"
}

# ============================================================================
# EXAMPLE USAGE
# ============================================================================

# Example 1: Assign Reader at subscription scope
# assign_role_at_subscription "$USER_PRINCIPAL_NAME" "Reader" "User"

# Example 2: Assign Contributor at resource group scope
# Ensure resource group exists
# az group create --name "$RESOURCE_GROUP_NAME" --location "$LOCATION"
# assign_role_at_resource_group "$GROUP_NAME" "Contributor" "$RESOURCE_GROUP_NAME" "Group"

# Example 3: View role assignments
# get_role_assignment_report "Subscription"
# get_role_assignment_report "ResourceGroup" "$RESOURCE_GROUP_NAME"

# Example 4: Remove role assignment
# remove_role_from_principal "$USER_PRINCIPAL_NAME" "Reader" "/subscriptions/$SUBSCRIPTION_ID" "User"

echo ""
echo "✅ Script loaded. Use the functions above to manage RBAC."
echo "Example: assign_role_at_subscription 'user@domain.com' 'Reader' 'User'"
