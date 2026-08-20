---
outline: deep
---

# Examples

Complete scenarios that combine several features. Each one is a single unit of work.

## Importing an Order with its Lines and Events

An integration receives an order payload and has to create the account, its contact, the order and its line items, then announce the result — all in one transaction, with the correct foreign keys and the fewest possible DML statements.

```apex
public with sharing class OrderImportService {
    public DML.Result importOrder(OrderPayload payload) {
        Account account = new Account(Name = payload.companyName);
        Contact newContact = new Contact(LastName = payload.contactLastName, Email = payload.contactEmail);
        Order newOrder = new Order(EffectiveDate = Date.today(), Status = 'Draft');

        DML.Commitable unitOfWork = new DML()
            .toInsert(DML.Record(newContact).withRelationship(Contact.AccountId, account))
            .toInsert(DML.Record(newOrder).withRelationship(Order.AccountId, account))
            .toInsert(account)
            .identifier('OrderImportService.importOrder');

        for (OrderLinePayload line : payload.lines) {
            OrderItem item = new OrderItem(
                Quantity = line.quantity,
                UnitPrice = line.unitPrice,
                PricebookEntryId = line.pricebookEntryId
            );

            unitOfWork.toInsert(DML.Record(item).withRelationship(OrderItem.OrderId, newOrder));
        }

        unitOfWork.toPublish(new OrderImported__e(CompanyName__c = payload.companyName));

        return unitOfWork.commitTransaction();
    }
}
```

Two things are worth noticing. The contact and the order are registered **before** the account they depend on, and the order items are registered inside a loop — the [dependency graph](/architecture/registration#registration-order) works out the execution order, so no caller has to. And every order item lands in a single DML statement regardless of how many lines the payload contains: four insert statements, one per object type, plus the publish.

`commitTransaction()` wraps the whole thing in a savepoint, so a failure anywhere — including a validation rule on the last order item — rolls back the account, contact, order and lines together. See [Rollback](/architecture/rollback).

::: warning
A savepoint rollback does not recall a platform event whose publish behavior is *Publish Immediately* — that event is delivered even though the records were rolled back. Use *Publish After Commit* for events that must not outlive the transaction.
:::

## Replacing a Set of Records

A nightly sync replaces last night's rows with today's. The deletes must happen **before** the inserts, otherwise a unique-field constraint rejects the new rows.

```apex
List<Inventory__c> obsolete = [SELECT Id FROM Inventory__c WHERE SyncDate__c < TODAY];

new DML(new List<DML.OperationType>{ DML.OperationType.DELETE_DML, DML.OperationType.INSERT_DML })
    .toDelete(obsolete)
    .toInsert(todaysInventory)
    .commitWork();
```

The default order runs inserts first, which would collide. Passing an [operation order](/configuration/operation-order) to the constructor flips the two phases for this unit of work only.

## Accumulating Work Across Services

Several services contribute to one transaction and a single owner commits it. No service knows what the others registered, and none of them has to register in a particular order.

```apex
public with sharing class OnboardingOrchestrator {
    public void onboard(Lead lead) {
        Account account = new Account(Name = lead.Company);

        new AccountService().register(account);
        new ContactService().register(account, lead);
        new TaskService().register(account);

        DML.Shared.commitWork();
    }
}

public with sharing class ContactService {
    public void register(Account account, Lead lead) {
        Contact newContact = new Contact(LastName = lead.LastName, Email = lead.Email);

        DML.Shared.toInsert(DML.Record(newContact).withRelationship(Contact.AccountId, account));
    }
}
```

`ContactService` registers a contact pointing at an account that `AccountService` may not have registered yet. Order is irrelevant, so the services stay independent of each other. See [Shared Instance](/advanced/shared-instance).

## Partial Success with a Dead Letter Queue

A bulk load should save every row it can, record the ones it cannot, and give the user a reference they can quote to an administrator.

```apex
public with sharing class ContactImporter {
    public void importContacts(List<Contact> contacts) {
        DML.Result result = new DML()
            .toInsert(contacts)
            .allowPartialSuccess()
            .includeOperationIdInErrorMessage()
            .commitWork();

        DML.OperationResult operationResult = result.insertsOf(Contact.SObjectType);

        if (operationResult.hasFailures()) {
            System.debug(
                LoggingLevel.ERROR,
                operationResult.failures().size() + ' contacts failed. Error ID: ' + operationResult.operationId()
            );
        }
    }
}
```

```apex
public with sharing class DmlDeadLetterQueue implements DML.Logger {
    public void log(DML.OperationResult result) {
        List<FailedRecord__c> failures = new List<FailedRecord__c>();

        for (DML.RecordResult recordResult : result.recordResults()) {
            if (recordResult.isSuccess()) {
                continue;
            }

            failures.add(
                new FailedRecord__c(
                    OperationId__c = result.operationId(),
                    Operation__c = String.valueOf(result.operationType()),
                    Payload__c = JSON.serialize(recordResult.record()),
                    Error__c = recordResult.errors()[0].message()
                )
            );
        }

        new DML().toInsert(failures).systemMode().commitWork();
    }
}
```

The [logger](/advanced/logger) is discovered automatically — nothing registers it. Because the same `operationId()` appears both in the user-facing message and on every stored `FailedRecord__c`, an administrator can find the exact failure from the Error ID the user reports, then reprocess the saved payloads.

## Validating Before Committing

`dryRun()` executes the whole unit of work inside a savepoint and rolls it back, so validation rules, triggers and dependency errors all surface without persisting anything.

```apex
Account newAccount = new Account(Name = 'Acme');
Contact newContact = new Contact(LastName = 'Smith');

DML.Result preview = new DML()
    .toInsert(newAccount)
    .toInsert(DML.Record(newContact).withRelationship(Contact.AccountId, newAccount))
    .dryRun();

if (!preview.insertsOf(Account.SObjectType).hasFailures()) {
    new DML()
        .toInsert(newAccount)
        .toInsert(DML.Record(newContact).withRelationship(Contact.AccountId, newAccount))
        .commitWork();
}
```

::: warning
A dry run consumes real DML statements and rows against the transaction's [governor limits](/architecture/rollback) — the rollback does not refund them.
:::
