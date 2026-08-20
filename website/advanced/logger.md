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

## Error ID

Every operation gets a random `operationId` — a UUID available on the result through [`operationId()`](/result#operationresult-interface):

```apex
DML.Result result = new DML().toInsert(accounts).commitWork();

System.debug(result.insertsOf(Account.SObjectType).operationId()); // 749d9deb-4e6a-4b0b-8116-5b11a1893eed
```

It is generated per operation and carries no information about the records, so it is safe to show to end users. `includeOperationIdInErrorMessage()` appends it to the exception message:

**Signature**

```apex
Commitable includeOperationIdInErrorMessage();
```

**Example**

```apex
new DML()
    .toInsert(account)
    .includeOperationIdInErrorMessage()
    .commitWork();
```

When the DML fails, the thrown `DmlException` carries the standard message plus the id:

```
Insert failed. First exception on row 0; first error: REQUIRED_FIELD_MISSING, Required fields are missing: [Name]: [Name] | Contact your administrator with Error ID: 749d9deb-4e6a-4b0b-8116-5b11a1893eed
```

::: warning
This option only makes sense together with a `DML.Logger` implementation. The user sees the Error ID in the error message and passes it to their administrator, who finds the matching entry — with the failed records and their errors — in the log the `DML.Logger` wrote. Without a logger, nothing records what the id refers to, so the id in the message points to nothing.
:::

## Discovery

The implementation is resolved via `ApexTypeImplementor` — the first concrete class implementing `DML.Logger` found in the org is used. Keep exactly one implementation in your org.

::: warning
The logger must be a **top-level class**. `ApexTypeImplementor` does not index inner classes, so a logger nested inside another class is never discovered and logging silently does nothing.
:::
