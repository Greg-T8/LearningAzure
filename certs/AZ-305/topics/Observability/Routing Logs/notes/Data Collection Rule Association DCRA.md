# Data Collection Rule Association (DCRA)

## Meaning

A **data collection rule association (DCRA)** is the Azure Monitor control-plane association that connects a monitored Azure resource to a data collection rule (DCR).

The DCR defines the collection architecture—what data to collect, processing or transformations to apply, and the destination. The DCRA assigns that rule to a resource so the collection scenario can operate.

```text
Monitored resource ── DCRA ──> DCR ──> collect / transform / route data
```

## How it works

The association is created as a child resource beneath the monitored resource:

```text
<resource>
  /providers/Microsoft.Insights/dataCollectionRuleAssociations/<association-name>
```

Its properties can reference a `dataCollectionRuleId` and, where required, a `dataCollectionEndpointId`.

For AMA over Private Link, a DCRA can also associate the monitored resource with a DCE for configuration access:

```text
VM or cluster
 ├─ DCRA → DCR → collection definition
 └─ DCRA → DCE → private configuration-access endpoint
```

The DCR association and the DCE configuration-access association are related but serve different purposes.

## Requirements and constraints

- A single DCR can be associated with multiple resources, and a resource can be associated with up to **30 DCRs**.
- A DCRA is not itself a DCR; it contains the relationship between the resource and the rule.
- The monitored resource must support the relevant DCR-based collection scenario.
- For AMA Private Link configuration access, associate the VM or cluster with a DCE and add that DCE to the AMPLS. Each VM or cluster can have only **one configuration-access DCE association**; creating another replaces the existing association.
- The configuration-access DCE should be in the same region as the monitored resource.
- The association does not provide network connectivity. Private endpoints, AMPLS membership, DNS, identity, and authorization remain separate requirements.

## What it does not do

- It does not install Azure Monitor Agent.
- It does not define the data collection, transformation, or destination; those belong in the DCR.
- It does not store or transport telemetry.
- It does not by itself make an endpoint private.

## Failure behavior or troubleshooting

1. Confirm the DCRA references the intended DCR and monitored resource.
2. Check that the DCR contains a compatible data source, data flow, and destination.
3. For AMA, verify the agent is installed and healthy.
4. For Private Link configuration access, verify the DCE association, AMPLS membership, private endpoint, and DNS resolution.
5. If the resource already has 30 DCR associations, remove or consolidate an association before adding another.

## Example

A VM needs Windows event logs and performance counters sent to Log Analytics. Create one DCR containing those data sources and a Log Analytics destination, then create a DCRA from the VM to that DCR. If the VM uses AMA with Private Link, create a separate configuration-access DCRA to the appropriate DCE.

## AZ-305 exam takeaway

> DCR = the collection policy; DCRA = the assignment of that policy to a resource; DCE = the endpoint used for collection/configuration connectivity.

## Common trap

Do not confuse “a resource can have multiple DCR associations” with “a resource can have multiple configuration-access DCE associations.” The current AMA Private Link guidance allows up to 30 DCR associations, but only one configuration-access DCE association per VM or cluster.

## Microsoft sources

- [Data collection rules in Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/data-collection/data-collection-rule-overview)
- [Data Collection Rule Associations — Create](https://learn.microsoft.com/en-us/rest/api/monitor/data-collection-rule-associations/create?view=rest-monitor-2024-03-11)
- [Azure CLI: data-collection rule association](https://learn.microsoft.com/en-us/cli/azure/monitor/data-collection/rule/association?view=azure-cli-latest)
- [Enable Private Link for monitoring VMs and Kubernetes clusters](https://learn.microsoft.com/en-us/azure/azure-monitor/fundamentals/private-link-vm-kubernetes)
