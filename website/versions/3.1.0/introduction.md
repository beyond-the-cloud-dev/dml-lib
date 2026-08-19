# Introduction

DML Lib is a lightweight Apex library for managing DML operations with a fluent, chainable API.

## Why DML Lib?

- **Clean Syntax** - Fluent API for readable, maintainable code
- **Relationship Handling** - Automatic parent-child ID resolution
- **Security Control** - Built-in Field-Level Security and Sharing modes
- **Transaction Management** - Batch operations with `commitWork()`, rollback with `dryRun()`
- **Testability** - Mock DML operations without touching the database
- **Result Handling** - Detailed results with success/failure tracking per record

## Quick Example

```apex
Account account = new Account(Name = 'Acme Corp');
Contact contact = new Contact(LastName = 'Smith');

new DML()
    .toInsert(account)
    .toInsert(DML.Record(contact).withRelationship(Contact.AccountId, account))
    .commitWork();

// contact.AccountId is automatically set to account.Id
```