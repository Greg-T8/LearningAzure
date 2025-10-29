#!/bin/bash
# Azure Policy Management Script
# Purpose: Create and manage Azure Policy definitions and assignments
# Lab 03 - Governance & Policies

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ==============================================================================
# Configuration
# ==============================================================================

echo -e "${CYAN}=== Getting Current Subscription ===${NC}"
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
SUBSCRIPTION_NAME=$(az account show --query name -o tsv)
echo -e "${CYAN}Using subscription: ${SUBSCRIPTION_NAME} (${SUBSCRIPTION_ID})${NC}"

# ==============================================================================
# Function: Create Custom Policy Definitions
# ==============================================================================

create_custom_policies() {
    echo -e "\n${GREEN}=== Creating Custom Policy Definitions ===${NC}"

    # Storage Account Naming Convention
    echo -e "${YELLOW}Creating Storage Account Naming Convention policy...${NC}"
    az policy definition create \
        --name 'storage-naming-convention' \
        --display-name 'Enforce Storage Account Naming Convention' \
        --description 'Storage account names must follow pattern: st<env><app><region><seq>' \
        --rules './storage-naming-policy.json' \
        --mode Indexed \
        --metadata category=Storage

    echo -e "${GREEN}✓ Created: storage-naming-convention${NC}"

    echo -e "${YELLOW}Custom policies created successfully${NC}"
}

# ==============================================================================
# Function: Assign Built-in Policies
# ==============================================================================

assign_builtin_policies() {
    echo -e "\n${GREEN}=== Assigning Built-in Policies ===${NC}"

    # Allowed Locations
    echo -e "${YELLOW}Assigning Allowed Locations policy...${NC}"
    az policy assignment create \
        --name 'allowed-locations-policy' \
        --display-name 'Allowed Locations - East US and West US Only' \
        --scope "/subscriptions/${SUBSCRIPTION_ID}" \
        --policy "e56962a6-4747-49cd-b67b-bf8b01975c4c" \
        --params '{
            "listOfAllowedLocations": {
                "value": ["eastus", "westus"]
            }
        }' \
        --description 'Restricts resource deployment to East US and West US regions'

    echo -e "${GREEN}✓ Assigned: Allowed Locations${NC}"

    # Require Tag on Resource Groups
    echo -e "${YELLOW}Assigning Require Tag on Resource Groups policy...${NC}"
    az policy assignment create \
        --name 'require-costcenter-tag-rg' \
        --display-name 'Require CostCenter Tag on Resource Groups' \
        --scope "/subscriptions/${SUBSCRIPTION_ID}" \
        --policy "96670d01-0a4d-4649-9c89-2d3abc0a5025" \
        --params '{
            "tagName": {
                "value": "CostCenter"
            }
        }'

    echo -e "${GREEN}✓ Assigned: Require Tag on Resource Groups${NC}"
}

# ==============================================================================
# Function: Assign Custom Policies
# ==============================================================================

assign_custom_policies() {
    echo -e "\n${GREEN}=== Assigning Custom Policies ===${NC}"

    # Storage Naming Convention
    echo -e "${YELLOW}Assigning Storage Naming Convention policy...${NC}"
    az policy assignment create \
        --name 'enforce-storage-naming' \
        --display-name 'Enforce Storage Naming Convention' \
        --scope "/subscriptions/${SUBSCRIPTION_ID}" \
        --policy 'storage-naming-convention'

    echo -e "${GREEN}✓ Assigned: Storage Naming Convention${NC}"
}

# ==============================================================================
# Function: Get Policy Compliance
# ==============================================================================

get_compliance_report() {
    echo -e "\n${GREEN}=== Policy Compliance Report ===${NC}"

    echo -e "${YELLOW}Fetching compliance data...${NC}"

    # Compliance summary
    echo -e "\n${CYAN}Compliance by Policy:${NC}"
    az policy state list --subscription "${SUBSCRIPTION_ID}" \
        --query "[].{Policy:policyAssignmentName, State:complianceState, Resource:resourceId}" \
        --output table
}

# ==============================================================================
# Function: Remove All Policy Assignments
# ==============================================================================

remove_all_assignments() {
    echo -e "\n${GREEN}=== Removing All Policy Assignments ===${NC}"

    ASSIGNMENTS=$(az policy assignment list --query "[].name" -o tsv)

    for assignment in $ASSIGNMENTS; do
        echo -e "${YELLOW}Removing: ${assignment}${NC}"
        az policy assignment delete --name "${assignment}"
    done

    echo -e "${GREEN}✓ All policy assignments removed${NC}"
}

# ==============================================================================
# Function: Remove Custom Policy Definitions
# ==============================================================================

remove_custom_policies() {
    echo -e "\n${GREEN}=== Removing Custom Policy Definitions ===${NC}"

    POLICIES=("storage-naming-convention")

    for policy in "${POLICIES[@]}"; do
        echo -e "${YELLOW}Removing: ${policy}${NC}"
        az policy definition delete --name "${policy}" 2>/dev/null || echo -e "  ${NC}Policy not found: ${policy}"
    done

    echo -e "${GREEN}✓ Custom policy definitions removed${NC}"
}

# ==============================================================================
# Main Menu
# ==============================================================================

show_menu() {
    echo -e "\n${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║          Azure Policy Management Script                   ║${NC}"
    echo -e "${CYAN}║          Lab 03 - Governance & Policies                   ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "  [1] Create Custom Policy Definitions"
    echo "  [2] Assign Built-in Policies"
    echo "  [3] Assign Custom Policies"
    echo "  [4] Get Policy Compliance Report"
    echo "  [5] Remove All Policy Assignments"
    echo "  [6] Remove Custom Policy Definitions"
    echo "  [7] Run All (Create & Assign)"
    echo "  [0] Exit"
    echo ""
}

# ==============================================================================
# Main Execution
# ==============================================================================

while true; do
    show_menu
    read -p "Select an option: " choice

    case $choice in
        1) create_custom_policies ;;
        2) assign_builtin_policies ;;
        3) assign_custom_policies ;;
        4) get_compliance_report ;;
        5) remove_all_assignments ;;
        6) remove_custom_policies ;;
        7)
            create_custom_policies
            assign_builtin_policies
            assign_custom_policies
            echo -e "\n${GREEN}✓ All policies created and assigned${NC}"
            ;;
        0)
            echo -e "\n${YELLOW}Exiting...${NC}"
            exit 0
            ;;
        *)
            echo -e "\n${RED}Invalid option. Please try again.${NC}"
            ;;
    esac

    if [ "$choice" != "0" ]; then
        echo -e "\n${NC}Press any key to continue...${NC}"
        read -n 1 -s
    fi
done
