---
outline: deep
---

# Update

Update existing records in the database.

**Example**

```apex
Account account = new Account(Name = 'New Parent');
Contact contact = [SELECT Id FROM Contact LIMIT 1];

new DML()
    .toInsert(account)
    .toUpdate(DML.Record(contact)
        .withRelationship(Contact.AccountId, account)
    )
    .systemMode()
    .withoutSharing()
    .commitWork();
```

## toUpdate

Register records for update. The actual DML is executed when `commitWork()` is called.

**Signature**

```apex
Commitable toUpdate(SObject record);
Commitable toUpdate(DML.Record record);
Commitable toUpdate(Iterable<SObject> records);
Commitable toUpdate(DML.Records records);
```

### Single Record

**Signature**

```apex
Commitable toUpdate(SObject record);
```

**Standard DML**

```apex
Account account = [SELECT Id, Name FROM Account LIMIT 1];
account.Name = 'Updated Name';
update account;
```

**DML Lib**

```apex
Account account = [SELECT Id, Name FROM Account LIMIT 1];
account.Name = 'Updated Name';

new DML()
    .toUpdate(account)
    .commitWork();
```

#### Parent Relationship

Update parent-child relationships automatically.

**Signature**

```apex
Commitable toUpdate(DML.Record record);
```

**Standard DML**

```apex
Account account = new Account(Name = 'New Parent');
insert account;

Contact contact = [SELECT Id FROM Contact LIMIT 1];
contact.AccountId = account.Id;
update contact;
```

**DML Lib**

```apex
Account account = new Account(Name = 'New Parent');
Contact contact = [SELECT Id FROM Contact LIMIT 1];

new DML()
    .toInsert(account)
    .toUpdate(DML.Record(contact).withRelationship(Contact.AccountId, account))
    .commitWork();
```

#### With Field

Set field values dynamically using `DML.Record`.

**Signature**

```apex
Commitable toUpdate(DML.Record record);
```

**Standard DML**

```apex
Contact contact = [SELECT Id FROM Contact LIMIT 1];
contact.Email = 'updated@example.com';
update contact;
```

**DML Lib**

```apex
Contact contact = [SELECT Id FROM Contact LIMIT 1];

new DML()
    .toUpdate(DML.Record(contact).with(Contact.Email, 'updated@example.com'))
    .commitWork();
```

### Multiple Records

**Signature**

```apex
Commitable toUpdate(Iterable<SObject> records);
Commitable toUpdate(DML.Records records);
```

**Standard DML**

```apex
List<Account> accounts = [SELECT Id, Name FROM Account];
for (Account acc : accounts) {
    acc.Name = acc.Name + ' Updated';
}
update accounts;
```

**DML Lib**

```apex
List<Account> accounts = [SELECT Id, Name FROM Account];
for (Account acc : accounts) {
    acc.Name = acc.Name + ' Updated';
}

new DML()
    .toUpdate(accounts)
    .commitWork();
```

#### Parent Relationship

**Signature**

```apex
Commitable toUpdate(DML.Records records);
```

**Standard DML**

```apex
Account account = new Account(Name = 'New Parent');
insert account;

List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = null];
for (Contact c : contacts) {
    c.AccountId = account.Id;
}
update contacts;
```

**DML Lib**

```apex
Account account = new Account(Name = 'New Parent');
List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = null];

new DML()
    .toInsert(account)
    .toUpdate(DML.Records(contacts).withRelationship(Contact.AccountId, account))
    .commitWork();
```

#### With Field

Set field values dynamically for multiple records using `DML.Records`.

**Signature**

```apex
Commitable toUpdate(DML.Records records);
```

**Standard DML**

```apex
List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = null];
for (Contact c : contacts) {
    c.LeadSource = 'Web';
}
update contacts;
```

**DML Lib**

```apex
List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = null];

new DML()
    .toUpdate(DML.Records(contacts).with(Contact.LeadSource, 'Web'))
    .commitWork();
```

## updateImmediately

Update records immediately and return the operation result without calling `commitWork()`.

**Signature**

```apex
OperationResult updateImmediately(SObject record);
OperationResult updateImmediately(DML.Record record);
OperationResult updateImmediately(List<SObject> records);
OperationResult updateImmediately(DML.Records records);
```

::: tip
All DML settings configured on the `DML` instance (such as `userMode()`, `systemMode()`, `withSharing()`, `withoutSharing()`, `allowPartialSuccess()`) are inherited when executing `updateImmediately`.
:::

### Single Record

**Signature**

```apex
OperationResult updateImmediately(SObject record);
```

**Standard DML**

```apex
Account account = [SELECT Id, Name FROM Account LIMIT 1];
account.Name = 'Updated Name';
Database.SaveResult result = Database.update(account);
```

**DML Lib**

```apex
Account account = [SELECT Id, Name FROM Account LIMIT 1];
account.Name = 'Updated Name';
DML.OperationResult result = new DML().updateImmediately(account);
```

#### Parent Relationship

Update parent-child relationships automatically.

**Signature**

```apex
OperationResult updateImmediately(DML.Record record);
```

**Standard DML**

```apex
Account account = new Account(Name = 'New Parent');
Database.SaveResult accountResult = Database.insert(account);

Contact contact = [SELECT Id FROM Contact LIMIT 1];
contact.AccountId = account.Id;
Database.SaveResult contactResult = Database.update(contact);
```

**DML Lib**

```apex
Account account = new Account(Name = 'New Parent');
new DML().insertImmediately(account);

Contact contact = [SELECT Id FROM Contact LIMIT 1];
DML.OperationResult result = new DML()
    .updateImmediately(DML.Record(contact).withRelationship(Contact.AccountId, account));
```

#### With Field

Set field values dynamically using `DML.Record`.

**Signature**

```apex
OperationResult updateImmediately(DML.Record record);
```

**Standard DML**

```apex
Contact contact = [SELECT Id FROM Contact LIMIT 1];
contact.Email = 'updated@example.com';
Database.SaveResult result = Database.update(contact);
```

**DML Lib**

```apex
Contact contact = [SELECT Id FROM Contact LIMIT 1];
DML.OperationResult result = new DML()
    .updateImmediately(DML.Record(contact).with(Contact.Email, 'updated@example.com'));
```

### Multiple Records

**Signature**

```apex
OperationResult updateImmediately(List<SObject> records);
OperationResult updateImmediately(DML.Records records);
```

**Standard DML**

```apex
List<Account> accounts = [SELECT Id, Name FROM Account];
for (Account acc : accounts) {
    acc.Name = acc.Name + ' Updated';
}
List<Database.SaveResult> results = Database.update(accounts);
```

**DML Lib**

```apex
List<Account> accounts = [SELECT Id, Name FROM Account];
for (Account acc : accounts) {
    acc.Name = acc.Name + ' Updated';
}
DML.OperationResult result = new DML().updateImmediately(accounts);
```

#### Parent Relationship

**Signature**

```apex
OperationResult updateImmediately(DML.Records records);
```

**Standard DML**

```apex
Account account = new Account(Name = 'New Parent');
Database.SaveResult accountResult = Database.insert(account);

List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = null];
for (Contact c : contacts) {
    c.AccountId = account.Id;
}
List<Database.SaveResult> results = Database.update(contacts);
```

**DML Lib**

```apex
Account account = new Account(Name = 'New Parent');
new DML().insertImmediately(account);

List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = null];
DML.OperationResult result = new DML()
    .updateImmediately(DML.Records(contacts).withRelationship(Contact.AccountId, account));
```

#### With Field

Set field values dynamically for multiple records using `DML.Records`.

**Signature**

```apex
OperationResult updateImmediately(DML.Records records);
```

**Standard DML**

```apex
List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = null];
for (Contact c : contacts) {
    c.LeadSource = 'Web';
}
List<Database.SaveResult> results = Database.update(contacts);
```

**DML Lib**

```apex
List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = null];
DML.OperationResult result = new DML()
    .updateImmediately(DML.Records(contacts).with(Contact.LeadSource, 'Web'));
```
