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
    DML.OperationResult opResult = result.mergesOf(Account.SObjectType);

    // Check operation metadata
    Assert.areEqual(Account.SObjectType, opResult.objectType(), 'Should be Account type');
    Assert.areEqual(DML.OperationType.MERGE_DML, opResult.operationType(), 'Should be MERGE operation');
    Assert.isFalse(opResult.hasFailures(), 'Should have no failures');

    // Check record results
    List<DML.RecordResult> recordResults = opResult.recordResults();
    Assert.areEqual(1, recordResults.size(), 'Should have 1 record result');
    Assert.isTrue(recordResults[0].isSuccess(), 'Record should be successful');
    Assert.isNotNull(recordResults[0].id(), 'Record should have mocked ID');
}
```

