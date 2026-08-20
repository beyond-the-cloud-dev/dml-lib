# Architecture

## DML Transaction Control

When rollback is happening? 

try-catch | savepoint | allOrNone | rollback | rethrow exception |  Is rollback happening?
--------- | --------- | --------- | -------- | ----------------- | -----------------------
❌        | ❌        | ✅        | ❌       | ❌                 | ✅ – unhandled DmlException rolls back entire transaction.
❌        | ❌        | ❌        | ❌       | ❌                 | ❌ – partials commit; no exception thrown.
✅        | ❌        | ✅        | ❌       | ❌                 | ❌ – exception handled; transaction continues (failed call is reverted, prior DML stays)
✅        | ❌        | ❌        | ❌       | ❌                 | ❌ – no exception on record errors; partials commit.
✅        | ✅        | ✅        | ✅       | ❌                 | ✅ – explicit rollback to savepoint undoes all since savepoint.
✅        | ✅        | ❌        | ✅       | ❌                 | ❌ – record errors don’t throw, catch doesn’t run, rollback not called.
✅        | ❌        | ✅        | ❌       | ✅                 | ✅ — the rethrown DmlException remains unhandled above and the entire transaction rolls back.

## Conclusions

- `allOrNone=false` will never throw DmlException, and bacause of it partial commit will be made.
- `Savepoint` makes sense only when `allOrNone=true`, so DmlException is thrown and rollback can be called.

- **Unhandled exceptions roll back the entire transaction.** If a DmlException (or any unhandled exception) escapes your code path, Salesforce undoes all DML from that transaction.  ￼
- **allOrNone=true is atomic per call. Any row error makes the single Database.** call fail as a unit and throws (same behavior as DML keywords). Earlier successful calls aren’t automatically undone unless the exception remains unhandled.  ￼
- **allOrNone=false returns SaveResult[] (no row-error exception)**. Successful rows commit; failed rows don’t. You must check results yourself. Other exceptions (e.g., limit/mixed DML) can still occur and roll back the transaction if unhandled.  ￼
- **Catching without rethrowing does not roll back prior successes**. With allOrNone=true, the failing call reverts itself, but earlier successful DML remains unless you escalate (rethrow) or manually roll back.  ￼
- **Savepoints give cross-call atomicity (your whole UoW)**: wrap many DML calls in Database.setSavepoint() and call Database.rollback(sp) on any failure to undo everything since the savepoint. Works with either allOrNone mode.  ￼
- **Savepoint mechanics & limits**: each setSavepoint()/rollback() consumes DML resources; rollback returns to the last savepoint only. Plan chunking and logging accordingly.  ￼

A) allOrNone=true

```java
Database.insert(accounts, true);
Database.update(contacts, true);
Database.insert(opportunities, true);
```

B) allOrNone=false

```java
Database.insert(accounts, false);
Database.update(contacts, false);
Database.insert(opportunities, false);
```

C) try-catch, allOrNone=true

```java
try {
    Database.insert(accounts, true);
    Database.update(contacts, true);
    Database.insert(opportunities, true);
} catch (DmlException e) {
    // logger
}
```

D) try-catch, allOrNone=false

```java
try {
    Database.insert(accounts, false);
    Database.update(contacts, false);
    Database.insert(opportunities, false);
} catch (DmlException e) {
    // logger
}
```


E) try-catch, savepoint, allOrNone=true, rollback

```java
Savepoint sp = Database.setSavepoint();

try {
    Database.insert(accounts, true);
    Database.update(contacts, true);
    Database.insert(opportunities, true);
} catch (DmlException e) {
    Database.rollback(sp);
    // logger
}
```

F) try-catch, savepoint, allOrNone=false, rollback

```java
Savepoint sp = Database.setSavepoint();

try {
    Database.insert(accounts, false);
    Database.update(contacts, false);
    Database.insert(opportunities, false);
} catch (DmlException e) {
    Database.rollback(sp);
    // logger
}
```

G) try-catch, allOrNone=true, rethrow

```java
try {
    Database.insert(accounts, true);
    Database.update(contacts, true);
    Database.insert(opportunities, true);
} catch (DmlException e) {
    // logger
    throw e;
}
```


> Each element in the SaveResult array corresponds to the sObject array passed as the sObject[] parameter in the Database method, that is, the first element in the SaveResult array matches the first element passed in the sObject array, the second element corresponds with the second element, and so on. If only one sObject is passed in, the SaveResult array contains a single element.
https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_database_saveresult.htm