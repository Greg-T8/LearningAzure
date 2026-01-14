# Lab 1 – Deep Dive: Advanced User Management with the `az` Command

<!-- omit in toc -->
## 🧾 Contents

* [Overview](#overview)
* [Show login context](#show-login-context)
* [Create user (simple)](#create-user-simple)
* [Remove user](#remove-user)
* [Create user (advanced)](#create-user-advanced)

## Overview

This deep dive explores advanced user management with the Azure CLI (`az` command). It covers limitations of using double quotes in PowerShell with the `az` command executable.

## Show login context

```pwsh
az account show
```

<img src='../.img/2025-10-09-03-38-58.png' width=400>

## Create user (simple)

```pwsh
az ad user create `
 --display-name "Alex Smith" `
 --user-principal-name 'user1@637djb.onmicrosoft.com' `
 --password "P@ssword123!" `
 --force-change-password-next-sign-in
```

## Remove user

```pwsh
az ad user delete --id 'user1@637djb.onmicrosoft.com'
```

## Create user (advanced)

To create a new Azure AD user with both `givenName` and `surname` using the
Azure CLI, you’ll need to use the Microsoft Graph REST API via `az rest`,
because the standard `az ad` user create command does not directly support all
user properties.

The `az rest` command allows you to make direct REST API calls to Microsoft
Graph and has the following syntax:

```pwsh
$body = @'
{
  "accountEnabled": true,
  "displayName": "Alex Smith",
  "mailNickname": "alexs",
  "userPrincipalName": "user1@637djb.onmicrosoft.com",
  "givenName": "Alex",
  "surname": "Smith",
  "passwordProfile": {
    "forceChangePasswordNextSignIn": true,
    "password": "P@ssword123!"
  }
}
'@
az rest --method post --url 'https://graph.microsoft.com/v1.0/users' --body $json
```

However, this command fails due to a known quoting issue in PowerShell. See
 [Double quotes `""` are lost](https://github.com/Azure/azure-cli/blob/dev/doc/quoting-issues-with-powershell.md#double-quotes--are-lost).

As a result, the best practice is to use Azure CLI's `@<file>` convention to
load from a file to bypass the shell's interpretation.

```pwsh
# Source JSON (here-string)
$body = @'
{
  "accountEnabled": true,
  "displayName": "Alex Smith",
  "mailNickname": "alexs",
  "userPrincipalName": "user1@637djb.onmicrosoft.com",
  "givenName": "Alex",
  "surname": "Smith",
  "passwordProfile": {
    "forceChangePasswordNextSignIn": true,
    "password": "P@ssword123!"
  }
}
'@

# Validate & compress to a single-line JSON string
$json = $body | ConvertFrom-Json | ConvertTo-Json -Depth 5 -Compress

# Create a unique temp file path (works across PS versions)
$tempPath = Join-Path ([System.IO.Path]::GetTempPath()) ("user-" + [guid]::NewGuid().ToString() + ".json")

# Write JSON to temp file (UTF-8, no BOM)
Set-Content -Path $tempPath -Value $json -Encoding utf8

# Ensure cleanup even if az fails
$exit = 0
try {
    # IMPORTANT: Use --url (not --uri) and quote the @file syntax
    & az rest `
        --method post `
        --url "https://graph.microsoft.com/v1.0/users" `
        --headers "Content-Type=application/json" `
        --body "@$tempPath" `
        --debug

    $exit = $LASTEXITCODE
}
finally {
    # Always delete the temp file
    if (Test-Path $tempPath) {
        Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
    }
}

# Bubble up az exit code if non-zero (useful in CI)
if ($exit -ne 0) {
    throw "az rest exited with code $exit"
}

```

See the following scripts for adding and deleting multiple users:

* [CreateUsersAzCli.ps1](../../powershell/CreateUsersAzCli.ps1)
* [DeleteUsersAzCli.ps1](../../powershell/DeleteUsersAzCli.ps1)
* [AzCliUsers.json](../../powershell/AzCliUsers.json)

See the following references for more information on the quoting issue in PowerShell:  

* [Quoting issues with PowerShell](https://github.com/Azure/azure-cli/blob/dev/doc/quoting-issues-with-powershell.md)

* [Tips for using Azure CLI effectively](https://learn.microsoft.com/en-us/cli/azure/use-azure-cli-successfully-tips?view=azure-cli-latest&tabs=bash%2Ccmd2)
* [Error: Failed to parse string as JSON](https://learn.microsoft.com/en-us/cli/azure/use-azure-cli-successfully-troubleshooting?view=azure-cli-latest#error-failed-to-parse-string-as-json)
* [How to use shorthand syntax with Azure CLI](https://learn.microsoft.com/en-us/cli/azure/use-azure-cli-successfully-shorthand?view=azure-cli-latest)

* [Error: Failed to parse string as JSON](https://learn.microsoft.com/en-us/cli/azure/use-azure-cli-successfully-troubleshooting?view=azure-cli-latest#error-failed-to-parse-string-as-json)

    <img src='../.img/2025-10-09-05-07-10.png' width=600>

* [Quoting differences in Azure CLI](https://learn.microsoft.com/en-us/cli/azure/use-azure-cli-successfully-quoting?view=azure-cli-latest&tabs=bash1%2Cbash2%2Cbash3#json-strings)

    <img src='../.img/2025-10-09-05-09-29.png' width=600>

* [Scripting language rules](https://learn.microsoft.com/en-us/cli/azure/use-azure-cli-successfully-quoting?view=azure-cli-latest&tabs=bash1%2Cpowershell2%2Cbash3#scripting-language-rules)

    <img src='../.img/2025-10-09-05-11-23.png' width=600>

* [Considerations for running the Azure CLI in a PowerShell scripting language](https://learn.microsoft.com/en-us/cli/azure/use-azure-cli-successfully-powershell?view=azure-cli-latest&tabs=read%2Cwin2%2CBash2#pass-parameters-containing-json)

    <img src='../.img/2025-10-09-05-13-43.png' width=600>
