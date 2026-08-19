---
outline: deep
---

# Error Logger

Capture every failed DML operation in one place — log it, or persist the failed records as a dead letter queue for review and resubmission.

Create a class that implements `DML.Logger`. No registration is needed — the library discovers the implementation automatically and calls it whenever a real DML operation fails.

**Signature**

```apex
public interface Logger {
    void log(OperationError error);
}

public interface OperationError {
    Exception getException(); // null when allOrNone=false and the operation failed per record
    DML.OperationType getOperationType();
    SObjectType getObjectType();
    List<SObject> getRecords();
    List<DML.RecordResult> getFailedRecordResults(); // all processed records when allOrNone=true (everything is rolled back), only the failed ones when allOrNone=false
    System.AccessLevel getAccessLevel();
}
```

**Example**

```apex
public class DmlErrorLogger implements DML.Logger {
    public void log(DML.OperationError error) {
        for (DML.RecordResult failedRecordResult : error.getFailedRecordResults()) {
            System.debug(LoggingLevel.ERROR, error.getOperationType() + ' failed for record: ' + failedRecordResult.record());

            for (DML.Error recordError : failedRecordResult.errors()) {
                System.debug(LoggingLevel.ERROR, recordError.statusCode() + ': ' + recordError.message());
            }
            // Persist the failed record snapshot to reprocess it later.
        }
    }
}
```

That is all — from now on every failed DML executed via the library is passed to `DmlErrorLogger.log(...)`.

## When the Logger is Called

| Scenario | `getException()` | `getFailedRecordResults()` |
|----------|------------------|----------------------------|
| `allOrNone=true` (default) — the operation throws | The thrown exception (rethrown after logging) | All processed records — everything is rolled back, so every record failed. Records identified by the `DmlException` carry their row errors. |
| `allowPartialSuccess()` — records fail individually | `null` | Only the failed records, each with its errors |

The logger is **not** called for mocked operations or for registration validation errors (such as `Only existing records can be updated.`) — only for failures of real database operations.

::: tip
`getFailedRecordResults()` always contains the failed records, in both modes — a dead letter queue implementation can simply iterate it without checking which mode was used.
:::

## Discovery

The implementation is resolved once per transaction via `ApexTypeImplementor` — the first concrete class implementing `DML.Logger` found in the org is used. Keep exactly one implementation in your org.
