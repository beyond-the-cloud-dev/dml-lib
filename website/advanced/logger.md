---
outline: deep
---

# Error Logger

Capture every failed DML operation in one place — log it, or persist the failed records as a dead letter queue for review and resubmission.

Create a top-level class that implements `DML.Logger`. No registration is needed — the library discovers the implementation automatically and calls it whenever a real DML operation fails.

**Signature**

```apex
public interface Logger {
    void log(OperationResult result);
}
```

The logger receives the same [`DML.OperationResult`](/result) that `commitWork()` returns for the operation, with one addition — `exception()`:

```apex
Exception exception(); // null unless the whole operation threw
```

**Example**

```apex
public class DmlErrorLogger implements DML.Logger {
    public void log(DML.OperationResult result) {
        System.debug(LoggingLevel.ERROR, result.operationType() + ' failed for ' + result.objectType());

        for (DML.RecordResult recordResult : result.recordResults()) {
            if (recordResult.isSuccess()) {
                continue;
            }

            for (DML.Error error : recordResult.errors()) {
                System.debug(LoggingLevel.ERROR, error.statusCode() + ': ' + error.message());
            }
            // Persist recordResult.record() to reprocess it later.
        }
    }
}
```

That is all — from now on every failed DML executed via the library is passed to `DmlErrorLogger.log(...)`.

## When the Logger is Called

| Scenario | `exception()` | `failures()` |
|----------|---------------|--------------|
| `allOrNone=true` (default) — the operation throws | The thrown exception, rethrown after logging | All processed records — everything is rolled back, so every record failed. Records identified by the `DmlException` carry their row errors. |
| `allowPartialSuccess()` — records fail individually | `null` | Only the records rejected by the platform, each with its errors |

The logger is **not** called for mocked operations, or for validation errors raised before the DML runs (such as `Only existing records can be updated.`) — only for failures of real database operations.

::: tip
`failures()`, `errors()` and `recordResults()` describe the failed records in both modes, so a dead letter queue implementation does not need to check which mode was used. Use `exception()` only when you want the stack trace of an all-or-none failure.
:::

::: warning
A `DML.Logger` implementation must not throw. The library does not guard against it, so an exception raised inside `log()` replaces the DML failure that was being reported.
:::

## Discovery

The implementation is resolved via `ApexTypeImplementor` — the first concrete class implementing `DML.Logger` found in the org is used. Keep exactly one implementation in your org.

::: warning
The logger must be a **top-level class**. `ApexTypeImplementor` does not index inner classes, so a logger nested inside another class is never discovered and logging silently does nothing.
:::
