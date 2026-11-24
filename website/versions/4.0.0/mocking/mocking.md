---
outline: deep
---

# Mocking

Mock DML operations in unit tests to avoid actual database changes while still verifying your code's behavior.

## How It Works

1. **Add an identifier** to your DML operation in the production code
2. **Register a mock** for that identifier in your test
3. **Execute the code** - DML operations are intercepted, no database changes occur
4. **Verify results** using `DML.retrieveResultFor()`

## Quick Example

**Class**

```apex
public class AccountService {
    public void createAccount() {
        new DML()
            .toInsert(new Account(Name = 'Acme'))
            .identifier('AccountService.createAccount')
            .commitWork();
    }
}
```

**Test**

```apex
@IsTest
static void shouldCreateAccount() {
    // 1. Register mock
    DML.mock('AccountService.createAccount').allInserts();

    // 2. Execute
    Test.startTest();
    new AccountService().createAccount();
    Test.stopTest();

    // 3. Verify - no records in database, but results captured
    DML.Result result = DML.retrieveResultFor('AccountService.createAccount');
    Assert.areEqual(1, result.insertsOf(Account.SObjectType).successes().size());
}
```

## Key Benefits

- **Fast tests** - No database operations means faster execution
- **IDs assigned** - Records receive valid mock IDs for relationship testing
- **Selective mocking** - Mock specific SObject types while allowing others to execute
- **Exception simulation** - Test error handling without real failures

## Available Methods

```apex
// Mock all operations
Mockable allDmls();

// Mock by operation type
Mockable allInserts();
Mockable allUpdates();
Mockable allUpserts();
Mockable allDeletes();
Mockable allUndeletes();
Mockable allMerges();
Mockable allPublishes();

// Mock by SObject type
Mockable insertsFor(SObjectType objectType);
Mockable updatesFor(SObjectType objectType);
Mockable upsertsFor(SObjectType objectType);
Mockable deletesFor(SObjectType objectType);
Mockable undeletesFor(SObjectType objectType);
Mockable mergesFor(SObjectType objectType);
Mockable publishesFor(SObjectType objectType);

// Simulate exceptions
Mockable exceptionOnInserts();
Mockable exceptionOnUpdates();
Mockable exceptionOnUpserts();
Mockable exceptionOnDeletes();
Mockable exceptionOnUndeletes();
Mockable exceptionOnMerges();
Mockable exceptionOnPublishes();

// Simulate exceptions for specific SObject type
Mockable exceptionOnInsertsFor(SObjectType objectType);
Mockable exceptionOnUpdatesFor(SObjectType objectType);
Mockable exceptionOnUpsertsFor(SObjectType objectType);
Mockable exceptionOnDeletesFor(SObjectType objectType);
Mockable exceptionOnUndeletesFor(SObjectType objectType);
Mockable exceptionOnMergesFor(SObjectType objectType);
Mockable exceptionOnPublishesFor(SObjectType objectType);
```
