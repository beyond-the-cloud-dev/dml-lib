---
outline: deep
---

# Publish

Publish platform events.

**Example**

```apex
Account account = new Account(Name = 'New Account');
MyEvent__e event = new MyEvent__e(Message__c = 'Account Created');

new DML()
    .toInsert(account)
    .toPublish(event)
    .commitWork();
```

## toPublish

Register platform events for publishing. The actual publish is executed when `commitWork()` is called.

**Signature**

```apex
Commitable toPublish(SObject record);
Commitable toPublish(List<SObject> records);
```

### Single Event

**Signature**

```apex
Commitable toPublish(SObject record);
```

**Standard DML**

```apex
MyEvent__e event = new MyEvent__e(Message__c = 'Hello World');
EventBus.publish(event);
```

**DML Lib**

```apex
MyEvent__e event = new MyEvent__e(Message__c = 'Hello World');

new DML()
    .toPublish(event)
    .commitWork();
```

### Multiple Events

**Signature**

```apex
Commitable toPublish(List<SObject> records);
```

**Standard DML**

```apex
List<MyEvent__e> events = new List<MyEvent__e>{
    new MyEvent__e(Message__c = 'Event 1'),
    new MyEvent__e(Message__c = 'Event 2'),
    new MyEvent__e(Message__c = 'Event 3')
};
EventBus.publish(events);
```

**DML Lib**

```apex
List<MyEvent__e> events = new List<MyEvent__e>{
    new MyEvent__e(Message__c = 'Event 1'),
    new MyEvent__e(Message__c = 'Event 2'),
    new MyEvent__e(Message__c = 'Event 3')
};

new DML()
    .toPublish(events)
    .commitWork();
```

### Combined with DML Operations

Combine event publishing with other DML operations.

**Standard DML**

```apex
Account account = new Account(Name = 'New Account');
insert account;

AccountCreatedEvent__e event = new AccountCreatedEvent__e(
    AccountName__c = 'New Account'
);
EventBus.publish(event);
```

**DML Lib**

```apex
Account account = new Account(Name = 'New Account');
AccountCreatedEvent__e event = new AccountCreatedEvent__e(
    AccountName__c = 'New Account'
);

new DML()
    .toInsert(account)
    .toPublish(event)
    .commitWork();
```

::: warning
Platform events are published asynchronously. Even if the DML transaction is rolled back, published events may still be delivered.
:::

## publishImmediately

Publish platform events immediately and return the operation result without calling `commitWork()`.

**Signature**

```apex
OperationResult publishImmediately(SObject record);
OperationResult publishImmediately(List<SObject> records);
```

::: tip
All DML settings configured on the `DML` instance (such as `allowPartialSuccess()`) are inherited when executing `publishImmediately`.
:::

### Single Event

**Signature**

```apex
OperationResult publishImmediately(SObject record);
```

**Standard DML**

```apex
MyEvent__e event = new MyEvent__e(Message__c = 'Hello World');
Database.SaveResult result = EventBus.publish(event);
```

**DML Lib**

```apex
MyEvent__e event = new MyEvent__e(Message__c = 'Hello World');
DML.OperationResult result = new DML().publishImmediately(event);
```

### Multiple Events

**Signature**

```apex
OperationResult publishImmediately(List<SObject> records);
```

**Standard DML**

```apex
List<MyEvent__e> events = new List<MyEvent__e>{
    new MyEvent__e(Message__c = 'Event 1'),
    new MyEvent__e(Message__c = 'Event 2')
};
List<Database.SaveResult> results = EventBus.publish(events);
```

**DML Lib**

```apex
List<MyEvent__e> events = new List<MyEvent__e>{
    new MyEvent__e(Message__c = 'Event 1'),
    new MyEvent__e(Message__c = 'Event 2')
};
DML.OperationResult result = new DML().publishImmediately(events);
```
