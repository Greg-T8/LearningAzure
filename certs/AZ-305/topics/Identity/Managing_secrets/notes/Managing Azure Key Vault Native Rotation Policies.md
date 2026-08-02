# Managing Azure Key Vault Native Rotation Policies

Yes, what you are seeing in the portal is exactly how it works, and my previous phrasing was a bit ambiguous. Native key rotation policies are configured strictly at the **individual key level**, not at the broader Key Vault resource level [1]. 

There is no single vault-wide setting that automatically applies a default rotation schedule to all keys inside a vault [1]. You must define and apply the rotation policy for each specific key individually (for example, using the `Set-AzKeyVaultKeyRotationPolicy` command, which specifically targets an individual key) [2, 3].

Because policies are set per key, managing rotation at scale requires a different approach. If you want to guarantee that every key across your vault or organization is being rotated regularly, you do not use a vault-level setting; instead, you use **Azure Policy** [4, 5]. 

Azure provides a built-in policy named "Keys should have a rotation policy ensuring that their rotation is scheduled within the specified number of days after creation" [4, 5]. You can use this policy to automatically audit your environment and flag any individual keys that do not have an active rotation policy configured [6, 7].