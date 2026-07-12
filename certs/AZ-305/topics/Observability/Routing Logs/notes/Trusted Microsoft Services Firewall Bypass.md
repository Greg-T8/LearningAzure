# Trusted Microsoft Services Firewall Bypass for Diagnostic Settings

## Meaning

When an Azure Storage account or Event Hubs namespace has its firewall enabled, Azure Monitor's diagnostic-settings service must be allowed through that firewall so it can deliver logs and metrics.

Azure Monitor sends this data from Microsoft-operated service infrastructure. The traffic does not originate from the monitored resource's subnet and does not enter through the destination's private endpoint. Because there is no individual source IP address to allow, the destination must enable the trusted-services firewall exception.

In the portal, this setting is commonly labeled:

> Allow Azure services on the trusted services list to access this storage account/namespace.

## Traffic path

```text
Azure resource
    │
    │ Diagnostic setting
    ▼
Azure Monitor diagnostic-settings service
    │
    │ Trusted Microsoft services firewall exception
    ▼
Firewalled Storage account or Event Hubs namespace
```

## What the bypass does

- Allows eligible Microsoft-managed services, including Azure Monitor diagnostic settings, through the Storage or Event Hubs network firewall.
- Keeps the destination closed to arbitrary public internet traffic.
- Applies only to services on the destination service's trusted-services list.
- Bypasses the network firewall only; normal authentication and authorization requirements still apply.

For Event Hubs, the diagnostic route also needs an authorization rule with `Manage`, `Send`, and `Listen` permissions. The identity configuring the diagnostic setting needs `ListKey` access to that rule.

## What it does not do

- It does not grant every Azure resource access to the destination.
- It does not replace RBAC, shared access policies, or other authorization controls.
- It does not route diagnostic-settings traffic through a private endpoint.
- It does not make a cross-region Storage or Event Hubs destination valid for a regional source.

## Private endpoint distinction

A private endpoint gives clients in an authorized virtual network a private IP path to Storage or Event Hubs. Azure Monitor's diagnostic-settings delivery service is not one of those VNet clients and does not use that endpoint for this delivery path.

Therefore:

```text
Private endpoint configured
        ≠
Diagnostic settings can write through the firewall
```

The trusted-services bypass is still required when the destination firewall is enabled.

## Failure behavior

If the bypass is disabled, the diagnostic setting can still exist and appear correctly configured, but Azure Monitor may be unable to deliver records to the destination. Configuration compliance therefore does not prove successful data flow.

Troubleshooting should verify:

1. The monitored resource is generating the selected log category.
2. The Storage account or Event Hubs namespace is in the required region.
3. The trusted-services firewall bypass is enabled.
4. The Event Hubs authorization rule has the required permissions, if applicable.
5. Records are actually arriving at the destination.

## AZ-305 exam takeaway

> Diagnostic settings + firewalled Storage or Event Hubs = enable the trusted Microsoft services firewall bypass.

Do not choose "configure only a private endpoint" as the complete solution. The private endpoint and trusted-services bypass solve different access paths.

## Microsoft source

- [Diagnostic settings in Azure Monitor — destinations](https://learn.microsoft.com/en-us/azure/azure-monitor/platform/diagnostic-settings#destinations)
