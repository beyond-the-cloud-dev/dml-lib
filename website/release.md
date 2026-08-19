---
outline: deep
---

# Changelog

## v3.2.0

**New Features**

- **Custom Operation Order** ([#59](https://github.com/beyond-the-cloud-dev/dml-lib/issues/59)) — control the execution order of DML operations with the new `DML(List<DML.OperationType> operationOrder)` constructor. See [Operation Order](/configuration/operation-order).
- **Error Logger** ([#32](https://github.com/beyond-the-cloud-dev/dml-lib/issues/32)) — implement `DML.Logger` to capture every failed DML operation, including per-record failures under `allowPartialSuccess()`, as a dead letter queue. See [Error Logger](/advanced/logger).
- **Deferred Validation** ([#27](https://github.com/beyond-the-cloud-dev/dml-lib/issues/27)) — record validation runs when `commitWork()` executes each operation, so a record inserted in a unit of work can be updated or deleted in the same `commitWork()`. See [Deferred Validation](/architecture/registration#deferred-validation).
- **`accessMode(System.AccessLevel)`** ([#52](https://github.com/beyond-the-cloud-dev/dml-lib/pull/52)) — enum-based alternative to `userMode()` / `systemMode()`. See [Field-Level Security](/configuration/field-level-security).
- **`@NamespaceAccessible` API** ([#58](https://github.com/beyond-the-cloud-dev/dml-lib/pull/58)) — all public entry points are accessible across namespace boundaries.

**Changes**

- Salesforce API version updated to v66.0.
- Documentation: new pages for [Hard Delete](/dml/hard-delete), [Record & Records](/dml/record-builders), [Shared Instance](/advanced/shared-instance), [Commit Hooks](/advanced/commit-hooks), and [Execution Control](/advanced/execution-control); documentation is now versioned — use the version switcher in the top navigation.

## Older Releases

See [GitHub Releases](https://github.com/beyond-the-cloud-dev/dml-lib/releases) for v3.1.0 and earlier.
