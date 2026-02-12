# Lab: Azure Monitor Alert Notification Rate Limits

## Exam Reference

- **Source**: AZ-104 Practice Exam - Azure Monitor
- **Domain**: Monitor and Backup Azure Resources
- **Topic**: Azure Monitor Alerts and Action Groups

## Scenario

You have an Azure subscription named **Subscription1**. You create an alert rule in Azure Monitor named **Alert1**. Alert1 is configured to generate email, voice, and SMS alerts. You determine that Alert1 fires every minute.

You configure an action group for Alert1 to manage how often alert notifications are sent. You need to determine how many alert notifications will be sent when rate limits are configured at their maximum values.

**Question**: How many alert notifications will be generated for each type of alert per hour?

## Azure Notification Rate Limits

| Notification Type | Rate Limit | Max per Hour | Notes |
|-------------------|------------|--------------|-------|
| Email | 100 per hour | 100 | Per action group |
| Voice | 1 per 5 minutes | 12 | Max 5 per hour total |
| SMS | 1 per 5 minutes | 12 | Per phone number |

## Answer Analysis

Given Alert1 fires **60 times per hour** (once per minute):

| Alert Type | Rate Limit | Notifications Sent/Hour | Explanation |
|------------|------------|-------------------------|-------------|
| **Email** | 100/hour | **60** | All 60 alerts get emails (under 100 limit) |
| **Voice** | 5/hour | **5** | Only 5 voice calls allowed per hour |
| **SMS** | 1 per 5 min | **12** | Max 12 SMS per hour (1 every 5 minutes) |

⚠️ **Exam Note**: Some practice exams may show slightly different values. The documented Azure limits are:

- Email: No more than 100 emails per hour
- Voice: No more than 5 voice calls per hour
- SMS: No more than 1 SMS every 5 minutes (12 per hour)

## Objectives

1. Deploy an alert rule that fires every minute using a metric condition
2. Configure an action group with email, voice, and SMS notifications
3. Observe the rate limiting behavior in Azure Monitor
4. Understand how Azure throttles notifications to prevent flooding

## Prerequisites

- Azure subscription
- Terraform CLI installed
- Azure CLI authenticated (`az login`)
- Valid email address, phone number for SMS, and phone number for voice

---

## Terraform Deployment

## First-Time Setup

```powershell
cd terraform

# Copy the tfvars template and configure your settings
Copy-Item ..\..\..\..\..\..\..\..\..\..\assets\shared\terraform\terraform.tfvars.template .\terraform.tfvars

# Edit terraform.tfvars with your values:
# - lab_subscription_id = "your-subscription-id"
# - email_address = "your-email@example.com"
# - sms_phone_number = "+1234567890"
# - voice_phone_number = "+1234567890"
```

## Deploy

```powershell
cd terraform

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Deploy the resources
terraform apply
```

## Validate

1. Navigate to **Azure Monitor** → **Alerts** in the Azure Portal
2. View the alert rule and its action group configuration
3. Check **Monitor** → **Action groups** to see notification settings
4. Wait for alerts to fire and observe the rate-limited notifications

### Generate Test Alerts

```powershell
# Get the VM resource ID from Terraform output
$vmId = terraform output -raw vm_resource_id

# The alert is configured to fire when CPU > 0% (always true)
# This simulates an alert that fires every minute for testing rate limits
```

### Check Alert History

```powershell
# View fired alerts in the portal:
# Monitor → Alerts → Alert history

# Or via Azure CLI:
az monitor metrics alert show --name "Alert1" --resource-group (terraform output -raw resource_group_name)
```

## Cleanup

```powershell
terraform destroy -auto-approve
```

---

## Key Concepts

### Action Group Rate Limits

Azure enforces rate limits to prevent notification flooding:

1. **Email Rate Limit**: Maximum 100 emails per hour per action group
2. **Voice Rate Limit**: Maximum 5 voice calls per hour
3. **SMS Rate Limit**: Maximum 1 SMS per 5 minutes (12 per hour)

### When Rate Limits Apply

- Rate limits are per action group, not per alert rule
- Voice and SMS share stricter limits due to carrier costs
- Email has a higher limit but is still throttled

### Exam Tips

- Remember: Voice = 5/hour, SMS = 12/hour (1 per 5 min), Email = 100/hour
- If an alert fires more frequently than the rate limit allows, excess notifications are suppressed
- Rate limits protect both users and Azure infrastructure from alert storms

---

## Related Documentation

- [Action groups](https://learn.microsoft.com/azure/azure-monitor/alerts/action-groups)
- [Rate limiting for voice, SMS, emails](https://learn.microsoft.com/azure/azure-monitor/alerts/action-groups#rate-limiting)
- [Azure Monitor alerts overview](https://learn.microsoft.com/azure/azure-monitor/alerts/alerts-overview)

## Related Labs

*No related labs exist yet in this domain.*
