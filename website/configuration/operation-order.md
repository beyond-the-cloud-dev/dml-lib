---
outline: deep
---

# Operation Order

Control the order in which DML operations are executed during `commitWork()`.

By default, operations run in a fixed order, with inserts and upserts resolving [record dependencies](/architecture/registration) first:

1. Insert
2. Upsert
3. Update
4. Merge
5. Delete
6. Undelete
7. Publish

This order does not fit every use case — for example, deleting old records before inserting their replacements. Pass a custom order to the `DML` constructor to change it.

**Signature**

```apex
DML(List<DML.OperationType> operationOrder);
```

**Example**

```apex
Account newAccount = new Account(Name = 'New Account');
List<Account> oldAccounts = [SELECT Id FROM Account WHERE Name LIKE 'Old%'];

new DML(new List<DML.OperationType>{ DML.OperationType.DELETE_DML, DML.OperationType.INSERT_DML })
    .toInsert(newAccount)
    .toDelete(oldAccounts)
    .commitWork(); // Accounts are deleted BEFORE the new account is inserted
```

Operations execute in the order of the list, regardless of the registration order.

## Rules

- Every operation type you register must be listed — registering an operation that is missing from the list throws a `DmlException`: `INSERT_DML operation is not listed in the custom operation order.`
- The available operation types are `INSERT_DML`, `UPSERT_DML`, `UPDATE_DML`, `MERGE_DML`, `DELETE_DML`, `UNDELETE_DML`, and `PUBLISH_DML`.
- The order is fixed for the lifetime of the `DML` instance — it survives `commitWork()` and `discardWork()`, like every other configuration.

::: warning
With a custom operation order, records are grouped and executed strictly by the configured order. Operations placed before the insert/upsert phase lose the same-transaction Id guarantee described in [Deferred Validation](/architecture/registration#deferred-validation) — a record inserted in the same unit of work has no Id yet when an earlier phase executes. `commitWork()` does not use a savepoint, so if a later phase fails, earlier phases stay committed — use `commitTransaction()` when the whole unit of work must be atomic (see [Rollback](/architecture/rollback)).
:::
