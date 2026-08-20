---
outline: deep
---

# Upsert

Insert new records or update existing ones based on record ID.

**Example**

```apex
Account existingAccount = [SELECT Id, Name FROM Account LIMIT 1];
existingAccount.Name = 'Updated Name';

Account newAccount = new Account(Name = 'New Account');

new DML()
    .toUpsert(existingAccount)
    .toUpsert(newAccount)
    .systemMode()
    .withoutSharing()
    .commitWork();
```

## toUpsert

Register records for upsert. The actual DML is executed when `commitWork()` is called.

**Signature**

```apex
Commitable toUpsert(SObject record);
Commitable toUpsert(SObject record, SObjectField externalIdField);
Commitable toUpsert(DML.Record record);
Commitable toUpsert(List<SObject> records);
Commitable toUpsert(List<SObject> records, SObjectField externalIdField);
Commitable toUpsert(DML.Records records);
```

### Single Record

**Signature**

```apex
Commitable toUpsert(SObject record);
```

**Standard DML**

```apex
Account account = new Account(Name = 'My Account');
upsert account;
```

**DML Lib**

```apex
Account account = new Account(Name = 'My Account');

new DML()
    .toUpsert(account)
    .commitWork();
```

#### Parent Relationship

Handle parent-child relationships automatically.

**Signature**

```apex
Commitable toUpsert(DML.Record record);
```

**Standard DML**

```apex
Account account = new Account(Name = 'Parent Account');
upsert account;

Contact contact = new Contact(
    FirstName = 'John', 
    LastName = 'Doe', 
    AccountId = account.Id
);
upsert contact;
```

**DML Lib**

```apex
Account account = new Account(Name = 'Parent Account');
Contact contact = new Contact(FirstName = 'John', LastName = 'Doe');

new DML()
    .toUpsert(account)
    .toUpsert(DML.Record(contact).withRelationship(Contact.AccountId, account))
    .commitWork();
```

#### With Field

Set field values dynamically using `DML.Record`.

**Signature**

```apex
Commitable toUpsert(DML.Record record);
```

**Standard DML**

```apex
Contact contact = new Contact(LastName = 'Doe');
contact.Email = 'john@example.com';
upsert contact;
```

**DML Lib**

```apex
Contact contact = new Contact(LastName = 'Doe');

new DML()
    .toUpsert(DML.Record(contact).with(Contact.Email, 'john@example.com'))
    .commitWork();
```

#### With External Id Field

Upsert using a custom external ID field instead of the standard Id field.

**Signature**

```apex
Commitable toUpsert(SObject record, SObjectField externalIdField);
```

**Standard DML**

```apex
Account account = new Account(
    MyExternalId__c = 'EXT-001',
    Name = 'Acme Corp'
);
Database.upsert(account, Account.MyExternalId__c);
```

**DML Lib**

```apex
Account account = new Account(
    MyExternalId__c = 'EXT-001',
    Name = 'Acme Corp'
);

new DML()
    .toUpsert(account, Account.MyExternalId__c)
    .commitWork();
```

### Multiple Records

**Signature**

```apex
Commitable toUpsert(Iterable<SObject> records);
Commitable toUpsert(DML.Records records);
```

**Standard DML**

```apex
List<Account> accounts = new List<Account>{
    new Account(Name = 'New Account'),
    new Account(Id = existingId, Name = 'Updated Account')
};
upsert accounts;
```

**DML Lib**

```apex
List<Account> accounts = new List<Account>{
    new Account(Name = 'New Account'),
    new Account(Id = existingId, Name = 'Updated Account')
};

new DML()
    .toUpsert(accounts)
    .commitWork();
```

#### Parent Relationship

**Signature**

```apex
Commitable toUpsert(DML.Records records);
```

**Standard DML**

```apex
Account account = new Account(Name = 'My Account');
upsert account;

List<Contact> contacts = new List<Contact>{
    new Contact(LastName = 'Doe'),
    new Contact(LastName = 'Smith')
};

for (Contact c : contacts) {
    c.AccountId = account.Id;
}
upsert contacts;
```

**DML Lib**

```apex
Account account = new Account(Name = 'My Account');

List<Contact> contacts = new List<Contact>{
    new Contact(LastName = 'Doe'),
    new Contact(LastName = 'Smith')
};

new DML()
    .toUpsert(account)
    .toUpsert(DML.Records(contacts).withRelationship(Contact.AccountId, account))
    .commitWork();
```

#### With Field

Set field values dynamically for multiple records using `DML.Records`.

**Signature**

```apex
Commitable toUpsert(DML.Records records);
```

**Standard DML**

```apex
List<Contact> contacts = new List<Contact>{
    new Contact(LastName = 'Doe'),
    new Contact(Id = existingId, LastName = 'Smith')
};

for (Contact c : contacts) {
    c.LeadSource = 'Web';
}
upsert contacts;
```

**DML Lib**

```apex
List<Contact> contacts = new List<Contact>{
    new Contact(LastName = 'Doe'),
    new Contact(Id = existingId, LastName = 'Smith')
};

new DML()
    .toUpsert(DML.Records(contacts).with(Contact.LeadSource, 'Web'))
    .commitWork();
```

#### With External Id Field

Upsert multiple records using a custom external ID field instead of the standard Id field.

**Signature**

```apex
Commitable toUpsert(List<SObject> records, SObjectField externalIdField);
```

**Standard DML**

```apex
List<Account> accounts = new List<Account>{
    new Account(MyExternalId__c = 'EXT-001', Name = 'Acme Corp'),
    new Account(MyExternalId__c = 'EXT-002', Name = 'Global Inc')
};
Database.upsert(accounts, Account.MyExternalId__c);
```

**DML Lib**

```apex
List<Account> accounts = new List<Account>{
    new Account(MyExternalId__c = 'EXT-001', Name = 'Acme Corp'),
    new Account(MyExternalId__c = 'EXT-002', Name = 'Global Inc')
};

new DML()
    .toUpsert(accounts, Account.MyExternalId__c)
    .commitWork();
```

## upsertImmediately

Upsert records immediately and return the operation result without calling `commitWork()`.

**Signature**

```apex
OperationResult upsertImmediately(SObject record);
OperationResult upsertImmediately(DML.Record record);
OperationResult upsertImmediately(List<SObject> records);
OperationResult upsertImmediately(DML.Records records);
```

::: tip
All DML settings configured on the `DML` instance (such as `userMode()`, `systemMode()`, `withSharing()`, `withoutSharing()`, `allowPartialSuccess()`) are inherited when executing `upsertImmediately`.
:::

### Single Record

**Signature**

```apex
OperationResult upsertImmediately(SObject record);
```

**Standard DML**

```apex
Account account = new Account(Name = 'My Account');
Database.UpsertResult result = Database.upsert(account);
```

**DML Lib**

```apex
Account account = new Account(Name = 'My Account');
DML.OperationResult result = new DML().upsertImmediately(account);
```

#### Parent Relationship

Handle parent-child relationships automatically.

**Signature**

```apex
OperationResult upsertImmediately(DML.Record record);
```

**Standard DML**

```apex
Account account = new Account(Name = 'Parent Account');
Database.UpsertResult accountResult = Database.upsert(account);

Contact contact = new Contact(
    FirstName = 'John', 
    LastName = 'Doe', 
    AccountId = account.Id
);
Database.UpsertResult contactResult = Database.upsert(contact);
```

**DML Lib**

```apex
Account account = new Account(Name = 'Parent Account');
new DML().upsertImmediately(account);

Contact contact = new Contact(FirstName = 'John', LastName = 'Doe');
DML.OperationResult result = new DML()
    .upsertImmediately(DML.Record(contact).withRelationship(Contact.AccountId, account));
```

#### With Field

Set field values dynamically using `DML.Record`.

**Signature**

```apex
OperationResult upsertImmediately(DML.Record record);
```

**Standard DML**

```apex
Contact contact = new Contact(LastName = 'Doe');
contact.Email = 'john@example.com';
Database.UpsertResult result = Database.upsert(contact);
```

**DML Lib**

```apex
Contact contact = new Contact(LastName = 'Doe');
DML.OperationResult result = new DML()
    .upsertImmediately(DML.Record(contact).with(Contact.Email, 'john@example.com'));
```

### Multiple Records

**Signature**

```apex
OperationResult upsertImmediately(List<SObject> records);
OperationResult upsertImmediately(DML.Records records);
```

**Standard DML**

```apex
List<Account> accounts = new List<Account>{
    new Account(Name = 'New Account'),
    new Account(Id = existingId, Name = 'Updated Account')
};
List<Database.UpsertResult> results = Database.upsert(accounts);
```

**DML Lib**

```apex
List<Account> accounts = new List<Account>{
    new Account(Name = 'New Account'),
    new Account(Id = existingId, Name = 'Updated Account')
};
DML.OperationResult result = new DML().upsertImmediately(accounts);
```

#### Parent Relationship

**Signature**

```apex
OperationResult upsertImmediately(DML.Records records);
```

**Standard DML**

```apex
Account account = new Account(Name = 'My Account');
Database.UpsertResult accountResult = Database.upsert(account);

List<Contact> contacts = new List<Contact>{
    new Contact(LastName = 'Doe'),
    new Contact(LastName = 'Smith')
};

for (Contact c : contacts) {
    c.AccountId = account.Id;
}
List<Database.UpsertResult> results = Database.upsert(contacts);
```

**DML Lib**

```apex
Account account = new Account(Name = 'My Account');
new DML().upsertImmediately(account);

List<Contact> contacts = new List<Contact>{
    new Contact(LastName = 'Doe'),
    new Contact(LastName = 'Smith')
};

DML.OperationResult result = new DML()
    .upsertImmediately(DML.Records(contacts).withRelationship(Contact.AccountId, account));
```

#### With Field

Set field values dynamically for multiple records using `DML.Records`.

**Signature**

```apex
OperationResult upsertImmediately(DML.Records records);
```

**Standard DML**

```apex
List<Contact> contacts = new List<Contact>{
    new Contact(LastName = 'Doe'),
    new Contact(Id = existingId, LastName = 'Smith')
};

for (Contact c : contacts) {
    c.LeadSource = 'Web';
}
List<Database.UpsertResult> results = Database.upsert(contacts);
```

**DML Lib**

```apex
List<Contact> contacts = new List<Contact>{
    new Contact(LastName = 'Doe'),
    new Contact(Id = existingId, LastName = 'Smith')
};

DML.OperationResult result = new DML()
    .upsertImmediately(DML.Records(contacts).with(Contact.LeadSource, 'Web'));
```
