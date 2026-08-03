# Azure Key Vault Partnered Certificate Authority Automation

**DigiCert** and **GlobalSign** are the public certificate authorities supported for automated certificate management and renewal [1]. 

Azure Key Vault integrates natively with these partnered certificate authorities to support automatic renewal at a specified percentage of the certificate's lifetime or a set number of days before expiration [2]. While you are allowed to use certificates from other non-partnered providers, those authorities do not support automatic renewal capabilities [3].