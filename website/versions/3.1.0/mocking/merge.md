---
outline: deep
---

# Merge

Mock merge operations in unit tests to avoid actual database merges.

::: warning
The `DML.mock()` and `DML.retrieveResultFor()` methods are `@TestVisible` and should only be used in test classes.
:::

::: tip
- **No database operations**: Mocked merges don't touch the database
- **Records must have IDs**: Both master and duplicate records must have IDs assigned before mocking
- **Results are captured**: All operation details are available via `DML.retrieveResultFor()`
- **Selective mocking**: Use `mergesFor()` to mock specific SObject types while allowing others to execute
:::

**Example**

```apex
public class AccountService {
    public void mergeAccounts(Id masterId, Id duplicateId) {
        Account master = [SELECT Id FROM Account WHERE Id = :masterId];
        Account duplicate = [SELECT Id FROM Account WHERE Id = :duplicateId];

        new DML()
            .toMerge(master, duplicate)
            .identifier('AccountService.mergeAccounts')
            .commitWork();
    }
}
```

```apex
@IsTest
static void shouldMergeAccounts() {
    // Setup
    Account master = new Account(
        Id = DML.randomIdGenerator.get(Account.SObjectType), 
        Name = 'Master'
    );
    Account duplicate = new Account(
        Id = DML.randomIdGenerator.get(Account.SObjectType), 
        Name = 'Duplicate'
    );

    DML.mock('AccountService.mergeAccounts').allMerges();

    // Test
    Test.startTest();
    new AccountService().mergeAccounts(master.Id, duplicate.Id);
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('AccountService.mergeAccounts');

    DML.OperationResult mergeResult = result.mergesOf(Account.SObjectType);
    Assert.areEqual(1, mergeResult.successes().size(), '1 merge should succeed');
}
```

## allMerges

Mock all merge operations regardless of SObject type.

**Signature**

```apex
DML.mock(String identifier).allMerges();
```

**Class**

```apex
public class MergeService {
    public void mergeDuplicates(Account master, Account duplicate) {
        new DML()
            .toMerge(master, duplicate)
            .identifier('MergeService.mergeDuplicates')
            .commitWork();
    }
}
```

**Test**

```apex
@IsTest
static void shouldMockMergeOperation() {
    // Setup
    Account master = new Account(
        Id = DML.randomIdGenerator.get(Account.SObjectType)
        Name = 'Master'
    );
    Account duplicate = new Account(
        Id = DML.randomIdGenerator.get(Account.SObjectType)
        Name = 'Duplicate'
    );

    DML.mock('MergeService.mergeDuplicates').allMerges();

    // Test
    Test.startTest();
    new MergeService().mergeDuplicates(master, duplicate);
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('MergeService.mergeDuplicates');

    Assert.areEqual(1, result.merges().size(), '1 merge operation mocked');
    Assert.isTrue(result.mergesOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Merge should succeed');
    Assert.isNotNull(result.mergesOf(Account.SObjectType).recordResults()[0].id(), 'Should have mocked record Id');
}
```

## mergesFor

Mock merge operations only for a specific SObject type. Other SObject types will be merged in the database.

**Signature**

```apex
DML.mock(String identifier).mergesFor(SObjectType objectType);
```

**Test**

```apex
@IsTest
static void shouldMockOnlyLeadMerges() {
    // Setup - Real accounts, mocked leads
    Account masterAcc = new Account(Name = 'Master Account');
    Account dupAcc = new Account(Name = 'Duplicate Account');
    insert new List<Account>{ masterAcc, dupAcc };

    Lead masterLead = new Lead(
        Id = DML.randomIdGenerator.get(Lead.SObjectType),
        LastName = 'Master', 
        Company = 'Test'
    );
    Lead dupLead = new Lead(
        Id = DML.randomIdGenerator.get(Lead.SObjectType),
        LastName = 'Duplicate', 
        Company = 'Test'
    );

    DML.mock('MergeService.mergeRecords').mergesFor(Lead.SObjectType);

    // Test
    Test.startTest();
        new DML()
            .toMerge(masterAcc, dupAcc)
            .toMerge(masterLead, dupLead)
            .identifier('MergeService.mergeRecords')
            .commitWork();
    Test.stopTest();

    // Verify
    Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account merge executed - only master remains');
    Assert.areEqual(1, result.mergesOf(Lead.SObjectType).successes().size(), 'Lead merge mocked');
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
public class MergeService {
    public void mergeAccounts(Account master, Account duplicate) {
        new DML()
            .toMerge(master, duplicate)
            .identifier('MergeService.mergeAccounts')
            .commitWork();
    }
}
```

**Test**

```apex
@IsTest
static void shouldAccessMergeResults() {
    // Setup
    Account master = new Account(
        Id = DML.randomIdGenerator.get(Account.SObjectType),
        Name = 'Master'
    );
    Account duplicate = new Account(
        Id = DML.randomIdGenerator.get(Account.SObjectType),
        Name = 'Duplicate'
    );

    DML.mock('MergeService.mergeAccounts').allMerges();

    // Test
    Test.startTest();
    new MergeService().mergeAccounts(master, duplicate);
    Test.stopTest();

    // Verify
    DML.Result result = DML.retrieveResultFor('MergeService.mergeAccounts');
    DML.OperationResult operationResult = result.mergesOf(Account.SObjectType);

    // Check operation metadata
    Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Should be Account type');
    Assert.areEqual(DML.OperationType.MERGE_DML, operationResult.operationType(), 'Should be MERGE operation');
    Assert.isFalse(operationResult.hasFailures(), 'Should have no failures');

    // Check record results
    List<DML.RecordResult> recordResults = operationResult.recordResults();
    Assert.areEqual(1, recordResults.size(), 'Should have 1 record result');
    Assert.isTrue(recordResults[0].isSuccess(), 'Record should be successful');
    Assert.isNotNull(recordResults[0].id(), 'Record should have mocked ID');
}
```

## Exception

Simulate DML exceptions for merge operations without touching the database.

::: tip allowPartialSuccess
When `allowPartialSuccess()` is used, exceptions are **not thrown**. Instead, failures are recorded in the `Result` object. Use `hasFailures()` and `recordResults()` to check for errors.
:::

### exceptionOnMerges

Throw an exception for all merge operations.

**Signature**

```apex
DML.mock(String identifier).exceptionOnMerges();
```

**Test**

```apex
@IsTest
static void shouldThrowExceptionOnMerge() {
    // Setup
    Account master = new Account(
        Id = DML.randomIdGenerator.get(Account.SObjectType),
        Name = 'Master'
    );
    Account duplicate = new Account(
        Id = DML.randomIdGenerator.get(Account.SObjectType),
        Name = 'Duplicate'
    );

    DML.mock('myDmlId').exceptionOnMerges();

    // Test & Verify
    try {
        new DML()
            .toMerge(master, duplicate)
            .identifier('myDmlId')
            .commitWork();
        Assert.fail('Expected exception');
    } catch (DmlException e) {
        Assert.isTrue(e.getMessage().contains('Merge failed'));
    }
}
```

### exceptionOnMergesFor

Throw an exception only for merge operations on a specific SObject type.

**Signature**

```apex
DML.mock(String identifier).exceptionOnMergesFor(SObjectType objectType);
```

**Test**

```apex
@IsTest
static void shouldThrowExceptionOnlyForLeadMerges() {
    // Setup - Exception only for Lead merges
    Lead masterLead = new Lead(
        Id = DML.randomIdGenerator.get(Lead.SObjectType),
        LastName = 'Master',
        Company = 'Test'
    );
    Lead dupLead = new Lead(
        Id = DML.randomIdGenerator.get(Lead.SObjectType),
        LastName = 'Duplicate',
        Company = 'Test'
    );

    DML.mock('myDmlId').exceptionOnMergesFor(Lead.SObjectType);

    // Test & Verify
    try {
        new DML()
            .toMerge(masterLead, dupLead)
            .identifier('myDmlId')
            .commitWork();
        Assert.fail('Expected exception');
    } catch (DmlException e) {
        Assert.isTrue(e.getMessage().contains('Merge failed'));
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
    Account master = new Account(
        Id = DML.randomIdGenerator.get(Account.SObjectType),
        Name = 'Master'
    );
    Account duplicate = new Account(
        Id = DML.randomIdGenerator.get(Account.SObjectType),
        Name = 'Duplicate'
    );

    DML.mock('myDmlId').exceptionOnMerges();

    // Test - no exception thrown
    DML.Result result = new DML()
        .toMerge(master, duplicate)
        .allowPartialSuccess()
        .identifier('myDmlId')
        .commitWork();

    // Verify
    DML.OperationResult operationResult = result.mergesOf(Account.SObjectType);

    Assert.isTrue(operationResult.hasFailures(), 'Should have failures');
    Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Record should be marked as failed');
}
```
