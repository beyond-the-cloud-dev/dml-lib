---
outline: deep
---

# Shared Instance

Use `DML.Shared` as a transaction-wide unit of work — service methods register records on the shared instance, and a single owner commits all of them at once.

::: warning
Work registered on `DML.Shared` that is never committed is silently discarded at the end of the transaction. Make one clear owner (a controller, a batch `execute`, or a trigger handler) responsible for calling `commitWork()`.
:::

**Example**

```apex
public inherited sharing class AccountService {
    public void markAsPartner(List<Account> accounts) {
        for (Account account : accounts) {
            account.Type = 'Partner';
        }

        DML.Shared.toUpdate(accounts); // registered, not committed
    }
}

public inherited sharing class TaskService {
    public void createFollowUpTasks(List<Account> accounts) {
        List<Task> followUpTasks = new List<Task>();

        for (Account account : accounts) {
            followUpTasks.add(new Task(
                Subject = 'Follow up with partner',
                WhatId = account.Id
            ));
        }

        DML.Shared.toInsert(followUpTasks); // registered, not committed
    }
}

public with sharing class PartnerOnboardingController {
    public static void onboardPartners(List<Account> accounts) {
        new AccountService().markAsPartner(accounts);
        new TaskService().createFollowUpTasks(accounts);

        DML.Shared.commitWork(); // one owner commits all registered work
    }
}
```

## Shared

A lazily-initialized, transaction-wide singleton `DML` instance. It supports the entire fluent API — `toInsert`, `toUpdate`, configuration methods, `identifier`, `commitWork`, `discardWork`, and more — exactly like `new DML()`.

**Signature**

```apex
public static Commitable Shared { get; }
```

Because every class in the transaction sees the same instance, work registered from different places is bulkified together and committed in minimal DML statements.

**Standard DML**

```apex
// Each service performs its own DML
public void markAsPartner(List<Account> accounts) {
    // ...
    update accounts; // DML statement #1
}

public void createFollowUpTasks(List<Account> accounts) {
    // ...
    insert followUpTasks; // DML statement #2
}
```

**DML Lib**

```apex
// Services only register work
DML.Shared.toUpdate(accounts);
DML.Shared.toInsert(followUpTasks);

// One owner commits everything at once
DML.Shared.commitWork();
```

## Committing Multiple Times

After `commitWork()`, the registered work is cleared — in a `finally` block, so it is cleared even when the commit fails — but the same instance lives on. You can keep registering records and commit again later in the same transaction.

**Example**

```apex
DML.Shared.toInsert(new Account(Name = 'First Batch'));
DML.Shared.commitWork(); // registered work is cleared

DML.Shared.toInsert(new Account(Name = 'Second Batch'));
DML.Shared.commitWork(); // same instance, new work
```

::: tip
`commitWork()` returns a `DML.Result` you can inspect. See [Result](/result) for details.
:::

## Discarding Work

`discardWork()` drops all registrations accumulated on the shared instance without executing any DML. See [Execution Control](/advanced/execution-control) for details.

**Example**

```apex
DML.Shared.toUpdate(accounts);

// Something went wrong — drop everything registered so far
DML.Shared.discardWork();
```

## Sticky Configuration

::: warning
Configuration set on `DML.Shared` is sticky. Modes such as `systemMode()`, `allowPartialSuccess()`, `identifier(...)`, and `commitHook(...)` persist for the rest of the Apex transaction and affect every subsequent user of the shared instance. Prefer a fresh `new DML()` when an operation needs its own configuration.
:::

**Example**

```apex
DML.Shared.allowPartialSuccess(); // affects EVERY later commit on DML.Shared

// Later, in unrelated code
DML.Shared
    .toUpdate(contacts)
    .commitWork(); // still runs with allowPartialSuccess()

// Prefer a dedicated instance for operation-specific configuration
new DML()
    .toUpdate(contacts)
    .allowPartialSuccess()
    .commitWork();
```

## Static Per-Transaction State

::: info
`DML.Shared` is static, per-transaction state. In tests, state does not leak between test methods — each test method runs in its own transaction. Within a single transaction, however, all code shares the same instance, including its registered work and configuration.
:::
