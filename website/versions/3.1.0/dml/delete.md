---
outline: deep
---

# Delete

Delete records from the database.

**Example**

```apex
Account account = [SELECT Id FROM Account LIMIT 1];
Opportunity opportunity = [SELECT Id FROM Opportunity LIMIT 1];
Lead lead = [SELECT Id FROM Lead LIMIT 1];

new DML()
    .toDelete(account)
    .toDelete(opportunity)
    .toDelete(lead)
    .systemMode()
    .withoutSharing()
    .commitWork();
```

## toDelete

Register records for deletion. The actual DML is executed when `commitWork()` is called.

**Signature**

```apex
Commitable toDelete(Id recordId);
Commitable toDelete(SObject record);
Commitable toDelete(Iterable<Id> recordIds);
Commitable toDelete(List<SObject> records);
```

### Single Record

**Signature**

```apex
Commitable toDelete(SObject record);
```

**Standard DML**

```apex
Account account = [SELECT Id FROM Account LIMIT 1];
delete account;
```

**DML Lib**

```apex
Account account = [SELECT Id FROM Account LIMIT 1];

new DML()
    .toDelete(account)
    .commitWork();
```

#### By Record ID

Delete using a record ID directly.

**Signature**

```apex
Commitable toDelete(Id recordId);
```

**Standard DML**

```apex
Id accountId = '001xx000003DGbYAAW';
delete [SELECT Id FROM Account WHERE Id = :accountId];
```

**DML Lib**

```apex
Id accountId = '001xx000003DGbYAAW';

new DML()
    .toDelete(accountId)
    .commitWork();
```

### Multiple Records

**Signature**

```apex
Commitable toDelete(List<SObject> records);
Commitable toDelete(Iterable<Id> recordIds);
```

**Standard DML**

```apex
List<Account> accounts = [SELECT Id FROM Account WHERE Name LIKE 'Test%'];
delete accounts;
```

**DML Lib**

```apex
List<Account> accounts = [SELECT Id FROM Account WHERE Name LIKE 'Test%'];

new DML()
    .toDelete(accounts)
    .commitWork();
```

#### By Record IDs

Delete using a collection of record IDs.

**Signature**

```apex
Commitable toDelete(Iterable<Id> recordIds);
```

**Standard DML**

```apex
Set<Id> accountIds = new Set<Id>{ accountId1, accountId2, accountId3 };
delete [SELECT Id FROM Account WHERE Id IN :accountIds];
```

**DML Lib**

```apex
Set<Id> accountIds = new Set<Id>{ accountId1, accountId2, accountId3 };

new DML()
    .toDelete(accountIds)
    .commitWork();
```

## deleteImmediately

Delete records immediately and return the operation result without calling `commitWork()`.

**Signature**

```apex
OperationResult deleteImmediately(Id recordId);
OperationResult deleteImmediately(SObject record);
OperationResult deleteImmediately(Iterable<Id> recordIds);
OperationResult deleteImmediately(List<SObject> records);
```

::: tip
All DML settings configured on the `DML` instance (such as `userMode()`, `systemMode()`, `withSharing()`, `withoutSharing()`, `allowPartialSuccess()`) are inherited when executing `deleteImmediately`.
:::

### Single Record

**Signature**

```apex
OperationResult deleteImmediately(SObject record);
```

**Standard DML**

```apex
Account account = [SELECT Id FROM Account LIMIT 1];
Database.DeleteResult result = Database.delete(account);
```

**DML Lib**

```apex
Account account = [SELECT Id FROM Account LIMIT 1];
DML.OperationResult result = new DML().deleteImmediately(account);
```

#### By Record ID

Delete using a record ID directly.

**Signature**

```apex
OperationResult deleteImmediately(Id recordId);
```

**Standard DML**

```apex
Id accountId = '001xx000003DGbYAAW';
Database.DeleteResult result = Database.delete(accountId);
```

**DML Lib**

```apex
Id accountId = '001xx000003DGbYAAW';
DML.OperationResult result = new DML().deleteImmediately(accountId);
```

### Multiple Records

**Signature**

```apex
OperationResult deleteImmediately(List<SObject> records);
OperationResult deleteImmediately(Iterable<Id> recordIds);
```

**Standard DML**

```apex
List<Account> accounts = [SELECT Id FROM Account WHERE Name LIKE 'Test%'];
List<Database.DeleteResult> results = Database.delete(accounts);
```

**DML Lib**

```apex
List<Account> accounts = [SELECT Id FROM Account WHERE Name LIKE 'Test%'];
DML.OperationResult result = new DML().deleteImmediately(accounts);
```

#### By Record IDs

Delete using a collection of record IDs.

**Signature**

```apex
OperationResult deleteImmediately(Iterable<Id> recordIds);
```

**Standard DML**

```apex
Set<Id> accountIds = new Set<Id>{ accountId1, accountId2, accountId3 };
List<Database.DeleteResult> results = Database.delete(new List<Id>(accountIds));
```

**DML Lib**

```apex
Set<Id> accountIds = new Set<Id>{ accountId1, accountId2, accountId3 };
DML.OperationResult result = new DML().deleteImmediately(accountIds);
```
