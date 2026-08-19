---
outline: deep
---

# Insert

Mock insert operations in unit tests to avoid actual database inserts.

::: warning
The `DML.mock()` and `DML.retrieveResultFor()` methods are `@TestVisible` and should only be used in test classes.
:::

::: tip
- **No database operations**: Mocked inserts don't touch the database
- **IDs are assigned**: Records receive valid mocked IDs that can be used in relationships
- **Results are captured**: All operation details are available via `DML.retrieveResultFor()`
- **Selective mocking**: Use `insertsFor()` to mock specific SObject types while allowing others to execute
:::

**Example**

```apex
public class AccountService {
    public void createAccountWithContacts() {
        Account account = new Account(Name = 'Test Account');
        Contact contact = new Contact(LastName = 'Doe');

        new DML()
            .toInsert(account)
            .toInsert(DML.Record(contact).withRelationship(Contact.AccountId, account))
            .identifier('AccountService.createAccountWithContacts')
            .commitWork();
    }
}
```

```apex
@IsTest
static void shouldCreateAccountWithContacts() {
    // Setup
    DML.mock('AccountService.createAccountWithContacts').allInserts();

    // Test
    Test.startTest();
    new AccountService().createAccountWithContacts();
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('AccountService.createAccountWithContacts');

    Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be in database');

    DML.OperationResult accountResult = result.insertsOf(Account.SObjectType);
    Assert.areEqual(1, accountResult.successes().size(), '1 account should be inserted');

    DML.OperationResult contactResult = result.insertsOf(Contact.SObjectType);
    Assert.areEqual(1, contactResult.successes().size(), '1 contact should be inserted');
}
```

## allInserts

Mock all insert operations regardless of SObject type.

**Signature**

```apex
DML.mock(String identifier).allInserts();
```

**Class**

```apex
public class DataService {
    public void createRecords() {
        Account account = new Account(Name = 'Test Account');
        Contact contact = new Contact(LastName = 'Doe');

        new DML()
            .toInsert(account)
            .toInsert(contact)
            .identifier('DataService.createRecords')
            .commitWork();
    }
}
```

**Test**

```apex
@IsTest
static void shouldMockMultipleSObjectTypes() {
    // Setup
    DML.mock('DataService.createRecords').allInserts();

    // Test
    Test.startTest();
    new DataService().createRecords();
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('DataService.createRecords');

    Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No accounts in database');
    Assert.areEqual(0, [SELECT COUNT() FROM Contact], 'No contacts in database');
    Assert.areEqual(2, result.inserts().size(), '2 SObject types mocked');
}
```

## insertsFor

Mock insert operations only for a specific SObject type. Other SObject types will be inserted into the database.

**Signature**

```apex
DML.mock(String identifier).insertsFor(SObjectType objectType);
```

**Class**

```apex
public class DataService {
    public void createRecords() {
        Account account = new Account(Name = 'Test Account');
        Contact contact = new Contact(LastName = 'Doe');

        new DML()
            .toInsert(account)
            .toInsert(contact)
            .identifier('DataService.createRecords')
            .commitWork();
    }
}
```

**Test**

```apex
@IsTest
static void shouldMockOnlyAccountInserts() {
    // Setup - Mock only Account inserts
    DML.mock('DataService.createRecords').insertsFor(Account.SObjectType);

    // Test
    Test.startTest();
    new DataService().createRecords();
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('DataService.createRecords');

    Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Account mocked - not in database');
    Assert.areEqual(1, [SELECT COUNT() FROM Contact], 'Contact actually inserted');
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
    public void createAccount() {
        Account account = new Account(Name = 'Test Account');

        new DML()
            .toInsert(account)
            .identifier('AccountService.createAccount')
            .commitWork();
    }
}
```

**Test**

```apex
@IsTest
static void shouldAccessRecordResults() {
    // Setup
    DML.mock('AccountService.createAccount').allInserts();

    // Test
    Test.startTest();
    new AccountService().createAccount();
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('AccountService.createAccount');
    DML.OperationResult operationResult = result.insertsOf(Account.SObjectType);

    // Check operation metadata
    Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Should be Account type');
    Assert.areEqual(DML.OperationType.INSERT_DML, operationResult.operationType(), 'Should be INSERT operation');
    Assert.isFalse(operationResult.hasFailures(), 'Should have no failures');

    // Check record results
    List<DML.RecordResult> recordResults = operationResult.recordResults();
    Assert.areEqual(1, recordResults.size(), 'Should have 1 record result');
    Assert.isTrue(recordResults[0].isSuccess(), 'Record should be successful');
    Assert.isNotNull(recordResults[0].id(), 'Record should have mocked ID');
}
```

## Exception

Simulate DML exceptions for insert operations without touching the database.

::: tip allowPartialSuccess
When `allowPartialSuccess()` is used, exceptions are **not thrown**. Instead, failures are recorded in the `Result` object. 
Use `hasFailures()` and `recordResults()` to check for errors.
:::

### exceptionOnInserts

Throw an exception for all insert operations.

**Signature**

```apex
DML.mock(String identifier).exceptionOnInserts();
```

**Test**

```apex
@IsTest
static void shouldThrowExceptionOnInsert() {
    // Setup
    DML.mock('myDmlId').exceptionOnInserts();

    // Test & Verify
    try {
        new DML()
            .toInsert(new Account(Name = 'Test Account'))
            .identifier('myDmlId')
            .commitWork();
        Assert.fail('Expected exception');
    } catch (DmlException e) {
        Assert.isTrue(e.getMessage().contains('Insert failed'));
    }
}
```

### exceptionOnInsertsFor

Throw an exception only for insert operations on a specific SObject type.

**Signature**

```apex
DML.mock(String identifier).exceptionOnInsertsFor(SObjectType objectType);
```

**Test**

```apex
@IsTest
static void shouldThrowExceptionOnlyForAccountInserts() {
    // Setup - Exception only for Account inserts
    DML.mock('myDmlId').exceptionOnInsertsFor(Account.SObjectType);

    // Test & Verify
    try {
        new DML()
            .toInsert(new Account(Name = 'Test Account'))
            .toInsert(new Contact(LastName = 'Doe'))
            .identifier('myDmlId')
            .commitWork();
        Assert.fail('Expected exception');
    } catch (DmlException e) {
        Assert.isTrue(e.getMessage().contains('Insert failed'));
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
    DML.mock('myDmlId').exceptionOnInserts();

    // Test - no exception thrown
    DML.Result result = new DML()
        .toInsert(new Account(Name = 'Test Account'))
        .allowPartialSuccess()
        .identifier('myDmlId')
        .commitWork();

    // Verify
    DML.OperationResult operationResult = result.insertsOf(Account.SObjectType);

    Assert.isTrue(operationResult.hasFailures(), 'Should have failures');
    Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Record should be marked as failed');
}
```
