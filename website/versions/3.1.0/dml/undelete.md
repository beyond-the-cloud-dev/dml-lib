---
outline: deep
---

# Undelete

Restore deleted records from the recycle bin.

**Example**

```apex
Account account = [SELECT Id FROM Account WHERE IsDeleted = true ALL ROWS LIMIT 1];
Opportunity opportunity = [SELECT Id FROM Opportunity WHERE IsDeleted = true ALL ROWS LIMIT 1];
Lead lead = [SELECT Id FROM Lead WHERE IsDeleted = true ALL ROWS LIMIT 1];

new DML()
    .toUndelete(account)
    .toUndelete(opportunity)
    .toUndelete(lead)
    .systemMode()
    .withoutSharing()
    .commitWork();
```

## toUndelete

Register records for undeletion. The actual DML is executed when `commitWork()` is called.

**Signature**

```apex
Commitable toUndelete(Id recordId);
Commitable toUndelete(SObject record);
Commitable toUndelete(Iterable<Id> recordIds);
Commitable toUndelete(List<SObject> records);
```

### Single Record

**Signature**

```apex
Commitable toUndelete(SObject record);
```

**Standard DML**

```apex
Account account = [SELECT Id FROM Account WHERE IsDeleted = true ALL ROWS LIMIT 1];
undelete account;
```

**DML Lib**

```apex
Account account = [SELECT Id FROM Account WHERE IsDeleted = true ALL ROWS LIMIT 1];

new DML()
    .toUndelete(account)
    .commitWork();
```

#### By Record ID

Undelete using a record ID directly.

**Signature**

```apex
Commitable toUndelete(Id recordId);
```

**Standard DML**

```apex
Id deletedAccountId = '001xx000003DGbYAAW';
undelete [SELECT Id FROM Account WHERE Id = :deletedAccountId ALL ROWS];
```

**DML Lib**

```apex
Id deletedAccountId = '001xx000003DGbYAAW';

new DML()
    .toUndelete(deletedAccountId)
    .commitWork();
```

### Multiple Records

**Signature**

```apex
Commitable toUndelete(List<SObject> records);
Commitable toUndelete(Iterable<Id> recordIds);
```

**Standard DML**

```apex
List<Account> accounts = [SELECT Id FROM Account WHERE IsDeleted = true ALL ROWS];
undelete accounts;
```

**DML Lib**

```apex
List<Account> accounts = [SELECT Id FROM Account WHERE IsDeleted = true ALL ROWS];

new DML()
    .toUndelete(accounts)
    .commitWork();
```

#### By Record IDs

Undelete using a collection of record IDs.

**Signature**

```apex
Commitable toUndelete(Iterable<Id> recordIds);
```

**Standard DML**

```apex
Set<Id> deletedAccountIds = new Set<Id>{ accountId1, accountId2, accountId3 };
undelete [SELECT Id FROM Account WHERE Id IN :deletedAccountIds ALL ROWS];
```

**DML Lib**

```apex
Set<Id> deletedAccountIds = new Set<Id>{ accountId1, accountId2, accountId3 };

new DML()
    .toUndelete(deletedAccountIds)
    .commitWork();
```

## undeleteImmediately

Undelete records immediately and return the operation result without calling `commitWork()`.

**Signature**

```apex
OperationResult undeleteImmediately(Id recordId);
OperationResult undeleteImmediately(SObject record);
OperationResult undeleteImmediately(Iterable<Id> recordIds);
OperationResult undeleteImmediately(List<SObject> records);
```

::: tip
All DML settings configured on the `DML` instance (such as `userMode()`, `systemMode()`, `withSharing()`, `withoutSharing()`, `allowPartialSuccess()`) are inherited when executing `undeleteImmediately`.
:::

### Single Record

**Signature**

```apex
OperationResult undeleteImmediately(SObject record);
```

**Standard DML**

```apex
Account account = [SELECT Id FROM Account WHERE IsDeleted = true ALL ROWS LIMIT 1];
Database.UndeleteResult result = Database.undelete(account);
```

**DML Lib**

```apex
Account account = [SELECT Id FROM Account WHERE IsDeleted = true ALL ROWS LIMIT 1];
DML.OperationResult result = new DML().undeleteImmediately(account);
```

#### By Record ID

Undelete using a record ID directly.

**Signature**

```apex
OperationResult undeleteImmediately(Id recordId);
```

**Standard DML**

```apex
Id deletedAccountId = '001xx000003DGbYAAW';
Database.UndeleteResult result = Database.undelete(deletedAccountId);
```

**DML Lib**

```apex
Id deletedAccountId = '001xx000003DGbYAAW';
DML.OperationResult result = new DML().undeleteImmediately(deletedAccountId);
```

### Multiple Records

**Signature**

```apex
OperationResult undeleteImmediately(List<SObject> records);
OperationResult undeleteImmediately(Iterable<Id> recordIds);
```

**Standard DML**

```apex
List<Account> accounts = [SELECT Id FROM Account WHERE IsDeleted = true ALL ROWS];
List<Database.UndeleteResult> results = Database.undelete(accounts);
```

**DML Lib**

```apex
List<Account> accounts = [SELECT Id FROM Account WHERE IsDeleted = true ALL ROWS];
DML.OperationResult result = new DML().undeleteImmediately(accounts);
```

#### By Record IDs

Undelete using a collection of record IDs.

**Signature**

```apex
OperationResult undeleteImmediately(Iterable<Id> recordIds);
```

**Standard DML**

```apex
Set<Id> deletedAccountIds = new Set<Id>{ accountId1, accountId2, accountId3 };
List<Database.UndeleteResult> results = Database.undelete(new List<Id>(deletedAccountIds));
```

**DML Lib**

```apex
Set<Id> deletedAccountIds = new Set<Id>{ accountId1, accountId2, accountId3 };
DML.OperationResult result = new DML().undeleteImmediately(deletedAccountIds);
```
