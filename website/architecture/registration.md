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
    .toInsert(account)
    .toInsert(DML.Record(contact).withRelationship(Contact.AccountId, account))
    .toInsert(DML.Record(opportunity).withRelationship(Opportunity.AccountId, account))
    .commitWork();
```

## Minimal DMLs

DML Lib minimizes the number of DML statements by building a dependency graph and grouping records into execution buckets.

### How It Works

1. **Graph Construction** — When you register records using `toInsert()`, `toUpdate()`, etc., each record becomes a node in a dependency graph. Relationships defined via `withRelationship()` create edges between nodes.

2. **Dependency Resolution** — Kahn's algorithm (topological sort) processes the graph, ensuring parent records are committed before their dependents.

3. **Bucket Assignment** — During graph resolution, records are grouped into buckets based on their operation characteristics:
   - **Operation type** — INSERT, UPDATE, UPSERT, DELETE, UNDELETE, MERGE, PUBLISH
   - **SObject type** — Account, Contact, Opportunity, etc.
   - **Additional identifiers** — Upsert external ID field, merge master record ID

Records sharing the same characteristics are placed in the same bucket and executed in a single DML statement.

### Example

```apex
new DML()
	.toInsert(account1)
	.toInsert(account2)
	.toUpsert(account3)
	.toUpsert(account4)
	.toInsert(DML.Record(account5).withRelationship(Account.ParentId, account2))
	.toInsert(DML.Record(contact1).withRelationship(Contact.AccountId, account2))
	.toInsert(DML.Record(contact2).withRelationship(Contact.AccountId, account3))
	.toInsert(opportunity1)
	.toInsert(DML.Record(opportunity2).withRelationship(Opportunity.AccountId, account4))
	.toInsert(lead1)
	.commitWork();

// Result: 7 DML statements executed
```

**Dependency Graph**

```mermaid
graph LR
    subgraph "No Dependencies"
        account1((account1))
        account2((account2))
        account3((account3))
        account4((account4))
        opportunity1((opportunity1))
        lead1((lead1))
    end

    subgraph "With Dependencies"
        account5((account5))
        contact1((contact1))
        contact2((contact2))
        opportunity2((opportunity2))
    end

    account5 -->|ParentId| account2
    contact1 -->|AccountId| account2
    contact2 -->|AccountId| account3
    opportunity2 -->|AccountId| account4

    style account1 fill:#4CAF50,color:#fff
    style account2 fill:#4CAF50,color:#fff
    style account3 fill:#FF9800,color:#fff
    style account4 fill:#FF9800,color:#fff
    style account5 fill:#00BCD4,color:#fff
    style contact1 fill:#2196F3,color:#fff
    style contact2 fill:#2196F3,color:#fff
    style opportunity1 fill:#9C27B0,color:#fff
    style opportunity2 fill:#E91E63,color:#fff
    style lead1 fill:#F44336,color:#fff
```

Despite registering 10 records, only **7 DML statements** are executed:

| DML # | Operation | SObject | Records | Reason |
|-------|-----------|---------|---------|--------|
| <span style="display:inline-block;width:12px;height:12px;background:#4CAF50;border-radius:2px"></span> 1 | INSERT | Account | account1, account2 | No dependencies, same bucket |
| <span style="display:inline-block;width:12px;height:12px;background:#FF9800;border-radius:2px"></span> 2 | UPSERT | Account | account3, account4 | No dependencies, different operation type |
| <span style="display:inline-block;width:12px;height:12px;background:#9C27B0;border-radius:2px"></span> 3 | INSERT | Opportunity | opportunity1 | No dependencies |
| <span style="display:inline-block;width:12px;height:12px;background:#F44336;border-radius:2px"></span> 4 | INSERT | Lead | lead1 | No dependencies |
| <span style="display:inline-block;width:12px;height:12px;background:#00BCD4;border-radius:2px"></span> 5 | INSERT | Account | account5 | Depends on account2 (ParentId) |
| <span style="display:inline-block;width:12px;height:12px;background:#2196F3;border-radius:2px"></span> 6 | INSERT | Contact | contact1, contact2 | Depend on account2 and account3 |
| <span style="display:inline-block;width:12px;height:12px;background:#E91E63;border-radius:2px"></span> 7 | INSERT | Opportunity | opportunity2 | Depends on account4 (AccountId) |

::: tip
No matter how you register records - in any order, across multiple method calls, or with complex relationships - DML Lib guarantees the minimal number of DML statements while respecting all dependencies.
:::