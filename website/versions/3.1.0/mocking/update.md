---
outline: deep
---

# Update

Mock update operations in unit tests to avoid actual database updates.

::: warning
The `DML.mock()` and `DML.retrieveResultFor()` methods are `@TestVisible` and should only be used in test classes.
:::

::: tip
- **No database operations**: Mocked updates don't touch the database
- **Results are captured**: All operation details are available via `DML.retrieveResultFor()`
- **Selective mocking**: Use `updatesFor()` to mock specific SObject types while allowing others to execute
:::

**Example**

```apex
public class AccountService {
    public void deactivateAccounts() {
        List<Account> accounts = [SELECT Id FROM Account WHERE IsActive__c = true];

        for (Account acc : accounts) {
            acc.IsActive__c = false;
        }

        new DML()
            .toUpdate(accounts)
            .identifier('AccountService.deactivateAccounts')
            .commitWork();
    }
}
```

```apex
@IsTest
static void shouldDeactivateAccounts() {
    // Setup
    DML.mock('AccountService.deactivateAccounts').allUpdates();

    // Test
    Test.startTest();
    new AccountService().deactivateAccounts();
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('AccountService.deactivateAccounts');

    DML.OperationResult accountResult = result.updatesOf(Account.SObjectType);
    Assert.isFalse(accountResult.hasFailures(), 'No failures expected');
}
```

## allUpdates

Mock all update operations regardless of SObject type.

**Signature**

```apex
DML.mock(String identifier).allUpdates();
```

**Class**

```apex
public class DataService {
    public void markRecordsAsProcessed() {
        List<Account> accounts = [SELECT Id FROM Account WHERE Status__c = 'New'];
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Status__c = 'New'];

        new DML()
            .toUpdate(DML.Records(accounts).with(Account.Status__c, 'Processed'))
            .toUpdate(DML.Records(contacts).with(Contact.Status__c, 'Processed'))
            .identifier('DataService.markRecordsAsProcessed')
            .commitWork();
    }
}
```

**Test**

```apex
@IsTest
static void shouldMockMultipleSObjectTypes() {
    // Setup
    DML.mock('DataService.markRecordsAsProcessed').allUpdates();

    // Test
    Test.startTest();
    new DataService().markRecordsAsProcessed();
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('DataService.markRecordsAsProcessed');

    Assert.areEqual(2, result.updates().size(), '2 SObject types mocked');
}
```

## updatesFor

Mock update operations only for a specific SObject type. Other SObject types will be updated in the database.

**Signature**

```apex
DML.mock(String identifier).updatesFor(SObjectType objectType);
```

**Class**

```apex
public class DataService {
    public void markRecordsAsProcessed() {
        List<Account> accounts = [SELECT Id FROM Account WHERE Status__c = 'New'];
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Status__c = 'New'];

        new DML()
            .toUpdate(DML.Records(accounts).with(Account.Status__c, 'Processed'))
            .toUpdate(DML.Records(contacts).with(Contact.Status__c, 'Processed'))
            .identifier('DataService.markRecordsAsProcessed')
            .commitWork();
    }
}
```

**Test**

```apex
@IsTest
static void shouldMockOnlyAccountUpdates() {
    // Setup - Mock only Account updates
    DML.mock('DataService.markRecordsAsProcessed').updatesFor(Account.SObjectType);

    // Test
    Test.startTest();
    new DataService().markRecordsAsProcessed();
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('DataService.markRecordsAsProcessed');

    Assert.areEqual(2, result.updates().size(), '2 SObject types in result');
    // Account was mocked, Contact was actually updated
}
```

## Retrieving Results

Use `DML.retrieveResultFor()` to access the mocked operation results.

**Signature**

```apex
DML.Result result = DML.retrieveResultFor(String identifier);
```

**Class**

```apex
public class AccountService {
    public void archiveAccount(Id accountId) {
        new DML()
            .toUpdate(DML.Record(accountId).with(Account.Status__c, 'Archived'))
            .identifier('AccountService.archiveAccount')
            .commitWork();
    }
}
```

**Test**

```apex
@IsTest
static void shouldAccessRecordResults() {
    // Setup
    DML.mock('AccountService.archiveAccount').allUpdates();

    // Test
    Test.startTest();
    new AccountService().archiveAccount(DML.randomIdGenerator.get(Account.SObjectType));
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('AccountService.archiveAccount');
    DML.OperationResult operationResult = result.updatesOf(Account.SObjectType);

    Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Should be Account type');
    Assert.areEqual(DML.OperationType.UPDATE_DML, operationResult.operationType(), 'Should be UPDATE operation');
    Assert.isFalse(operationResult.hasFailures(), 'Should have no failures');
}
```

## Exception

Simulate DML exceptions for update operations without touching the database.

::: tip allowPartialSuccess
When `allowPartialSuccess()` is used, exceptions are **not thrown**. Instead, failures are recorded in the `Result` object. Use `hasFailures()` and `recordResults()` to check for errors.
:::

### exceptionOnUpdates

Throw an exception for all update operations.

**Signature**

```apex
DML.mock(String identifier).exceptionOnUpdates();
```

**Test**

```apex
@IsTest
static void shouldThrowExceptionOnUpdate() {
    // Setup
    DML.mock('myDmlId').exceptionOnUpdates();

    Id accountId = DML.randomIdGenerator.get(Account.SObjectType);

    // Test & Verify
    try {
        new DML()
            .toUpdate(new Account(Id = accountId, Name = 'Updated Name'))
            .identifier('myDmlId')
            .commitWork();
        Assert.fail('Expected exception');
    } catch (DmlException e) {
        Assert.isTrue(e.getMessage().contains('Update failed'));
    }
}
```

### exceptionOnUpdatesFor

Throw an exception only for update operations on a specific SObject type.

**Signature**

```apex
DML.mock(String identifier).exceptionOnUpdatesFor(SObjectType objectType);
```

**Test**

```apex
@IsTest
static void shouldThrowExceptionOnlyForAccountUpdates() {
    // Setup - Exception only for Account updates
    DML.mock('myDmlId').exceptionOnUpdatesFor(Account.SObjectType);

    Id accountId = DML.randomIdGenerator.get(Account.SObjectType);

    // Test & Verify
    try {
        new DML()
            .toUpdate(new Account(Id = accountId, Name = 'Updated Name'))
            .identifier('myDmlId')
            .commitWork();
        Assert.fail('Expected exception');
    } catch (DmlException e) {
        Assert.isTrue(e.getMessage().contains('Update failed'));
    }
}
```

### allowPartialSuccess

When using `allowPartialSuccess()`, failures are captured in the result instead of throwing an exception.

**Test**

```apex
@IsTest
static void shouldCaptureFailureInResult() {
    // Setup
    DML.mock('myDmlId').exceptionOnUpdates();

    Id accountId = DML.randomIdGenerator.get(Account.SObjectType);

    // Test - no exception thrown
    DML.Result result = new DML()
        .toUpdate(new Account(Id = accountId, Name = 'Updated Name'))
        .allowPartialSuccess()
        .identifier('myDmlId')
        .commitWork();

    // Verify
    DML.OperationResult operationResult = result.updatesOf(Account.SObjectType);

    Assert.isTrue(operationResult.hasFailures(), 'Should have failures');
    Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Record should be marked as failed');
}
```
