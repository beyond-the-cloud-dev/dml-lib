---
outline: deep
---

# Changelog

## v4.1.0

**New Features**

- **Chunk Size** ([#18](https://github.com/beyond-the-cloud-dev/dml-lib/issues/18)) — `chunkSize(Integer chunkSize)` splits each operation into DML statements of at most the given number of records, all in the same transaction. A size below 200 gives triggers and flows smaller batches. See [Chunk Size](/configuration/chunk-size).
- **Failure Checks on `DML.Result`** ([#78](https://github.com/beyond-the-cloud-dev/dml-lib/issues/78)) — `hasFailures()`, `failures()` and `errors()` check the whole result, across every operation and SObject type. See [Check Failures](/result#check-failures).

**Fixes**

- **Sharing in `*Immediately` methods** — in system mode, the `*Immediately` methods ignored `withSharing()` and `withoutSharing()` and ran with the sharing mode of the calling class. They now apply the configured sharing mode, like `commitWork()`. See [Sharing Mode](/configuration/sharing-mode).
- **Two relationships to one parent** — a record with two relationships to the same parent record, such as an `Asset` whose `AccountId` and `AssetServicedById` point at one new `Account`, failed the commit with `Cyclic dependencies detected among records.` The parent now counts as one dependency. See [Registration Order](/architecture/registration#registration-order).
- **`DML.retrieveResultFor()`** — when several commits used the same identifier, `successes()`, `failures()`, `errors()` and `hasFailures()` kept the values from the first read. They now include every commit. See [Mocking](/mocking/mocking).

**Changes**

- Salesforce API version updated to v68.0. From API 67.0, a class without a sharing keyword runs with sharing, so the library's internal classes now declare `inherited sharing` and `withSharing()` and `withoutSharing()` work as before.
- `withSharing()` before an `*Immediately` method in system mode now enforces sharing rules. Code that relied on the old behavior can get insufficient access errors.
- `DML.Committable` has a new method, `chunkSize()`, and `DML.Result` has `hasFailures()`, `failures()` and `errors()`. Classes that implement these interfaces must add them.
- `preview()` prints the chunk size.
- Documentation: new [Chunk Size](/configuration/chunk-size) page and [Check Failures](/result#check-failures) section. The v4.0.0 documentation is archived; use the version switcher in the top navigation.

## v4.0.0

**Breaking Changes**

- The `Commitable` interface is renamed to `Committable` (spelling fix). Replace `DML.Commitable` with `DML.Committable` in your code.

## v3.2.0

**New Features**

- **Custom Operation Order** ([#59](https://github.com/beyond-the-cloud-dev/dml-lib/issues/59)) — control the execution order of DML operations with the new `DML(List<DML.OperationType> operationOrder)` constructor. See [Operation Order](/configuration/operation-order).
- **Error Logger** ([#32](https://github.com/beyond-the-cloud-dev/dml-lib/issues/32)) — implement `DML.Logger` to capture every failed DML operation, including per-record failures under `allowPartialSuccess()`, as a dead letter queue. See [Error Logger](/advanced/logger).
- **Operation ID** ([#19](https://github.com/beyond-the-cloud-dev/dml-lib/issues/19)) — every operation result exposes `operationId()`, a random UUID for logging and support. `includeOperationIdInErrorMessage()` appends it to the thrown `DmlException` as an Error ID the user can pass to their administrator. See [Error ID](/advanced/logger#error-id).
- **Deferred Validation** ([#27](https://github.com/beyond-the-cloud-dev/dml-lib/issues/27)) — record validation runs when `commitWork()` executes each operation, so a record inserted in a unit of work can be updated or deleted in the same `commitWork()`. See [Deferred Validation](/architecture/registration#deferred-validation).
- **`accessMode(System.AccessLevel)`** ([#52](https://github.com/beyond-the-cloud-dev/dml-lib/pull/52)) — enum-based alternative to `userMode()` / `systemMode()`. See [Field-Level Security](/configuration/field-level-security).
- **`@NamespaceAccessible` API** ([#58](https://github.com/beyond-the-cloud-dev/dml-lib/pull/58)) — all public entry points are accessible across namespace boundaries.

**Changes**

- Salesforce API version updated to v66.0.
- Documentation: new pages for [Examples](/examples), [Hard Delete](/dml/hard-delete), [Record & Records](/dml/record-builders), [Shared Instance](/advanced/shared-instance), [Commit Hooks](/advanced/commit-hooks), and [Execution Control](/advanced/execution-control); documentation is now versioned — use the version switcher in the top navigation.

## Older Releases

See [GitHub Releases](https://github.com/beyond-the-cloud-dev/dml-lib/releases) for v3.1.0 and earlier.
