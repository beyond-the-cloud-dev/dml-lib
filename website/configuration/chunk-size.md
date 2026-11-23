---
outline: deep
---

# Chunk Size

Limit how many records go into a single DML statement.

By default, every operation runs as one DML statement per SObject type — 1,000 accounts are inserted with one `Database.insert`. `chunkSize()` splits each operation into statements of at most the given number of records, all in the same transaction.

**Signature**

```apex
Committable chunkSize(Integer chunkSize);
```

**Standard DML**

```apex
List<Account> accounts = ...; // 1000 accounts

List<Account> chunk = new List<Account>();

for (Account acc : accounts) {
    chunk.add(acc);

    if (chunk.size() == 50) {
        insert chunk;
        chunk = new List<Account>();
    }
}

if (!chunk.isEmpty()) {
    insert chunk;
}
```

**DML Lib**

```apex
List<Account> accounts = ...; // 1000 accounts

new DML()
    .toInsert(accounts)
    .chunkSize(50)
    .commitWork(); // 20 DML statements, 50 records each
```

## How It Works

- The chunk size applies to every operation of the unit of work — insert, update, upsert, delete, hard delete, undelete, merge and publish — and to the `*Immediately` methods.
- Records are validated before the first chunk is executed, so a [validation error](/architecture/registration#deferred-validation) never leaves part of an operation committed.
- Chunks run within the [dependency order](/architecture/registration#registration-order) — parents are still committed before their children.
- The result does not change shape. `result.insertsOf(Account.SObjectType)` returns one `OperationResult` with the records of all chunks, and every chunk shares the operation's [`operationId()`](/advanced/logger#error-id).
- A [`DML.Logger`](/advanced/logger) is called once per failed chunk, with the records of that chunk only.

**Example**

```apex
List<Account> accounts = ...; // 1000 accounts
List<Contact> contacts = ...; // 300 contacts

DML.Result result = new DML()
    .toInsert(accounts)
    .toInsert(contacts)
    .chunkSize(200)
    .commitWork(); // 5 Account inserts + 2 Contact inserts = 7 DML statements

result.insertsOf(Account.SObjectType).records().size(); // 1000
```

## When to Use It

Salesforce already passes records to triggers and record-triggered flows in batches of 200. A chunk size **below 200** makes those batches smaller, which helps when the automation's cost per batch grows faster than the number of records — nested loops over `Trigger.new`, large in-memory maps, or heap spikes.

::: warning
All chunks run in the **same transaction**. Governor limits such as SOQL queries, CPU time and DML rows are not reset between chunks — an automation that runs one query per record fails at the same total either way.

Each chunk is a separate DML statement and counts against the limit of 150 DML statements per transaction. A chunk size of 200 or more does not change what triggers and flows receive; it only adds statements.
:::

## Failures

**All or none (default)**

When a chunk fails, the `DmlException` is thrown and the remaining chunks are not executed. `commitWork()` does not use a savepoint, so chunks that were already executed stay committed if the exception is caught. Use `commitTransaction()` to roll back all chunks — see [Rollback](/architecture/rollback).

```apex
List<Account> accounts = new List<Account>{
    new Account(Name = 'Account 1'),
    new Account(Name = 'Account 2'),
    new Account(), // Name is required
    new Account(Name = 'Account 4')
};

try {
    new DML()
        .toInsert(accounts)
        .chunkSize(2)
        .commitWork();
} catch (DmlException e) {
    // Account 1 and Account 2 are committed, the second chunk is not
}

try {
    new DML()
        .toInsert(accounts)
        .chunkSize(2)
        .commitTransaction();
} catch (DmlException e) {
    // no account is committed
}
```

**Partial success**

With `allowPartialSuccess()`, every chunk is executed and the failures of all chunks are collected in one result.

```apex
DML.Result result = new DML()
    .toInsert(accounts)
    .chunkSize(2)
    .allowPartialSuccess()
    .commitWork();

DML.OperationResult operationResult = result.insertsOf(Account.SObjectType);

operationResult.successes().size(); // 3
operationResult.failures().size(); // 1
```
