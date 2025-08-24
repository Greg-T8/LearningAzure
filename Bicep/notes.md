# Azure Bicep

## Microsoft Learning Paths
- [Part 1: Fundamentals of Bicep](https://learn.microsoft.com/en-us/training/paths/fundamentals-bicep/)
    - [Learning Module 1: Build your first Bicep file (Notes)](./LP1%20-%20Fundamentals/LM1/notes.md)
    - [Learning Module 2: Build reusable Bicep files by using parameters (Notes)](LP1%20-%20Fundamentals/LM2/notes.md)
    - [Learning Module 3: Build flexible Bicep files by using conditions and loops (Notes)](./LP1%20-%20Fundamentals/LM3/notes.md)

## References
- [Create Bicep files - VS Code](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/quickstart-create-bicep-use-visual-studio-code?tabs=azure-cli)
- [Azure Bicep Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Bicep GitHub Page](https://github.com/Azure/bicep) (Interesting read)
- [Bicep Playground](https://azure.github.io/bicep/) - lets you view Bicep and JSON side by side

## Bicep Command Reference

```pwsh
New-AzResourceGroupDeployment -ResourceGroupName BicepDeployment -TemplateFile .\main.bicep
```
## Install the Bicep CLI

Use the following command to install the self-contained version of the Bicep CLI from `az`:

```powershell
az bicep install
Installing Bicep CLI v0.36.1...
The configuration value of bicep.use_binary_from_path has been set to 'false'.
Successfully installed Bicep CLI to "C:\Users\gregt\.azure\bin\bicep.exe".
```

Check version:

```powershell
az bicep version
Bicep CLI version 0.36.1 (a727ed087a)
```

**Note:** the self-contained instance isn't available with PowerShell commnands, so Azure deployments will fail if you haven't manually installed the Bicep CLI.

To manually install the Bicep CLI:

```powershell
winget install bicep
Found Bicep CLI [Microsoft.Bicep] Version 0.36.1
This application is licensed to you by its owner.
Microsoft is not responsible for, nor does it grant any licenses to, third-party packages.
Downloading https://github.com/Azure/bicep/releases/download/v0.36.1/bicep-setup-win-x64.exe
  ██████████████████████████████  38.5 MB / 38.5 MB
Successfully verified installer hash
Starting package install...
Successfully installed
```

Check version:

```powershell
bicep --version
Bicep CLI version 0.36.1 (a727ed087a)
```
