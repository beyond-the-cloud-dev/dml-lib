---
outline: deep
---

# Execution Control

Control the lifecycle of a unit of work — discard registered operations before they execute, and inspect the current configuration for debugging.

**Example**

```apex
DML.Commitable unitOfWork = new DML()
    .toInsert(account)
    .toInsert(contact)
    .systemMode();

if (!isAccountEligible) {
    unitOfWork.discardWork(); // drop all registered operations
}

unitOfWork.commitWork(); // executes nothing when work was discarded
```

## discardWork

Drop all registered but uncommitted operations without executing any DML.

**Signature**

```apex
Commitable discardWork();
```

`discardWork()` clears only the queued work — the configuration (access mode, sharing mode, DML options, identifier, and commit hook) is kept. Calling `commitWork()` after `discardWork()` executes nothing, consumes zero DML statements, and returns an empty `Result`.

**Standard DML**

```apex
List<Account> accountsToInsert = new List<Account>();
accountsToInsert.add(new Account(Name = 'Acme'));
accountsToInsert.add(new Account(Name = 'Globex'));

if (isAccountEligible) {
    insert accountsToInsert;
}
```

**DML Lib**

```apex
DML.Commitable unitOfWork = new DML()
    .toInsert(new Account(Name = 'Acme'))
    .toInsert(new Account(Name = 'Globex'));

if (!isAccountEligible) {
    unitOfWork.discardWork();
}

unitOfWork.commitWork();
```

::: tip
Use `discardWork()` to abandon a partially-built unit of work when a business condition fails, without throwing an exception.
:::

### Configuration Is Kept

Only the registered operations are discarded. The same instance can be reused with its existing configuration.

**Example**

```apex
DML.Commitable unitOfWork = new DML()
    .toInsert(invalidAccount)
    .systemMode()
    .allowPartialSuccess();

unitOfWork.discardWork(); // invalidAccount will not be inserted

unitOfWork
    .toInsert(validAccount) // systemMode() and allowPartialSuccess() still apply
    .commitWork();
```

## preview

Print the current configuration to the debug logs.

**Signature**

```apex
void preview();
```

`preview()` debug-prints the `Database.DmlOptions` as pretty JSON, the sharing executor in effect, the `allOrNone` flag, and the DML identifier. It does not list registered records.

**Example**

```apex
DML.Commitable unitOfWork = new DML()
    .toInsert(account)
    .systemMode();

unitOfWork.preview();
unitOfWork.commitWork();
```

::: tip
`preview()` logs at the `ERROR` logging level, so the output is visible under any debug log filter.
:::

::: warning
`preview()` returns `void`, so it cannot be chained in the middle of a fluent call. Hold the `DML.Commitable` instance in a variable, call `preview()`, then continue with `commitWork()`.
:::

::: info
To validate the whole unit of work against the database without persisting anything, see `dryRun()` on the [Result](/result) page — it executes every operation inside a savepoint and always rolls back (real DML limits are consumed). For savepoint-backed atomic commits, see `commitTransaction()` on the [Rollback](/architecture/rollback) page.
:::
