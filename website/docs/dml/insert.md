---
outline: deep
---

# Insert

Insert new records into the database.

## toInsert

Register records for insertion. The actual DML is executed when `commitWork()` is called.

**Signature**

```apex
Commitable toInsert(SObject record);
Commitable toInsert(DML.Record record);
Commitable toInsert(Iterable<SObject> records);
Commitable toInsert(DML.Records records);
```

**Example**

```apex
Account account = new Account(Name = 'My Account');
Contact contact = new Contact(LastName = 'Doe');

new DML()
    .toInsert(account)
    .toInsert(DML.Record(contact)
        .withRelationship(Contact.AccountId, account)
    )
    .systemMode()
    .withoutSharing()
    .commitWork();
```

### Single Record

**Signature**

```apex
Commitable toInsert(SObject record);
```

**Standard DML**

```apex
insert new Account(Name = 'My Account');
```

**DML Lib**

```apex
new DML()
    .toInsert(new Account(Name = 'My Account'))
    .commitWork();
```

#### Parent Relationship

Handle parent-child relationships automatically.

**Signature**

```apex
Commitable toInsert(DML.Record record);
```

**Standard DML**

```apex
Account account = new Account(Name = 'Parent Account');
insert account;

Contact contact = new Contact(
    FirstName = 'John', 
    LastName = 'Doe', 
    AccountId = account.Id
);
insert contact;
```

**DML Lib**

```apex
Account account = new Account(Name = 'Parent Account');
Contact contact = new Contact(FirstName = 'John', LastName = 'Doe');

new DML()
    .toInsert(account)
    .toInsert(DML.Record(contact).withRelationship(Contact.AccountId, account))
    .commitWork();
```

#### With Field

Set field values dynamically using `DML.Record`.

**Signature**

```apex
Commitable toInsert(DML.Record record);
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

### Multiple Records

**Signature**

```apex
Commitable toInsert(Iterable<SObject> records);
Commitable toInsert(DML.Records records);
```

**Standard DML**

```apex
List<Account> accounts = new List<Account>{
    new Account(Name = 'Account 1'),
    new Account(Name = 'Account 2')
};
insert accounts;
```

**DML Lib**

```apex
List<Account> accounts = new List<Account>{
    new Account(Name = 'Account 1'),
    new Account(Name = 'Account 2')
};

new DML()
    .toInsert(accounts)
    .commitWork();
```

#### Parent Relationship

**Signature**

```apex
Commitable toInsert(DML.Records records);
```

**Standard DML**

```apex
Account account = new Account(Name = 'My Account');
insert account;

List<Contact> contacts = new List<Contact>{
    new Contact(LastName = 'Doe'),
    new Contact(LastName = 'Smith')
};

for (Contact c : contacts) {
    c.AccountId = account.Id;
}
insert contacts;
```

**DML Lib**

```apex
Account account = new Account(Name = 'My Account');

List<Contact> contacts = new List<Contact>{
    new Contact(LastName = 'Doe'),
    new Contact(LastName = 'Smith')
};

new DML()
    .toInsert(account)
    .toInsert(DML.Records(contacts).withRelationship(Contact.AccountId, account))
    .commitWork();
```

#### With Field

Set field values dynamically for multiple records using `DML.Records`.

**Signature**

```apex
Commitable toInsert(DML.Records records);
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

## insertImmediately

Insert records immediately and return the operation result without calling `commitWork()`.

**Signature**

```apex
OperationResult insertImmediately(SObject record);
OperationResult insertImmediately(DML.Record record);
OperationResult insertImmediately(List<SObject> records);
OperationResult insertImmediately(DML.Records records);
```

::: tip
All DML settings configured on the `DML` instance (such as `userMode()`, `systemMode()`, `withSharing()`, `withoutSharing()`, `allowPartialSuccess()`) are inherited when executing `insertImmediately`.
:::

### Single Record

**Signature**

```apex
OperationResult insertImmediately(SObject record);
```

**Standard DML**

```apex
Account account = new Account(Name = 'My Account');
Database.SaveResult result = Database.insert(account);
```

**DML Lib**

```apex
Account account = new Account(Name = 'My Account');
DML.OperationResult result = new DML().insertImmediately(account);
```

#### Parent Relationship

Handle parent-child relationships automatically.

**Signature**

```apex
OperationResult insertImmediately(DML.Record record);
```

**Standard DML**

```apex
Account account = new Account(Name = 'Parent Account');
Database.SaveResult accountResult = Database.insert(account);

Contact contact = new Contact(
    FirstName = 'John', 
    LastName = 'Doe', 
    AccountId = account.Id
);
Database.SaveResult contactResult = Database.insert(contact);
```

**DML Lib**

```apex
Account account = new Account(Name = 'Parent Account');
new DML().insertImmediately(account);

Contact contact = new Contact(FirstName = 'John', LastName = 'Doe');
DML.OperationResult result = new DML()
    .insertImmediately(DML.Record(contact).withRelationship(Contact.AccountId, account));
```

#### With Field

Set field values dynamically using `DML.Record`.

**Signature**

```apex
OperationResult insertImmediately(DML.Record record);
```

**Standard DML**

```apex
Contact contact = new Contact(LastName = 'Doe');
contact.Email = 'john@example.com';
Database.SaveResult result = Database.insert(contact);
```

**DML Lib**

```apex
Contact contact = new Contact(LastName = 'Doe');
DML.OperationResult result = new DML()
    .insertImmediately(DML.Record(contact).with(Contact.Email, 'john@example.com'));
```

### Multiple Records

**Signature**

```apex
OperationResult insertImmediately(List<SObject> records);
OperationResult insertImmediately(DML.Records records);
```

**Standard DML**

```apex
List<Account> accounts = new List<Account>{
    new Account(Name = 'Account 1'),
    new Account(Name = 'Account 2')
};
List<Database.SaveResult> results = Database.insert(accounts);
```

**DML Lib**

```apex
List<Account> accounts = new List<Account>{
    new Account(Name = 'Account 1'),
    new Account(Name = 'Account 2')
};
DML.OperationResult result = new DML().insertImmediately(accounts);
```

#### Parent Relationship

**Signature**

```apex
OperationResult insertImmediately(DML.Records records);
```

**Standard DML**

```apex
Account account = new Account(Name = 'My Account');
Database.SaveResult accountResult = Database.insert(account);

List<Contact> contacts = new List<Contact>{
    new Contact(LastName = 'Doe'),
    new Contact(LastName = 'Smith')
};

for (Contact c : contacts) {
    c.AccountId = account.Id;
}
List<Database.SaveResult> results = Database.insert(contacts);
```

**DML Lib**

```apex
Account account = new Account(Name = 'My Account');
new DML().insertImmediately(account);

List<Contact> contacts = new List<Contact>{
    new Contact(LastName = 'Doe'),
    new Contact(LastName = 'Smith')
};

DML.OperationResult result = new DML()
    .insertImmediately(DML.Records(contacts).with(Contact.AccountId, account));
```

#### With Field

Set field values dynamically for multiple records using `DML.Records`.

**Signature**

```apex
OperationResult insertImmediately(DML.Records records);
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
List<Database.SaveResult> results = Database.insert(contacts);
```

**DML Lib**

```apex
List<Contact> contacts = new List<Contact>{
    new Contact(LastName = 'Doe'),
    new Contact(LastName = 'Smith')
};

DML.OperationResult result = new DML()
    .insertImmediately(DML.Records(contacts).with(Contact.LeadSource, 'Web'));
```
