# Lab 1 – Deep Dive: Using the Microsoft Graph and Entra PowerShell Commands

## Overview

This article covers basic topics in using the Microsoft Graph and Entra PowerShell commands.

## Find Required Permissions

```pwsh
Find-MgGraphCommand Get-MgSubscribedSku | select permissions
```

<img src='images/2025-10-16-04-31-32.png' width=700>

## List Available Permissions

```pwsh
Find-MgGraphPermission -SearchString Directory
```

<img src='images/2025-10-16-04-34-29.png' width=900>

You can also use `Find-EntraPermission`.

## Find Graph Commands

Use the formal wildcard regex `.*` to find commands.

```pwsh
Find-MgGraphCommand -Command .*userlicense.*
```

<img src='images/2025-10-16-04-38-36.png' width=1100>

[Find-MgGraphCommand](https://learn.microsoft.com/en-us/powershell/microsoftgraph/find-mg-graph-command?view=graph-powershell-1.0)