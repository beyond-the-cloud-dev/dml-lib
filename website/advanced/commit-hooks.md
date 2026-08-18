---
outline: deep
---

# Commit Hooks

Run custom logic immediately before and after a commit executes, such as centralized logging, telemetry, or pre-commit assertions.

**Example**

```apex
List<Account> accounts = new List<Account>{
    new Account(Name = 'Beyond The Cloud'),
    new Account(Name = 'Salesforce')
};

new DML()
    .commitHook(new CommitLogger())
    .toInsert(accounts)
    .commitWork();
```

## Hook

Implement the `DML.Hook` interface to observe commits.

**Signature**

```apex
void before();                 // Runs immediately before registered work executes
void after(DML.Result result); // Runs after all registered operations complete
```

**Example**

```apex
public class CommitLogger implements DML.Hook {
    public void before() {
        System.debug('Commit is about to execute.');
    }

    public void after(DML.Result result) {
        for (DML.OperationResult operationResult : result.all()) {
            System.debug(operationResult.operationType() + ' on ' + operationResult.objectType());
        }
    }
}
```

See [Result](/result) for the full `DML.Result` API available in `after(result)`.

## commitHook

Register a hook on the DML instance.

**Signature**

```apex
Commitable commitHook(DML.Hook callback);
```

**Standard DML**

```apex
System.debug('Commit is about to execute.'); // manual logging around every DML
insert accounts;
update contacts;
System.debug('Commit completed.');
```

**DML Lib**

```apex
new DML()
    .commitHook(new CommitLogger())
    .toInsert(accounts)
    .toUpdate(contacts)
    .commitWork();
```

::: info
Only one hook can be registered per `DML` instance. Registering another hook replaces the previous one.
:::

## When Hooks Fire

- `before()` runs immediately before any registered work executes.
- `after(result)` runs after **all** registered operations complete, receiving the full `DML.Result`.

Hooks fire on `commitWork()`, `commitTransaction()` (which delegates to `commitWork()`), and `dryRun()`.

::: warning
Hooks are **not** invoked by the `*Immediately` methods (`insertImmediately`, `updateImmediately`, etc.).
:::

### Dry Run

During `dryRun()`, hooks fire the same way, but all effects — including any DML performed by the hook itself — are rolled back with the savepoint.

**Example**

```apex
new DML()
    .commitHook(new CommitLogger())
    .toInsert(accounts)
    .dryRun(); // hook fires, but every change is rolled back
```

### Failures

If any DML operation throws (e.g., an `allOrNone` failure), `after(result)` is **not** called — the exception propagates first. On `commitWork()` and `commitTransaction()`, registered work is still cleared; `dryRun()` never clears registered work.

## Hook Lifetime

The hook is part of the instance configuration, not registered work. It survives commits on the same instance — subsequent `commitWork()` calls fire it again.

**Example**

```apex
DML.Commitable dml = new DML().commitHook(new CommitLogger());

dml.toInsert(accounts)
    .commitWork(); // hook fires

dml.toUpdate(contacts)
    .commitWork(); // hook fires again
```

## Complete Example

Log the outcome of every commit in one place.

**Example**

```apex
public class CommitLogger implements DML.Hook {
    public void before() {
        System.debug('Commit is about to execute.');
    }

    public void after(DML.Result result) {
        for (DML.OperationResult operationResult : result.all()) {
            System.debug(
                operationResult.operationType() + ' on ' + operationResult.objectType() +
                ': ' + operationResult.successes().size() + ' succeeded, ' +
                operationResult.failures().size() + ' failed'
            );
        }
    }
}
```

```apex
List<Account> accounts = new List<Account>{
    new Account(Name = 'Beyond The Cloud'),
    new Account(Name = 'Salesforce')
};

new DML()
    .commitHook(new CommitLogger())
    .toInsert(accounts)
    .commitWork();
// DEBUG: Commit is about to execute.
// DEBUG: INSERT_DML on Account: 2 succeeded, 0 failed
```

::: tip
Use commit hooks for centralized logging or telemetry of every commit, publishing audit data from the [Result](/result), or pre-commit assertions.
:::
