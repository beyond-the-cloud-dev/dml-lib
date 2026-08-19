---
outline: deep
---

# Sharing Mode

Control how DML operations respect record-level sharing rules.

**Example**

```apex
System.runAs(minimalAccessUser) {
    new DML()
        .toUpdate(contact)
        .systemMode()
        .withSharing()
        .commitWork();
}
```

## Use Cases

### Administrative Operations

When performing admin-level operations that should bypass sharing:

```apex
public class DataMigrationService {
    public void migrateRecords(List<Account> accounts) {
        new DML()
            .toUpdate(accounts)
            .systemMode()
            .withoutSharing()
            .commitWork();
    }
}
```

We suggest using `.systemMode().withoutSharing()` in triggers, as trigger logic should always be executed.

## withSharing

By default, the DML library uses `with sharing`, meaning it respects the sharing context of the calling class. 
Sharing mode is enforced by `userMode()`, which is the default mode.
Only when `.systemMode()` is used, `.withSharing()` can control the sharing mode.

Execute DML operations enforcing sharing rules. Records the user doesn't have access to will cause errors.

**Signature**

```apex
Commitable withSharing();
```

**Standard DML**

```apex
// In a "with sharing" class context
public with sharing class MyClass {
    public void updateRecord(Contact contact) {
        update contact; // Sharing rules enforced
    }
}
```

**DML Lib**

```apex
new DML()
    .toUpdate(contact)
    .systemMode()
    .withSharing()
    .commitWork();
```

## withoutSharing

Execute DML operations bypassing sharing rules. All records are accessible regardless of sharing settings.
To use `.withoutSharing()`, the `.systemMode()` must be enabled.

**Signature**

```apex
Commitable withoutSharing();
```

**Standard DML**

```apex
// In a "without sharing" class context
public without sharing class MyClass {
    public void updateRecord(Contact contact) {
        update contact; // Sharing rules bypassed
    }
}
```

**DML Lib**

```apex
new DML()
    .toUpdate(contact)
    .systemMode()
    .withoutSharing()
    .commitWork();
```
