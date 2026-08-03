# Enabling Purge Protection in Azure Key Vault

To enable purge protection on Azure Key Vault, you can configure it either when creating a new vault or by updating an existing one. Purge protection is a security feature that prevents the permanent deletion of a key vault or its objects until a configured retention period elapses [1].

Here are the different methods to enable purge protection:

**Method 1: Enabling via the Azure Portal**
*   **For a new key vault:** When creating the key vault, navigate to the **Recovery options** tab and select the **Enable purge protection** option [2, 3].
*   **For an existing key vault:**
    1. Navigate to your key vault in the Azure portal [4].
    2. In the left menu under **Settings**, select **Properties** [4].
    3. In the Purge protection section, select **Enable purge protection** [4].

**Method 2: Enabling via Azure CLI**
*   **For a new key vault:** Use the `az keyvault create` command and include the `--enable-purge-protection true` flag [5].
    ```bash
    az keyvault create --name "<vault-name>" --resource-group "myResourceGroup" --enable-purge-protection true
    ```
*   **For an existing key vault:** Use the `az keyvault update` command with the `--enable-purge-protection true` flag [6, 7].
    ```bash
    az keyvault update --name "<vault-name>" --resource-group "myResourceGroup" --enable-purge-protection true
    ```

**Method 3: Enabling via Azure PowerShell**
*   **For a new key vault:** Use the `New-AzKeyVault` cmdlet and include the `-EnablePurgeProtection` switch [8]. 
    ```powershell
    New-AzKeyVault -Name "<vault-name>" -ResourceGroupName "myResourceGroup" -Location "EastUS" -EnablePurgeProtection
    ```

**Important Architectural Constraints to Remember:**
*   **Soft-delete requirement:** Purge protection can only be enabled if soft-delete is already enabled on the key vault (note that soft-delete is enabled by default for all new vaults) [9, 10].
*   **Irreversible action:** Once purge protection is enabled, **it cannot be disabled or overridden by anyone, including Microsoft** [11]. You must either recover a deleted key vault or wait for the full retention period (7 to 90 days) to elapse before the vault or its objects are permanently purged [1, 11].