# Transaction Rollback

## When rollback is happening? 

try-catch | savepoint | allOrNone | rollback | rethrow exception |  Is rollback happening?
--------- | --------- | --------- | -------- | ----------------- | -----------------------
❌  | ❌  | ✅ TRUE  | ❌ | ❌   | ✅ - unhandled DmlException rolls back the entire transaction.
❌  | ❌  | ❌ FALSE | ❌ | ❌   | ❌ - record errors don’t throw; partials commit.
✅  | ❌  | ✅ TRUE  | ❌ | ❌   | ❌ - exception handled; failing call is reverted, prior DML stays.
✅  | ❌  | ❌ FALSE | ❌ | ❌   | ❌ - no exception on record errors; partials commit.
✅  | ✅  | ✅ TRUE  | ✅ | ❌   | ✅ - explicit rollback to the savepoint.
✅  | ✅  | ❌ FALSE | ✅ | ❌   | ❌ - record errors don’t throw; catch not hit; no rollback.
✅  | ❌  | ✅ TRUE  | ❌ | ✅   | ✅ - rethrown DmlException is unhandled above; full rollback.

**Conclusions**

- `allOrNone=false`: record errors return SaveResult[] (no exception) - successful rows commit; failed rows don’t. Other exceptions (limits, Mixed DML) can still roll back if unhandled.
- Unhandled exceptions roll back the entire transaction.
- Caught (not rethrown) exceptions do not roll back earlier successes.
- Savepoints give cross-call atomicity: set a savepoint and roll back to it on failure. Works with `allOrNone=true` (with `allOrNone=false`, detect failures and trigger rollback yourself).
- Limits: up to 5 savepoints per transaction; rollback returns to the most recent savepoint. Each `setSavepoint()`/`rollback()`/`releaseSavepoint()` consumes DML resources;

## What is standard?

```apex
public class MyService {
    public static void makeDmls() {
        List<Account> accounts = ...;
        List<Contact> contacts = ...;
        List<Opportunities> opportunities = ...;

        // code here

        insert accounts;
        update contacts;
        delete opportunities;
    }
}
```

With no `try–catch`, any unhandled exception rolls back the entire transaction. No records are created, updated, or deleted. 
 ￼
```apex
public class MyService {
    public static void makeDmls() {
        List<Account> accounts = ...;
        List<Contact> contacts = ...;
        List<Opportunities> opportunities = ...;

        // code here
        try {
            insert accounts;
            update contacts;
            delete opportunities;
        } catch {
            MyLogger.log(e.getMessage()).persist();
            // no rethrow
        }
    }
}
```

With a `try–catch` (and no rethrow), the transaction does not auto-rollback. The failing DML call reverts itself (if applicable), but prior successful DML remains. 

**Conclusions**

- In the “standard” use of DML (no savepoint), rollback happens only when an exception is unhandled. A try–catch prevents automatic rollback unless you rethrow.

## Solution

DML Lib provides two commit styles:

- `commitWork()` - does not set a savepoint and does not rethrow to force rollback. Behavior is closest to the usual “plain DML in a method” pattern.
- `commitTransaction()` - sets a savepoint and, if an error occurs, rolls back to that savepoint (all changes since the savepoint are undone). Savepoints/rollbacks count against the DML statement governor limit.  ￼
- `commitWork()` + `allowPartialSuccess()` - no exception is thrown for row-level errors; no automatic rollback occurs. Inspect `DML.Result` to handle failures.
- `commitTransaction()` + `allowPartialSuccess()` - not supported (by design). If you suppress exceptions, the savepoint won’t be rolled back; therefore this combo is disallowed to avoid misleading behavior.

Notes:
- Savepoints/rollbacks: `Database.setSavepoint()` and `Database.rollback(sp)` count toward the DML statement limit (they do not count toward the DML row limit). Use sparingly.  ￼
- If you need cross-call atomicity, use a savepoint and roll back on failure (`commitTransaction()`) ; otherwise, only unhandled exceptions roll back the entire transaction.  