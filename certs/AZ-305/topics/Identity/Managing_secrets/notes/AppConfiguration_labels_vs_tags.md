In Azure App Configuration, a **label creates a distinct version of a key**, while a **tag adds descriptive metadata to an existing key-value**.

| Attribute                                   | Label                                             | Tag                                   |
| ------------------------------------------- | ------------------------------------------------- | ------------------------------------- |
| Purpose                                     | Creates variants of the same key                  | Describes or categorizes a key-value  |
| Part of the key-value identity              | **Yes**                                           | **No**                                |
| Quantity                                    | Zero or one label per key-value                   | Multiple name/value tags              |
| Common uses                                 | Environment, application version, deployment ring | Owner, team, region, classification   |
| Can affect which value the app receives     | Yes                                               | Only when explicitly used as a filter |
| Editable without creating another key-value | No                                                | Yes                                   |

## Label example

You can have several entries with the same key:

```text
Key: TestApp:Settings:FontColor
Label: Development
Value: Green
```

```text
Key: TestApp:Settings:FontColor
Label: Production
Value: Blue
```

```text
Key: TestApp:Settings:FontColor
Label: (No label)
Value: Red
```

These are **three separate key-values** because App Configuration uniquely identifies an entry by:

```text
Key + Label
```

Your application selects which label to load. Labels are commonly used for environments, versions, tenants, or deployment rings. ([Microsoft Learn][1])

## Tag example

A single key-value could have these tags:

```text
Key: TestApp:Settings:FontColor
Label: Production
Value: Blue

Tags:
  Owner = WebTeam
  Region = EastUS
  Classification = Internal
```

These tags do not create another version of the setting and do not change how the setting is addressed:

```text
TestApp:Settings:FontColor + Production
```

Tags can be used for management, filtering, import/export, automation, or selective loading by providers that support tag filters. For example, an application could request only settings tagged:

```text
Region = EastUS
Owner = WebTeam
```

When multiple tag filters are specified, the matching key-value must contain the requested tags and values. ([Microsoft Learn][2])

## Practical rule

Use a **label** when the setting needs a different value:

```text
Development = Green
Production  = Blue
```

Use a **tag** when you want to describe or organize the setting:

```text
Owner = WebTeam
ManagedBy = Terraform
```

For your key:

```text
TestApp:Settings:FontColor
```

`Development` or `Production` would normally be labels. `Owner=ApplicationTeam` or `Purpose=UI` would normally be tags.

[1]: https://learn.microsoft.com/en-us/azure/azure-app-configuration/concept-key-value "Understand Azure App Configuration key-value store | Microsoft Learn"
[2]: https://learn.microsoft.com/en-us/azure/azure-app-configuration/rest-api-key-value?utm_source=chatgpt.com "Azure App Configuration REST API - key-value"
