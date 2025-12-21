---
outline: deep
---

# Undelete

Mock undelete operations in unit tests to avoid actual database undeletes.

::: warning
The `DML.mock()` and `DML.retrieveResultFor()` methods are `@TestVisible` and should only be used in test classes.
:::

::: tip
- **No database operations**: Mocked undeletes don't touch the database
- **Results are captured**: All operation details are available via `DML.retrieveResultFor()`
- **Selective mocking**: Use `undeletesFor()` to mock specific SObject types while allowing others to execute
:::

**Example**

```apex
public class AccountService {
    public void restoreDeletedAccounts() {
        List<Account> accounts = [SELECT Id FROM Account WHERE IsDeleted = true ALL ROWS];

        new DML()
            .toUndelete(accounts)
            .identifier('AccountService.restoreDeletedAccounts')
            .commitWork();
    }
}
```

```apex
@IsTest
static void shouldRestoreDeletedAccounts() {
    // Setup
    DML.mock('AccountService.restoreDeletedAccounts').allUndeletes();

    // Test
    Test.startTest();
    new AccountService().restoreDeletedAccounts();
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('AccountService.restoreDeletedAccounts');

    DML.OperationResult accountResult = result.undeletesOf(Account.SObjectType);
    Assert.isFalse(accountResult.hasFailures(), 'No failures expected');
}
```

## allUndeletes

Mock all undelete operations regardless of SObject type.

**Signature**

```apex
DML.mock(String identifier).allUndeletes();
```

**Class**

```apex
public class DataService {
    public void restoreDeletedRecords() {
        List<Account> accounts = [SELECT Id FROM Account WHERE IsDeleted = true ALL ROWS];
        List<Contact> contacts = [SELECT Id FROM Contact WHERE IsDeleted = true ALL ROWS];

        new DML()
            .toUndelete(accounts)
            .toUndelete(contacts)
            .identifier('DataService.restoreDeletedRecords')
            .commitWork();
    }
}
```

**Test**

```apex
@IsTest
static void shouldMockMultipleSObjectTypes() {
    // Setup
    DML.mock('DataService.restoreDeletedRecords').allUndeletes();

    // Test
    Test.startTest();
    new DataService().restoreDeletedRecords();
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('DataService.restoreDeletedRecords');

    Assert.areEqual(2, result.undeletes().size(), '2 SObject types mocked');
}
```

## undeletesFor

Mock undelete operations only for a specific SObject type. Other SObject types will be undeleted in the database.

**Signature**

```apex
DML.mock(String identifier).undeletesFor(SObjectType objectType);
```

**Class**

```apex
public class DataService {
    public void restoreDeletedRecords() {
        List<Account> accounts = [SELECT Id FROM Account WHERE IsDeleted = true ALL ROWS];
        List<Contact> contacts = [SELECT Id FROM Contact WHERE IsDeleted = true ALL ROWS];

        new DML()
            .toUndelete(accounts)
            .toUndelete(contacts)
            .identifier('DataService.restoreDeletedRecords')
            .commitWork();
    }
}
```

**Test**

```apex
@IsTest
static void shouldMockOnlyAccountUndeletes() {
    // Setup - Mock only Account undeletes
    DML.mock('DataService.restoreDeletedRecords').undeletesFor(Account.SObjectType);

    // Test
    Test.startTest();
    new DataService().restoreDeletedRecords();
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('DataService.restoreDeletedRecords');

    Assert.areEqual(2, result.undeletes().size(), '2 SObject types in result');
    // Account was mocked, Contact was actually undeleted
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
    public void restoreAccount(Id accountId) {
        new DML()
            .toUndelete(accountId)
            .identifier('AccountService.restoreAccount')
            .commitWork();
    }
}
```

**Test**

```apex
@IsTest
static void shouldAccessRecordResults() {
    // Setup
    DML.mock('AccountService.restoreAccount').allUndeletes();

    // Test
    Test.startTest();
    new AccountService().restoreAccount(DML.randomIdGenerator.get(Account.SObjectType));
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('AccountService.restoreAccount');
    DML.OperationResult operationResult = result.undeletesOf(Account.SObjectType);

    Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Should be Account type');
    Assert.areEqual(DML.OperationType.UNDELETE_DML, operationResult.operationType(), 'Should be UNDELETE operation');
    Assert.isFalse(operationResult.hasFailures(), 'Should have no failures');
}
```

## Exception

Simulate DML exceptions for undelete operations without touching the database.

::: tip allowPartialSuccess
When `allowPartialSuccess()` is used, exceptions are **not thrown**. Instead, failures are recorded in the `Result` object. Use `hasFailures()` and `recordResults()` to check for errors.
:::

### exceptionOnUndeletes

Throw an exception for all undelete operations.

**Signature**

```apex
DML.mock(String identifier).exceptionOnUndeletes();
```

**Test**

```apex
@IsTest
static void shouldThrowExceptionOnUndelete() {
    // Setup
    DML.mock('myDmlId').exceptionOnUndeletes();

    Id accountId = DML.randomIdGenerator.get(Account.SObjectType);

    // Test & Verify
    try {
        new DML()
            .toUndelete(accountId)
            .identifier('myDmlId')
            .commitWork();
        Assert.fail('Expected exception');
    } catch (DmlException e) {
        Assert.isTrue(e.getMessage().contains('Undelete failed'));
    }
}
```

### exceptionOnUndeletesFor

Throw an exception only for undelete operations on a specific SObject type.

**Signature**

```apex
DML.mock(String identifier).exceptionOnUndeletesFor(SObjectType objectType);
```

**Test**

```apex
@IsTest
static void shouldThrowExceptionOnlyForAccountUndeletes() {
    // Setup - Exception only for Account undeletes
    DML.mock('myDmlId').exceptionOnUndeletesFor(Account.SObjectType);

    Id accountId = DML.randomIdGenerator.get(Account.SObjectType);
    Id contactId = DML.randomIdGenerator.get(Contact.SObjectType);

    // Test & Verify
    try {
        new DML()
            .toUndelete(accountId)
            .toUndelete(contactId)
            .identifier('myDmlId')
            .commitWork();
        Assert.fail('Expected exception');
    } catch (DmlException e) {
        Assert.isTrue(e.getMessage().contains('Undelete failed'));
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
    DML.mock('myDmlId').exceptionOnUndeletes();

    Id accountId = DML.randomIdGenerator.get(Account.SObjectType);

    // Test - no exception thrown
    DML.Result result = new DML()
        .toUndelete(accountId)
        .allowPartialSuccess()
        .identifier('myDmlId')
        .commitWork();

    // Verify
    DML.OperationResult operationResult = result.undeletesOf(Account.SObjectType);

    Assert.isTrue(operationResult.hasFailures(), 'Should have failures');
    Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Record should be marked as failed');
}
```
