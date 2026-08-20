---
outline: deep
---

# Merge

Merge duplicate records into a master record.

**Example**

```apex
Account masterAccount = [SELECT Id FROM Account WHERE ...];
Account duplicate1 = [SELECT Id FROM Account WHERE ...];
Account duplicate2 = [SELECT Id FROM Account WHERE ...];

new DML()
    .toMerge(masterAccount, new List<Account>{ duplicate1, duplicate2 })
    .systemMode()
    .withoutSharing()
    .commitWork();
```

## toMerge

Register records for merging. The actual DML is executed when `commitWork()` is called.

**Signature**

```apex
Commitable toMerge(SObject mergeToRecord, SObject duplicatedRecord);
Commitable toMerge(SObject mergeToRecord, List<SObject> duplicateRecords);
Commitable toMerge(SObject mergeToRecord, Id duplicatedRecordId);
Commitable toMerge(SObject mergeToRecord, Iterable<Id> duplicatedRecordIds);
```

### Single Duplicate Record

**Signature**

```apex
Commitable toMerge(SObject mergeToRecord, SObject duplicatedRecord);
```

**Standard DML**

```apex
Account masterAccount = [SELECT Id FROM Account WHERE ...];
Account duplicateAccount = [SELECT Id FROM Account WHERE ...];

Database.merge(masterAccount, duplicateAccount);
```

**DML Lib**

```apex
Account masterAccount = [SELECT Id FROM Account WHERE ...];
Account duplicateAccount = [SELECT Id FROM Account WHERE ...];

new DML()
    .toMerge(masterAccount, duplicateAccount)
    .commitWork();
```

#### By Record ID

Merge using a duplicate record ID directly.

**Signature**

```apex
Commitable toMerge(SObject mergeToRecord, Id duplicatedRecordId);
```

**Standard DML**

```apex
Account masterAccount = [SELECT Id FROM Account WHERE ...];
Id duplicateAccountId = '001xx000003DGbYAAW';

Database.merge(masterAccount, duplicateAccountId);
```

**DML Lib**

```apex
Account masterAccount = [SELECT Id FROM Account WHERE ...];
Id duplicateAccountId = '001xx000003DGbYAAW';

new DML()
    .toMerge(masterAccount, duplicateAccountId)
    .commitWork();
```

### Multiple Duplicate Records

**Signature**

```apex
Commitable toMerge(SObject mergeToRecord, List<SObject> duplicateRecords);
Commitable toMerge(SObject mergeToRecord, Iterable<Id> duplicatedRecordIds);
```

**Standard DML**

```apex
Account masterAccount = [SELECT Id FROM Account WHERE ...];
List<Account> duplicateAccounts = [SELECT Id FROM Account WHERE ...];

Database.merge(masterAccount, duplicateAccounts);
```

**DML Lib**

```apex
Account masterAccount = [SELECT Id FROM Account WHERE ...];
List<Account> duplicateAccounts = [SELECT Id FROM Account WHERE ...];

new DML()
    .toMerge(masterAccount, duplicateAccounts)
    .commitWork();
```

#### By Record IDs

Merge using a collection of duplicate record IDs.

**Signature**

```apex
Commitable toMerge(SObject mergeToRecord, Iterable<Id> duplicatedRecordIds);
```

**Standard DML**

```apex
Account masterAccount = [SELECT Id FROM Account WHERE ...];
Set<Id> duplicateAccountIds = new Set<Id>{ duplicateId1, duplicateId2 };

Database.merge(masterAccount, new List<Id>(duplicateAccountIds));
```

**DML Lib**

```apex
Account masterAccount = [SELECT Id FROM Account WHERE ...];
Set<Id> duplicateAccountIds = new Set<Id>{ duplicateId1, duplicateId2 };

new DML()
    .toMerge(masterAccount, duplicateAccountIds)
    .commitWork();
```
