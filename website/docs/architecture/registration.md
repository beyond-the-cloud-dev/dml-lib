---
outline: deep
---

# Registration

## Deduplication Strategy 

When records with the same ID are added to a list and an update is attempted, Salesforce throws the error `System.ListException: Duplicate id in list`.

**Standard DML**

```apex
Account account = [SELECT Id, Name FROM Account LIMIT 1];

List<Account> accountsToUpdate = new List<Account>();

Account account1 = new Account(Id = account.Id, Name = 'New Account 1', Website = 'mywebsite.com');
accountsToUpdate.add(account1);

Account account2 = new Account(Id = account.Id, Name = 'New Account 2');
accountsToUpdate.add(account2);

update accountsToUpdate; // Throws: System.ListException: Duplicate id in list
```

The same behavior applies in DML Lib. By default, an error will be thrown when the same record is registered multiple times.

**DML Lib (Default Behavior)**

```apex
Account account = [SELECT Id, Name FROM Account LIMIT 1];

new DML()
    .toUpdate(new Account(Id = account.Id, Name = 'New Account 1', Website = 'mywebsite.com'))
    .toUpdate(new Account(Id = account.Id, Name = 'New Account 2'))
    .commitWork(); // Throws: Duplicate records found during registration
```

### combineOnDuplicate

Use `combineOnDuplicate()` to automatically merge duplicate registrations into a single record. When the same record ID is registered multiple times, field values from later registrations override earlier ones, while preserving fields that are only set in earlier registrations.

**Signature**

```apex
Commitable combineOnDuplicate();
```

**Example**

```apex
Account account = [SELECT Id, Name FROM Account LIMIT 1];

new DML()
    .combineOnDuplicate()
    .toUpdate(new Account(Id = account.Id, Name = 'New Account 1', Website = 'mywebsite.com'))
    .toUpdate(new Account(Id = account.Id, Name = 'New Account 2'))
    .commitWork();
```

The two records will be merged into one before the DML operation:

| Field | First Registration | Second Registration | Final Value |
|-------|-------------------|---------------------|-------------|
| Id | account.Id | account.Id | account.Id |
| Name | 'New Account 1' | 'New Account 2' | 'New Account 2' |
| Website | 'mywebsite.com' | - | 'mywebsite.com' |

Result: `new Account(Id = account.Id, Name = 'New Account 2', Website = 'mywebsite.com')` will be updated.

## Registration Order

DML Lib uses Kahn's algorithm (topological sort) to resolve dependencies between records and commit them in the correct order. You can register records in any order — DML Lib will automatically determine the proper execution sequence.

**Example**

```apex
Account account = new Account(Name = 'Acme');
Contact contact = new Contact(LastName = 'Smith');
Opportunity opportunity = new Opportunity(Name = 'Deal', StageName = 'New', CloseDate = Date.today());

new DML()
    .toInsert(DML.Record(contact).withRelationship(Contact.AccountId, account))
    .toInsert(DML.Record(opportunity).withRelationship(Opportunity.AccountId, account))
    .toInsert(account) // Registered last, but inserted first
    .commitWork();
```

## Minimal DMLs

DML Lib groups records by SObject type and operation, reducing the number of DML statements to the minimum required.

**Example**

```apex
new DML()
    .toInsert(new Account(Name = 'Account 1'))
    .toInsert(new Account(Name = 'Account 2'))
    .toUpsert(new Contact(LastName = 'Smith'), Contact.MyExternalId__c)
    .toUpsert(new Contact(LastName = 'Doe'), Contact.MyExternalId__c)
    .commitWork();
```

Only 2 DML statements will be executed: one `INSERT` for Accounts, one `UPSERT` for Contacts. Records are automatically bulkified regardless of whether they are registered together or in separate method calls.