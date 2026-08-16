---
outline: deep
---

# Record & Records

Build records dynamically — set field values and parent relationships with the fluent `DML.Record` and `DML.Records` builders.

**Example**

```apex
Account account = new Account(Name = 'My Account');
Contact contact = new Contact(LastName = 'Doe');

new DML()
    .toInsert(account)
    .toInsert(DML.Record(contact)
        .with(Contact.Email, 'john@example.com')
        .withRelationship(Contact.AccountId, account)
    )
    .commitWork();
```

::: info
`DML.Record` and `DML.Records` are accepted by the `toInsert`, `toUpdate`, and `toUpsert` registration methods, as well as the `insertImmediately`, `updateImmediately`, and `upsertImmediately` overloads. See [Insert](/dml/insert), [Update](/dml/update), and [Upsert](/dml/upsert).
:::

## DML.Record

Wrap a single record in a fluent builder.

**Signature**

```apex
static DML.Record Record(SObject record);
static DML.Record Record(Id recordId);
```

### By Record

Use when you already have the `SObject` in memory and want to set fields or relationships fluently.

**Signature**

```apex
static DML.Record Record(SObject record);
```

**Standard DML**

```apex
Contact contact = new Contact(LastName = 'Doe');
contact.Email = 'john@example.com';
insert contact;
```

**DML Lib**

```apex
Contact contact = new Contact(LastName = 'Doe');

new DML()
    .toInsert(DML.Record(contact).with(Contact.Email, 'john@example.com'))
    .commitWork();
```

### By Record ID

Builds an in-memory `SObject` of the ID's type — update or upsert a record by its ID while setting fields, without querying it first.

**Signature**

```apex
static DML.Record Record(Id recordId);
```

**Standard DML**

```apex
Id accountId = '001xx000003DGbYAAW';

Account account = [SELECT Id FROM Account WHERE Id = :accountId];
account.Industry = 'IT';
update account;
```

**DML Lib**

```apex
Id accountId = '001xx000003DGbYAAW';

new DML()
    .toUpdate(DML.Record(accountId).with(Account.Industry, 'IT'))
    .commitWork();
```

::: warning
The record ID cannot be null. Passing a null `Id` throws a `DmlException`: `Invalid argument: recordId. Record ID cannot be null.`
:::

## DML.Records

Wrap a collection of records in a fluent builder. Every builder call (`with`, `withRelationship`) applies to **every** record in the collection.

**Signature**

```apex
static DML.Records Records(List<SObject> records);
static DML.Records Records(Iterable<Id> recordIds);
```

### By Records

Use when you already have the records in memory and want to set the same fields or relationships on all of them.

**Signature**

```apex
static DML.Records Records(List<SObject> records);
```

**Standard DML**

```apex
List<Contact> contacts = new List<Contact>{
    new Contact(LastName = 'Doe'),
    new Contact(LastName = 'Smith')
};

for (Contact c : contacts) {
    c.LeadSource = 'Web';
}
insert contacts;
```

**DML Lib**

```apex
List<Contact> contacts = new List<Contact>{
    new Contact(LastName = 'Doe'),
    new Contact(LastName = 'Smith')
};

new DML()
    .toInsert(DML.Records(contacts).with(Contact.LeadSource, 'Web'))
    .commitWork();
```

::: warning
All records must share a single `SObjectType`. Mixed types throw a `DmlException`: `Mixed SObject types in a single List<SObject> operation are not supported.`
:::

### By Record IDs

Accepts a `Set<Id>` or `List<Id>`. The `SObject` type is resolved from the first ID. Update fields on many records by their IDs — no SOQL query needed.

**Signature**

```apex
static DML.Records Records(Iterable<Id> recordIds);
```

**Standard DML**

```apex
Set<Id> accountIds = new Set<Id>{ '001xx000003DGbYAAW', '001xx000003DGbZAAW' };

List<Account> accounts = [SELECT Id FROM Account WHERE Id IN :accountIds];
for (Account account : accounts) {
    account.Industry = 'IT';
}
update accounts;
```

**DML Lib**

```apex
Set<Id> accountIds = new Set<Id>{ '001xx000003DGbYAAW', '001xx000003DGbZAAW' };

new DML()
    .toUpdate(DML.Records(accountIds).with(Account.Industry, 'IT'))
    .commitWork();
```

## with

Set a field value. On `DML.Records` the value is applied to every record in the collection.

**Signature**

```apex
DML.Record with(SObjectField field, Object value);
DML.Records with(SObjectField field, Object value);
```

**Standard DML**

```apex
Contact contact = new Contact(LastName = 'Doe');
contact.Email = 'john@example.com';
insert contact;
```

**DML Lib**

```apex
Contact contact = new Contact(LastName = 'Doe');

new DML()
    .toInsert(DML.Record(contact).with(Contact.Email, 'john@example.com'))
    .commitWork();
```

::: warning
Pass a field **value** (e.g. an `Id` or `String`), never an `SObject`. To relate records to each other, use `withRelationship`.
:::

## withRelationship (Related Record)

Relate a record to a parent record that may not have an ID yet. The relationship creates a dependency between the records — the parent is inserted first, and the foreign key is filled automatically at commit time.

**Signature**

```apex
DML.Record withRelationship(SObjectField relationshipField, SObject relatedRecord);
DML.Records withRelationship(SObjectField relationshipField, SObject relatedRecord);
```

**Standard DML**

```apex
Account account = new Account(Name = 'Parent Account');
insert account;

Contact contact = new Contact(LastName = 'Doe', AccountId = account.Id);
insert contact;
```

**DML Lib**

```apex
Account account = new Account(Name = 'Parent Account');
Contact contact = new Contact(LastName = 'Doe');

new DML()
    .toInsert(account)
    .toInsert(DML.Record(contact).withRelationship(Contact.AccountId, account))
    .commitWork();
```

::: info
The related record becomes part of the dependency graph, which determines the execution order of the DML operations. See [Registration](/architecture/registration) for details.
:::

::: warning
The field passed as `relationshipField` must be a relationship field. Otherwise a `DmlException` is thrown at registration: `Invalid argument: <FieldName>. Field supplied is not a relationship field.`
:::

## withRelationship (External ID)

Relate a record to a parent by the parent's External ID field value instead of its Salesforce ID.

**Signature**

```apex
DML.Record withRelationship(SObjectField relationshipField, SObjectField relatedObjectExternalIdField, Object relatedRecordExternalId);
DML.Records withRelationship(SObjectField relationshipField, SObjectField relatedObjectExternalIdField, Object relatedRecordExternalId);
```

**Standard DML**

```apex
Contact contact = new Contact(LastName = 'Smith');
contact.Account = new Account(ExternalId__c = 'EXT-001');
insert contact;
```

**DML Lib**

```apex
Contact contact = new Contact(LastName = 'Smith');

new DML()
    .toInsert(DML.Record(contact)
        .withRelationship(Contact.AccountId, Account.ExternalId__c, 'EXT-001')
    )
    .commitWork();
```

::: info
At commit time the library attaches a new in-memory parent `SObject` with only the External ID field populated, and the platform resolves the actual foreign key during the DML operation. Unlike the Related Record variant, the parent record is **not** part of the unit of work, and no execution-ordering dependency is created.
:::

::: warning
The arguments are validated at registration. A `DmlException` is thrown when:
- `relationshipField` is not a relationship field: `Invalid argument: relationshipField. Field supplied is not a relationship field.`
- `relatedObjectExternalIdField` is not marked as an External ID: `Invalid argument: externalIdField. Field supplied is not marked as an External Identifier.`
- `relatedObjectExternalIdField` does not exist on the related `SObject`: `Invalid argument: externalIdField. Field supplied is not a known field on the target sObject.`
:::
