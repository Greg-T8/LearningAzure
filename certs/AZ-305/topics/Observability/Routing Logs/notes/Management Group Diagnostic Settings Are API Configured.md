# Management Group Diagnostic Settings Are API Configured

## Meaning

A diagnostic setting at **management-group scope** exports Azure Monitor activity-log events for that management group and the management groups beneath it in the hierarchy. Microsoft documents creation and management of this scope through the dedicated Azure Resource Manager REST API; it is not configured through the normal Azure portal diagnostic-settings experience.

## How it works

```text
Highest management group
        │
        │ Management Group Diagnostic Settings REST API
        ▼
Diagnostic setting ──► Log Analytics workspace, Storage account, and/or Event Hubs
        │
        └─► Activity-log events from this management group and descendant management groups
```

The API creates a `Microsoft.Insights/diagnosticSettings` resource at this scope:

`/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.Insights/diagnosticSettings/{name}`

The documented API version is `2020-01-01-preview`. It supports destinations in Log Analytics, Azure Storage, and Azure Event Hubs.

## Requirements and constraints

- Configure the diagnostic setting on the highest management group whose hierarchy you want to collect. Its scope includes child management groups.
- Avoid overlapping management-group settings: each additional setting higher or lower in the hierarchy can create duplicate activity-log events.
- A subscription-level activity-log diagnostic setting can also overlap with the management-group setting and produce duplicates for events common to both scopes.
- The portal can display management-group activity logs, but Microsoft’s portal diagnostic-setting instructions are for normal resource or subscription activity-log export; the dedicated management-group configuration documentation is REST API based.

## What it does not do

- It does not use the ordinary Azure portal **Export Activity Logs** workflow to create a management-group-scoped diagnostic setting.
- It does not remove the need to choose and authorize a destination such as a Log Analytics workspace, Storage account, or Event Hubs.

## Example

An organization needs policy-assignment and management-group membership activity across `Corp` and all child management groups in one Log Analytics workspace. It creates one management-group diagnostic setting on `Corp` through ARM REST (or an ARM-compatible deployment/tool that calls that API), rather than creating equivalent settings on every child group.

## AZ-305 exam takeaway

> To centrally export activity logs for a management-group hierarchy, configure one management-group diagnostic setting at the highest required scope through the management-group REST API—not the standard portal export workflow.

## Common trap

Assuming that the portal's activity-log or diagnostic-settings blades can configure the management-group scope because they can display management-group events. Viewing events in the portal and configuring management-group diagnostic export are separate capabilities.

## Microsoft sources

- [Management group diagnostic settings: Create or update (REST API)](https://learn.microsoft.com/en-us/rest/api/monitor/management-group-diagnostic-settings/create-or-update?view=rest-monitor-2020-01-01-preview)
- [Management groups — auditing by using activity logs](https://learn.microsoft.com/en-us/azure/governance/management-groups/overview#auditing-management-groups-by-using-activity-logs)
- [Azure Monitor activity log — export management-group activity logs](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/activity-log#export-management-group-activity-logs)
- [Diagnostic settings in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings)
