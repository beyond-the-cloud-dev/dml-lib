---
outline: deep
---

# DML Options

Configure additional DML behavior such as partial success, duplicate rules, and custom options.

::: warning
When using `allowPartialSuccess()`, always check the result for failures. Silently ignoring failures can lead to data integrity issues.
:::

**Example**

```apex
List<Account> accounts = new List<Account>{
    new Account(Name = 'Valid Account'),
    new Account() // Missing required Name field
};

new DML()
    .toInsert(accounts)
    .allowPartialSuccess()
    .commitWork();
```

## allowPartialSuccess

Allow some records to succeed while others fail, without rolling back the entire transaction.

**Signature**

```apex
Commitable allowPartialSuccess();
```

**Standard DML**

```apex
Database.insert(accounts, false); // allOrNone = false
```

**DML Lib**

```apex
new DML()
    .toInsert(accounts)
    .allowPartialSuccess()
    .commitWork();
```

### Handling Partial Failures

When using partial success, check the result for failures.

**Example**

```apex
List<Account> accounts = new List<Account>{
    new Account(Name = 'Valid Account'),
    new Account() // Missing required Name field
};

DML.Result result = new DML()
    .toInsert(accounts)
    .allowPartialSuccess()
    .commitWork();

DML.OperationResult operationResult = result.insertsOf(Account.SObjectType);

if (operationResult.hasFailures()) {
    List<SObject> successRecords = operationResult.successes();
    List<SObject> failedRecords = operationResult.failures();

    for (DML.Error error : operationResult.errors()) {
        System.debug('Error: ' + error.message());
        System.debug('Status Code: ' + error.statusCode());
        System.debug('Fields: ' + error.fields());
    }
}
```

### Update with Partial Success

**Example**

```apex
Account account1 = [SELECT Id, Name FROM Account LIMIT 1];
account1.Name = ''; // Will fail - Name is required

Account account2 = [SELECT Id, Name FROM Account OFFSET 1 LIMIT 1];
account2.Name = 'Valid Update';

DML.Result result = new DML()
    .toUpdate(new List<Account>{ account1, account2 })
    .allowPartialSuccess()
    .commitWork();

// account1 failed (Name is required), account2 succeeded
```

## skipDuplicateRules

Skip duplicate rule evaluation during DML operations.

**Signature**

```apex
Commitable skipDuplicateRules();
```

**Standard DML**

```apex
Database.DmlOptions options = new Database.DmlOptions();
options.duplicateRuleHeader.allowSave = true;
Database.insert(account, options);
```

**DML Lib**

```apex
new DML()
    .toInsert(account)
    .skipDuplicateRules()
    .commitWork();
```

### Example

**Example**

```apex
// Insert potential duplicate without triggering duplicate rules
Account duplicateAccount = new Account(
    Name = 'Existing Account Name'
);

new DML()
    .toInsert(duplicateAccount)
    .skipDuplicateRules()
    .commitWork();
```

## options

Provide custom `Database.DmlOptions` for fine-grained control over DML behavior.

**Signature**

```apex
Commitable options(Database.DmlOptions options);
```

**Standard DML**

```apex
Database.DmlOptions options = new Database.DmlOptions();
options.optAllOrNone = false;
options.allowFieldTruncation = true;
Database.insert(account, options);
```

**DML Lib**

```apex
Database.DmlOptions options = new Database.DmlOptions();
options.optAllOrNone = false;
options.allowFieldTruncation = true;

new DML()
    .toInsert(account)
    .options(options)
    .commitWork();
```

### Allow Field Truncation

Automatically truncate field values that exceed the maximum length.

**Example**

```apex
String longName = 'Test Account ' + 'X'.repeat(300); // Exceeds 255 char limit
Account account = new Account(Name = longName);

Database.DmlOptions options = new Database.DmlOptions();
options.allowFieldTruncation = true;

new DML()
    .toInsert(account)
    .options(options)
    .commitWork();

Account inserted = [SELECT Name FROM Account WHERE Id = :account.Id];
// inserted.Name.length() == 255 (truncated to max length)
```

### Duplicate Rule Header

Control duplicate rule behavior through options.

**Example**

```apex
Database.DmlOptions options = new Database.DmlOptions();
options.duplicateRuleHeader.allowSave = true;
options.duplicateRuleHeader.runAsCurrentUser = true;

new DML()
    .toInsert(accounts)
    .options(options)
    .commitWork();
```

### Assignment Rule Header

Apply assignment rules during insert.

**Example**

```apex
Database.DmlOptions options = new Database.DmlOptions();
options.assignmentRuleHeader.useDefaultRule = true;

new DML()
    .toInsert(lead)
    .options(options)
    .commitWork();
```

## Combining Options

You can combine multiple configuration methods.

**Example**

```apex
new DML()
    .toInsert(accounts)
    .allowPartialSuccess()
    .skipDuplicateRules()
    .systemMode()
    .withoutSharing()
    .commitWork();
```
