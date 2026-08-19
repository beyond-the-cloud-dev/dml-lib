---
outline: deep
---

# Operation Order

Control the order in which DML operations are executed during `commitWork()`.

By default, operations run in a fixed order:

1. Insert and Upsert — executed together, ordered by [record dependencies](/architecture/registration)
2. Update
3. Merge
4. Delete
5. Undelete
6. Publish

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
A custom operation order **disables the dependency graph**. Records are executed strictly in the configured order, and within a phase in the order they were registered — Kahn's algorithm, execution waves and temporary Ids are not used at all. As a result `withRelationship()` to a record inserted in the same unit of work only resolves when the parent was registered before the child, and an operation placed before the insert phase sees no Id at all for records inserted later, so the [Deferred Validation](/architecture/registration#deferred-validation) guarantee does not hold. `commitWork()` also does not use a savepoint, so if a later phase fails, earlier phases stay committed — use `commitTransaction()` when the whole unit of work must be atomic (see [Rollback](/architecture/rollback)).
:::
