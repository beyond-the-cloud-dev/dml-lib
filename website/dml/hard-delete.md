---
outline: deep
---

# Hard Delete

Permanently delete records from the database, bypassing the Recycle Bin.

**Example**

```apex
List<Account> obsoleteAccounts = [SELECT Id FROM Account WHERE CreatedDate < LAST_N_YEARS:5];
List<Lead> obsoleteLeads = [SELECT Id FROM Lead WHERE CreatedDate < LAST_N_YEARS:5];

new DML()
    .toHardDelete(obsoleteAccounts)
    .toHardDelete(obsoleteLeads)
    .commitWork();
```

::: warning
Hard delete is **irreversible**. Records are deleted and then removed from the Recycle Bin (`Database.emptyRecycleBin`), so they **cannot** be restored with `toUndelete`/`undelete` or recovered from the Recycle Bin.
:::

## toHardDelete

Register records for hard deletion. The actual DML is executed when `commitWork()` is called — records are deleted (`Database.delete`) and then permanently removed from the Recycle Bin (`Database.emptyRecycleBin`).

**Signature**

```apex
Commitable toHardDelete(Id recordId);
Commitable toHardDelete(SObject record);
Commitable toHardDelete(Iterable<Id> recordIds);
Commitable toHardDelete(List<SObject> records);
```

Records registered with `toHardDelete` must have an Id by the time the operation executes — otherwise a `DmlException` with the message `Only existing records can be registered as deleted.` is thrown when `commitWork()` runs. A record inserted earlier in the same unit of work receives its Id from the insert, so it can be registered for hard delete in the same commit. Operations that executed earlier in the same `commitWork()` are not rolled back when the exception is thrown — use `commitTransaction()` when the whole unit of work must be atomic (see [Deferred Validation](/architecture/registration#deferred-validation)).

::: info
There is no `hardDeleteImmediately` variant — hard delete is deferred-only and always executes as part of `commitWork()`.
:::

::: tip
- **Results**: Hard deletes appear in the same result buckets as regular deletes — `result.deletes()` and `result.deletesOf(SObjectType)` with `DML.OperationType.DELETE_DML`. There is no separate hard-delete bucket. See [Result](/result).
- **Bucketing**: Hard-delete registrations are kept separate from `toDelete` registrations of the same SObjectType — they never combine into one DML statement.
- **Governor limits**: The `Database.emptyRecycleBin` call is an additional DML operation counted against governor limits.
:::

### Single Record

**Signature**

```apex
Commitable toHardDelete(SObject record);
```

**Standard DML**

```apex
Account account = [SELECT Id FROM Account LIMIT 1];
delete account;
Database.emptyRecycleBin(account);
```

**DML Lib**

```apex
Account account = [SELECT Id FROM Account LIMIT 1];

new DML()
    .toHardDelete(account)
    .commitWork();
```

#### By Record ID

Hard delete using a record ID directly.

**Signature**

```apex
Commitable toHardDelete(Id recordId);
```

**Standard DML**

```apex
Id accountId = '001xx000003DGbYAAW';
delete [SELECT Id FROM Account WHERE Id = :accountId];
Database.emptyRecycleBin(new List<Id>{ accountId });
```

**DML Lib**

```apex
Id accountId = '001xx000003DGbYAAW';

new DML()
    .toHardDelete(accountId)
    .commitWork();
```

### Multiple Records

**Signature**

```apex
Commitable toHardDelete(List<SObject> records);
Commitable toHardDelete(Iterable<Id> recordIds);
```

**Standard DML**

```apex
List<Account> accounts = [SELECT Id FROM Account WHERE Name LIKE 'Test%'];
delete accounts;
Database.emptyRecycleBin(accounts);
```

**DML Lib**

```apex
List<Account> accounts = [SELECT Id FROM Account WHERE Name LIKE 'Test%'];

new DML()
    .toHardDelete(accounts)
    .commitWork();
```

#### By Record IDs

Hard delete using a collection of record IDs.

**Signature**

```apex
Commitable toHardDelete(Iterable<Id> recordIds);
```

**Standard DML**

```apex
Set<Id> accountIds = new Set<Id>{ accountId1, accountId2, accountId3 };
delete [SELECT Id FROM Account WHERE Id IN :accountIds];
Database.emptyRecycleBin(new List<Id>(accountIds));
```

**DML Lib**

```apex
Set<Id> accountIds = new Set<Id>{ accountId1, accountId2, accountId3 };

new DML()
    .toHardDelete(accountIds)
    .commitWork();
```

## Mocking

There are no dedicated hard-delete mock methods — `DML.mock(identifier).allDeletes()`, `.deletesFor(SObjectType)`, `.exceptionOnDeletes()`, and `.exceptionOnDeletesFor(SObjectType)` cover `toHardDelete` as well, and results land in the delete buckets. Mocked commits execute zero DML. See [Delete Mocking](/mocking/delete).
