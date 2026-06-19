---
outline: deep
---

# Field Level Security

Control how DML operations respect field-level security (FLS) permissions.

**Example**

```apex
System.runAs(minimalAccessUser) {
    new DML()
        .toInsert(new Case(Subject = 'New Case'))
        .userMode() // by default
        .commitWork();
}
```

## accessMode

Set access mode explicitly using the Salesforce `System.AccessLevel` enum.

**Signature**

```apex
Commitable accessMode(System.AccessLevel accessMode);
```

Use `accessMode(System.AccessLevel.USER_MODE)` as an alternative to `userMode()`, and `accessMode(System.AccessLevel.SYSTEM_MODE)` as an alternative to `systemMode()`.

**Standard DML**

```apex
insert as user new Account(Name = 'My Account');
insert as system new Case(Subject = 'System Mode Case');
```

**DML Lib**

```apex
new DML()
    .toInsert(new Account(Name = 'My Account'))
    .accessMode(System.AccessLevel.USER_MODE)
    .commitWork();

new DML()
    .toInsert(new Case(Subject = 'System Mode Case'))
    .accessMode(System.AccessLevel.SYSTEM_MODE)
    .commitWork();
```

## userMode

Execute DML operations respecting user permissions. This is the **default behavior**.

**Signature**

```apex
Commitable userMode();
```

**Standard DML**

```apex
insert as user new Account(Name = 'My Account');
```

**DML Lib**

```apex
new DML()
    .toInsert(new Account(Name = 'My Account'))
    .userMode() // This is the default, can be omitted
    .commitWork();
```

## systemMode

Execute DML operations bypassing user permissions. Use this when you need to perform operations that the current user may not have access to.

**Signature**

```apex
Commitable systemMode();
```

**Standard DML**

```apex
insert as system new Case(Subject = 'System Mode Case');
```

**DML Lib**

```apex
new DML()
    .toInsert(new Case(Subject = 'System Mode Case'))
    .systemMode()
    .commitWork();
```

::: warning
Use `systemMode()` with caution. It bypasses field-level security, which could expose sensitive data or allow unauthorized modifications. Only use it when absolutely necessary.
:::

## Combining with Sharing Mode

Field-level security and sharing mode are independent settings that work together.

| Configuration                                                 | FLS      | Sharing Rules |
| ------------------------------------------------------------- | -------- | ------------- |
| `userMode()`                                                  | Enforced | Enforced      |
| `accessMode(System.AccessLevel.USER_MODE)`                    | Enforced | Enforced      |
| `userMode().withSharing()`                                    | Enforced | Enforced      |
| `userMode().withoutSharing()`                                 | Enforced | Enforced      |
| `systemMode().withSharing()`                                  | Bypassed | Enforced      |
| `accessMode(System.AccessLevel.SYSTEM_MODE).withSharing()`    | Bypassed | Enforced      |
| `systemMode().withoutSharing()`                               | Bypassed | Bypassed      |
| `accessMode(System.AccessLevel.SYSTEM_MODE).withoutSharing()` | Bypassed | Bypassed      |

**Example**

```apex
// Bypass FLS but enforce sharing rules
new DML()
    .toUpdate(record)
    .systemMode()
    .withSharing()
    .commitWork();

// Bypass both FLS and sharing rules
new DML()
    .toUpdate(record)
    .systemMode()
    .withoutSharing()
    .commitWork();
```
