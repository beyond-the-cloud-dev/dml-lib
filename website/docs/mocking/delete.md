---
outline: deep
---

# Delete

Mock delete operations in unit tests to avoid actual database deletes.

::: warning
The `DML.mock()` and `DML.retrieveResultFor()` methods are `@TestVisible` and should only be used in test classes.
:::

::: tip
- **No database operations**: Mocked deletes don't touch the database
- **Results are captured**: All operation details are available via `DML.retrieveResultFor()`
- **Selective mocking**: Use `deletesFor()` to mock specific SObject types while allowing others to execute
:::

**Example**

```apex
public class AccountService {
    public void deleteInactiveAccounts() {
        List<Account> accounts = [SELECT Id FROM Account WHERE IsActive__c = false];

        new DML()
            .toDelete(accounts)
            .identifier('AccountService.deleteInactiveAccounts')
            .commitWork();
    }
}
```

```apex
@IsTest
static void shouldDeleteInactiveAccounts() {
    // Setup
    DML.mock('AccountService.deleteInactiveAccounts').allDeletes();

    // Test
    Test.startTest();
    new AccountService().deleteInactiveAccounts();
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('AccountService.deleteInactiveAccounts');

    DML.OperationResult accountResult = result.deletesOf(Account.SObjectType);
    Assert.isFalse(accountResult.hasFailures(), 'No failures expected');
}
```

## allDeletes

Mock all delete operations regardless of SObject type.

**Signature**

```apex
DML.mock(String identifier).allDeletes();
```

**Class**

```apex
public class DataService {
    public void cleanupOldRecords() {
        List<Account> accounts = [SELECT Id FROM Account WHERE CreatedDate < LAST_YEAR];
        List<Contact> contacts = [SELECT Id FROM Contact WHERE CreatedDate < LAST_YEAR];

        new DML()
            .toDelete(accounts)
            .toDelete(contacts)
            .identifier('DataService.cleanupOldRecords')
            .commitWork();
    }
}
```

**Test**

```apex
@IsTest
static void shouldMockMultipleSObjectTypes() {
    // Setup
    DML.mock('DataService.cleanupOldRecords').allDeletes();

    // Test
    Test.startTest();
    new DataService().cleanupOldRecords();
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('DataService.cleanupOldRecords');

    Assert.areEqual(2, result.deletes().size(), '2 SObject types mocked');
}
```

## deletesFor

Mock delete operations only for a specific SObject type. Other SObject types will be deleted from the database.

**Signature**

```apex
DML.mock(String identifier).deletesFor(SObjectType objectType);
```

**Class**

```apex
public class DataService {
    public void cleanupOldRecords() {
        List<Account> accounts = [SELECT Id FROM Account WHERE CreatedDate < LAST_YEAR];
        List<Contact> contacts = [SELECT Id FROM Contact WHERE CreatedDate < LAST_YEAR];

        new DML()
            .toDelete(accounts)
            .toDelete(contacts)
            .identifier('DataService.cleanupOldRecords')
            .commitWork();
    }
}
```

**Test**

```apex
@IsTest
static void shouldMockOnlyAccountDeletes() {
    // Setup - Mock only Account deletes
    DML.mock('DataService.cleanupOldRecords').deletesFor(Account.SObjectType);

    // Test
    Test.startTest();
    new DataService().cleanupOldRecords();
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('DataService.cleanupOldRecords');

    Assert.areEqual(2, result.deletes().size(), '2 SObject types in result');
    // Account was mocked, Contact was actually deleted
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
    public void deleteAccount(Id accountId) {
        new DML()
            .toDelete(accountId)
            .identifier('AccountService.deleteAccount')
            .commitWork();
    }
}
```

**Test**

```apex
@IsTest
static void shouldAccessRecordResults() {
    // Setup
    DML.mock('AccountService.deleteAccount').allDeletes();

    // Test
    Test.startTest();
    new AccountService().deleteAccount(DML.randomIdGenerator.get(Account.SObjectType));
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('AccountService.deleteAccount');
    DML.OperationResult operationResult = result.deletesOf(Account.SObjectType);

    Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Should be Account type');
    Assert.areEqual(DML.OperationType.DELETE_DML, operationResult.operationType(), 'Should be DELETE operation');
    Assert.isFalse(operationResult.hasFailures(), 'Should have no failures');
}
```

## Exception

Simulate DML exceptions for delete operations without touching the database.

::: tip allowPartialSuccess
When `allowPartialSuccess()` is used, exceptions are **not thrown**. Instead, failures are recorded in the `Result` object. Use `hasFailures()` and `recordResults()` to check for errors.
:::

### exceptionOnDeletes

Throw an exception for all delete operations.

**Signature**

```apex
DML.mock(String identifier).exceptionOnDeletes();
```

**Test**

```apex
@IsTest
static void shouldThrowExceptionOnDelete() {
    // Setup
    DML.mock('myDmlId').exceptionOnDeletes();

    Id accountId = DML.randomIdGenerator.get(Account.SObjectType);

    // Test & Verify
    try {
        new DML()
            .toDelete(accountId)
            .identifier('myDmlId')
            .commitWork();
        Assert.fail('Expected exception');
    } catch (DmlException e) {
        Assert.isTrue(e.getMessage().contains('Delete failed'));
    }
}
```

### exceptionOnDeletesFor

Throw an exception only for delete operations on a specific SObject type.

**Signature**

```apex
DML.mock(String identifier).exceptionOnDeletesFor(SObjectType objectType);
```

**Test**

```apex
@IsTest
static void shouldThrowExceptionOnlyForAccountDeletes() {
    // Setup - Exception only for Account deletes
    DML.mock('myDmlId').exceptionOnDeletesFor(Account.SObjectType);

    Id accountId = DML.randomIdGenerator.get(Account.SObjectType);
    Id contactId = DML.randomIdGenerator.get(Contact.SObjectType);

    // Test & Verify
    try {
        new DML()
            .toDelete(accountId)
            .toDelete(contactId)
            .identifier('myDmlId')
            .commitWork();
        Assert.fail('Expected exception');
    } catch (DmlException e) {
        Assert.isTrue(e.getMessage().contains('Delete failed'));
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
    DML.mock('myDmlId').exceptionOnDeletes();

    Id accountId = DML.randomIdGenerator.get(Account.SObjectType);

    // Test - no exception thrown
    DML.Result result = new DML()
        .toDelete(accountId)
        .allowPartialSuccess()
        .identifier('myDmlId')
        .commitWork();

    // Verify
    DML.OperationResult operationResult = result.deletesOf(Account.SObjectType);

    Assert.isTrue(operationResult.hasFailures(), 'Should have failures');
    Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Record should be marked as failed');
}
```
