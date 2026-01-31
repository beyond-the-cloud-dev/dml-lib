/**
 * Copyright (c) 2026 Beyond The Cloud Sp. z o.o. (BeyondTheCloud.Dev)
 * Licensed under the MIT License (https://github.com/beyond-the-cloud-dev/dml-lib/blob/main/LICENSE)
 *
 * v3.0.0
 *
 * PMD False Positives:
 * - CyclomaticComplexity: It is a library and we tried to put everything into ONE class
 * - CognitiveComplexity: It is a library and we tried to put everything into ONE class
 * - ApexUnitTestClassShouldHaveRunAs: System.runAs is used to test fls and sharing modes
 * - NcssMethodCount: Some methods are longer because of amount of assertions
 * - NcssTypeCount: It is a library and we tried to put everything into ONE class
 **/
@SuppressWarnings('PMD.CyclomaticComplexity,PMD.CognitiveComplexity,PMD.ApexUnitTestClassShouldHaveRunAs,PMD.NcssMethodCount,PMD.NcssTypeCount')
@IsTest
private class DML_Full_Test {
	// ================================================ INSERT =================================================

	@IsTest
	static void toInsertSingleRecord() {
		// Setup
		Account account1 = getAccount(1);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toInsert(account1).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Single record should be inserted.');

		Assert.isNotNull(account1.Id, 'Account should be inserted and have an Id.');

		Assert.areEqual(1, result.inserts().size(), 'Inserted operation result should contain 1 result.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult operationResult = result.insertsOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Inserted operation result should contain the inserted record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Inserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, operationResult.operationType(), 'Inserted operation result should contain insert type.');
		Assert.isFalse(operationResult.hasFailures(), 'Inserted operation result should not have failures.');
	}

	@IsTest
	static void toInsertWithRelationshipSingleRecord() {
		// Setup
		Account newAccount = getAccount(1);
		Contact newContact = getContact(1);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toInsert(newAccount).toInsert(DML.Record(newContact).withRelationship(Contact.AccountId, newAccount)).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(2, dmlsAfter - dmlsBefore, '2 DML statements should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be inserted.');
		Assert.areEqual(1, [SELECT COUNT() FROM Contact], 'Contact should be inserted.');

		Assert.areEqual(newAccount.Id, newContact.AccountId, 'Contact should be related to Account.');
	}

	@IsTest
	static void toInsertWithDifferentRecordTypesAndRelationships() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);
		Account account3 = getAccount(3);
		Contact contact1 = getContact(1);
		Opportunity opportunity1 = getOpportunity(1);
		Lead lead1 = getLead(1);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDmlStatements();

		DML.Result result = new DML()
			.toInsert(account1)
			.toInsert(account2)
			.toInsert(DML.Record(account3).withRelationship(Account.ParentId, account2))
			.toInsert(DML.Record(contact1).withRelationship(Contact.AccountId, account2))
			.toInsert(opportunity1)
			.toInsert(lead1)
			.commitWork();

		Integer dmlsAfter = Limits.getDmlStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(dmlsAfter - dmlsBefore, 5, '5 DML statements should be executed');

		Assert.areEqual(3, [SELECT COUNT() FROM Account], 'Account should be inserted.');
		Assert.areEqual(1, [SELECT COUNT() FROM Contact], 'Contact should be inserted.');
		Assert.areEqual(1, [SELECT COUNT() FROM Opportunity], 'Opportunity should be inserted.');
		Assert.areEqual(1, [SELECT COUNT() FROM Lead], 'Lead should be inserted.');

		Assert.areEqual(account2.Id, contact1.AccountId, 'Contact should be related to Account 2.');
		Assert.areEqual(account2.Id, account3.ParentId, 'Account 3 should be related to Account 2.');

		Assert.areEqual(4, result.inserts().size(), 'Inserted operation result should contain 4 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult operationResult = result.insertsOf(Account.SObjectType);

		Assert.areEqual(3, operationResult.records().size(), 'Inserted operation result should contain the inserted records.');
		Assert.areEqual(3, operationResult.recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Inserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, operationResult.operationType(), 'Inserted operation result should contain insert type.');
		Assert.isFalse(operationResult.hasFailures(), 'Inserted operation result should not have failures.');

		DML.OperationResult contactOperationResult = result.insertsOf(Contact.SObjectType);

		Assert.areEqual(1, contactOperationResult.records().size(), 'Inserted operation result should contain the inserted record.');
		Assert.areEqual(1, contactOperationResult.recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.areEqual(Contact.SObjectType, contactOperationResult.objectType(), 'Inserted operation result should contain Contact object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, contactOperationResult.operationType(), 'Inserted operation result should contain insert type.');
		Assert.isFalse(contactOperationResult.hasFailures(), 'Inserted operation result should not have failures.');

		DML.OperationResult opportunityOperationResult = result.insertsOf(Opportunity.SObjectType);

		Assert.areEqual(1, opportunityOperationResult.records().size(), 'Inserted operation result should contain the inserted record.');
		Assert.areEqual(1, opportunityOperationResult.recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.areEqual(Opportunity.SObjectType, opportunityOperationResult.objectType(), 'Inserted operation result should contain Opportunity object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, opportunityOperationResult.operationType(), 'Inserted operation result should contain insert type.');
		Assert.isFalse(opportunityOperationResult.hasFailures(), 'Inserted operation result should not have failures.');

		DML.OperationResult leadOperationResult = result.insertsOf(Lead.SObjectType);

		Assert.areEqual(1, leadOperationResult.records().size(), 'Inserted operation result should contain the inserted record.');
		Assert.areEqual(1, leadOperationResult.recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.areEqual(Lead.SObjectType, leadOperationResult.objectType(), 'Inserted operation result should contain Lead object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, leadOperationResult.operationType(), 'Inserted operation result should contain insert type.');
		Assert.isFalse(leadOperationResult.hasFailures(), 'Inserted operation result should not have failures.');
	}

	@IsTest
	static void toInsertMultipleRecords() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toInsert(account1).toInsert(account2).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(2, [SELECT COUNT() FROM Account], 'Accounts should be inserted.');

		Assert.isNotNull(account1.Id, 'Account 1 should be inserted and have an Id.');
		Assert.isNotNull(account2.Id, 'Account 2 should be inserted and have an Id.');

		Assert.areEqual(1, result.inserts().size(), 'Inserted operation result should contain 1 result, because 2 Account records are grouped.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult operationResult = result.insertsOf(Account.SObjectType);

		Assert.areEqual(2, operationResult.records().size(), 'Inserted operation result should contain the inserted records.');
		Assert.areEqual(2, operationResult.recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Inserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, operationResult.operationType(), 'Inserted operation result should contain insert type.');
		Assert.isFalse(operationResult.hasFailures(), 'Inserted operation result should not have failures.');
	}

	@IsTest
	static void toInsertWithRelationshipMultipleRecords() {
		// Setup
		Account newAccount = getAccount(1);
		Contact newContact1 = getContact(1);
		Contact newContact2 = getContact(2);

		List<Contact> contacts = new List<Contact>{ newContact1, newContact2 };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toInsert(newAccount).toInsert(DML.Records(contacts).withRelationship(Contact.AccountId, newAccount)).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(2, dmlsAfter - dmlsBefore, '2 DML statements should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be inserted.');
		Assert.areEqual(2, [SELECT COUNT() FROM Contact], 'Contacts should be inserted.');

		Assert.areEqual(newAccount.Id, newContact1.AccountId, 'Contact should be related to Account.');
		Assert.areEqual(newAccount.Id, newContact2.AccountId, 'Contact 2 should be related to Account.');
	}

	@IsTest
	static void toInsertMultipleRecordsTypes() {
		// Setup
		Account account1 = getAccount(1);
		Opportunity opportunityToInsert = getOpportunity(1);
		Lead leadToInsert = getLead(1);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toInsert(account1).toInsert(opportunityToInsert).toInsert(leadToInsert).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(3, dmlsAfter - dmlsBefore, '3 DML statements should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be inserted.');
		Assert.areEqual(1, [SELECT COUNT() FROM Opportunity], 'Opportunity should be inserted.');
		Assert.areEqual(1, [SELECT COUNT() FROM Lead], 'Lead should be inserted.');

		Assert.isNotNull(account1.Id, 'Account should be inserted and have an Id.');
		Assert.isNotNull(opportunityToInsert.Id, 'Opportunity should be inserted and have an Id.');
		Assert.isNotNull(leadToInsert.Id, 'Lead should be inserted and have an Id.');

		Assert.areEqual(3, result.inserts().size(), 'Inserted operation result should contain 3 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult accountOperationResult = result.insertsOf(Account.SObjectType);

		Assert.areEqual(1, accountOperationResult.records().size(), 'Inserted operation result should contain the inserted record.');
		Assert.areEqual(1, accountOperationResult.recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.areEqual(Account.SObjectType, accountOperationResult.objectType(), 'Inserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, accountOperationResult.operationType(), 'Inserted operation result should contain insert type.');
		Assert.isFalse(accountOperationResult.hasFailures(), 'Inserted operation result should not have failures.');

		DML.OperationResult opportunityOperationResult = result.insertsOf(Opportunity.SObjectType);

		Assert.areEqual(1, opportunityOperationResult.records().size(), 'Inserted operation result should contain the inserted record.');
		Assert.areEqual(1, opportunityOperationResult.recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.areEqual(Opportunity.SObjectType, opportunityOperationResult.objectType(), 'Inserted operation result should contain Opportunity object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, opportunityOperationResult.operationType(), 'Inserted operation result should contain insert type.');
		Assert.isFalse(opportunityOperationResult.hasFailures(), 'Inserted operation result should not have failures.');

		DML.OperationResult leadOperationResult = result.insertsOf(Lead.SObjectType);

		Assert.areEqual(1, leadOperationResult.records().size(), 'Inserted operation result should contain the inserted record.');
		Assert.areEqual(1, leadOperationResult.recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.areEqual(Lead.SObjectType, leadOperationResult.objectType(), 'Inserted operation result should contain Lead object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, leadOperationResult.operationType(), 'Inserted operation result should contain insert type.');
		Assert.isFalse(leadOperationResult.hasFailures(), 'Inserted operation result should not have failures.');
	}

	@IsTest
	static void toInsertListOfRecords() {
		// Setup
		List<Account> accounts = new List<Account>{ getAccount(1), getAccount(2), getAccount(3) };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toInsert(accounts).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(3, [SELECT COUNT() FROM Account], 'Accounts should be inserted.');

		Assert.isNotNull(accounts[0].Id, 'Account 1 should be inserted and have an Id.');
		Assert.isNotNull(accounts[1].Id, 'Account 2 should be inserted and have an Id.');
		Assert.isNotNull(accounts[2].Id, 'Account 3 should be inserted and have an Id.');
	}

	@IsTest
	static void toInsertWithEmptyRecords() {
		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toInsert(new List<Account>()).commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(0, dmlStatementsAfter - dmlStatementsBefore, 'No DML statements should be executed.');
		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 1 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.merges().size(), 'Merged operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');
	}

	// ================================================ INSERT IMMEDIATELY =================================================

	@IsTest
	static void insertImmediatelySingleRecord() {
		// Setup
		Account account1 = getAccount(1);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.OperationResult result = new DML().insertImmediately(account1);

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Single record should be inserted.');
		Assert.isNotNull(account1.Id, 'Account should be inserted and have an Id.');
		Assert.areEqual(1, result.records().size(), 'Inserted operation result should contain the inserted record.');
		Assert.areEqual(1, result.recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Inserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, result.operationType(), 'Inserted operation result should contain insert type.');
		Assert.isFalse(result.hasFailures(), 'Inserted operation result should not have failures.');
	}

	@IsTest
	static void insertImmediatelyMultipleRecords() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.OperationResult result = new DML().insertImmediately(new List<Account>{ account1, account2 });

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(2, [SELECT COUNT() FROM Account], 'Accounts should be inserted.');

		Assert.isNotNull(account1.Id, 'Account 1 should be inserted and have an Id.');
		Assert.isNotNull(account2.Id, 'Account 2 should be inserted and have an Id.');

		Assert.areEqual(2, result.records().size(), 'Inserted operation result should contain the inserted records.');
		Assert.areEqual(2, result.recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Inserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, result.operationType(), 'Inserted operation result should contain insert type.');
		Assert.isFalse(result.hasFailures(), 'Inserted operation result should not have failures.');
	}

	@IsTest
	static void insertImmediatelyWithDmlRecord() {
		// Setup
		Account account1 = getAccount(1);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.OperationResult result = new DML().insertImmediately(DML.Record(account1).with(Account.Name, 'DML Record Account'));

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Single record should be inserted.');
		Assert.isNotNull(account1.Id, 'Account should be inserted and have an Id.');
		Assert.areEqual('DML Record Account', [SELECT Name FROM Account WHERE Id = :account1.Id].Name, 'Account name should be set.');
		Assert.areEqual(1, result.records().size(), 'Inserted operation result should contain the inserted record.');
		Assert.areEqual(1, result.recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Inserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, result.operationType(), 'Inserted operation result should contain insert type.');
		Assert.isFalse(result.hasFailures(), 'Inserted operation result should not have failures.');
	}

	@IsTest
	static void insertImmediatelyWithDmlRecords() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.OperationResult result = new DML().insertImmediately(DML.Records(new List<Account>{ account1, account2 }).with(Account.Name, 'DML Records Account'));

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(2, [SELECT COUNT() FROM Account], 'Accounts should be inserted.');

		Assert.isNotNull(account1.Id, 'Account 1 should be inserted and have an Id.');
		Assert.isNotNull(account2.Id, 'Account 2 should be inserted and have an Id.');
		Assert.areEqual(2, [SELECT COUNT() FROM Account WHERE Name = 'DML Records Account'], 'Account names should be set.');

		Assert.areEqual(2, result.records().size(), 'Inserted operation result should contain the inserted records.');
		Assert.areEqual(2, result.recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Inserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, result.operationType(), 'Inserted operation result should contain insert type.');
		Assert.isFalse(result.hasFailures(), 'Inserted operation result should not have failures.');
	}

	// ================================================ UPDATE =================================================

	@IsTest
	static void toUpdateSingleRecord() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		account1.Name = 'Updated Test Account';

		DML.Result result = new DML().toUpdate(account1).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be updated.');

		Assert.areEqual('Updated Test Account', account1.Name, 'Account should be updated.');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(1, result.updates().size(), 'Updated operation result should contain 1 result.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult operationResult = result.updatesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Updated operation result should contain the updated record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Updated operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, operationResult.operationType(), 'Updated operation result should contain update type.');
		Assert.isFalse(operationResult.hasFailures(), 'Updated operation result should not have failures.');
	}

	@IsTest
	static void toUpdateSingleRecordTwiceWithMergeOnDuplicate() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;

		// Test
		Test.startTest();
		account1.Name = 'Updated Test Account';
		account1.Website = 'https://www.updatedtestaccount.com';

		DML db = new DML();

		db.combineOnDuplicate();

		db.toUpdate(account1);

		Account duplicatedAccount = new Account(Id = account1.Id, Name = 'Updated Test Account 2', Description = 'Updated Test Description');

		db.toUpdate(duplicatedAccount);

		DML.Result result = db.commitWork();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be updated.');

		Assert.areEqual(1, result.updates().size(), 'Updated operation result should contain 1 result.');

		DML.OperationResult operationResult = result.updatesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Updated operation result should contain the updated record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Updated operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, operationResult.operationType(), 'Updated operation result should contain update type.');
		Assert.isFalse(operationResult.hasFailures(), 'Updated operation result should not have failures.');
		Assert.areEqual('Updated Test Account 2', account1.Name, 'Account should be updated.');
		Assert.areEqual('https://www.updatedtestaccount.com', account1.Website, 'Account should be updated.');
		Assert.areEqual('Updated Test Description', account1.Description, 'Account should be updated.');
	}

	@IsTest
	static void toUpdateWithEmptyRecordIds() {
		// Setup
		List<Id> recordIds = new List<Id>();

		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toUpdate(DML.Records(recordIds)).commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, dmlStatementsAfter - dmlStatementsBefore, 'No DML statements should be executed.');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 result.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.merges().size(), 'Merged operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');
	}

	@IsTest
	static void toUpdateWithRelationshipSingleRecord() {
		// Setup
		Account newAccount = getAccount(1);
		Contact newContact = getContact(1);
		insert newContact;

		// Test
		Test.startTest();
		new DML().toInsert(newAccount).toUpdate(DML.Record(newContact).withRelationship(Contact.AccountId, newAccount)).commitWork();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be inserted.');
		Assert.areEqual(1, [SELECT COUNT() FROM Contact], 'Contact should be updated.');

		List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE Id = :newContact.Id];

		Assert.areEqual(newAccount.Id, contacts[0].AccountId, 'Contact should be related to Account.');
	}

	@IsTest
	static void toUpdateMultipleRecords() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		insert new List<Account>{ account1, account2 };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		account1.Name = 'Updated Test Account 1';
		account2.Name = 'Updated Test Account 2';

		DML.Result result = new DML().toUpdate(account1).toUpdate(account2).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(2, [SELECT COUNT() FROM Account], 'Accounts should be updated.');

		Assert.areEqual('Updated Test Account 1', account1.Name, 'Account 1 should be updated.');
		Assert.areEqual('Updated Test Account 2', account2.Name, 'Account 2 should be updated.');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(1, result.updates().size(), 'Updated operation result should contain 1 result.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult operationResult = result.updatesOf(Account.SObjectType);

		Assert.areEqual(2, operationResult.records().size(), 'Updated operation result should contain the updated records.');
		Assert.areEqual(2, operationResult.recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Updated operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, operationResult.operationType(), 'Updated operation result should contain update type.');
		Assert.isFalse(operationResult.hasFailures(), 'Updated operation result should not have failures.');
	}

	@IsTest
	static void toUpdateWithRelationshipMultipleRecords() {
		// Setup
		Account newAccount = getAccount(1);
		Contact newContact = getContact(1);
		Contact newContact2 = getContact(2);

		List<Contact> contactsToCreate = new List<Contact>{ newContact, newContact2 };
		insert contactsToCreate;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toInsert(newAccount).toUpdate(DML.Records(contactsToCreate).withRelationship(Contact.AccountId, newAccount)).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(2, dmlsAfter - dmlsBefore, '2 DML statements should be executed.');

		Assert.areEqual(2, [SELECT COUNT() FROM Contact], 'Contacts should be updated.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be inserted.');

		List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE Id IN :contactsToCreate];

		Assert.areEqual(newAccount.Id, contacts[0].AccountId, 'Contact should be related to Account.');
		Assert.areEqual(newAccount.Id, contacts[1].AccountId, 'Contact 2 should be related to Account.');
	}

	@IsTest
	static void toUpdateMultipleRecordsTypes() {
		// Setup
		Account account1 = getAccount(1);
		Opportunity opportunity1 = getOpportunity(1);
		Lead lead1 = getLead(1);

		insert new List<SObject>{ account1, opportunity1, lead1 };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		account1.Name = 'Updated Test Account';
		opportunity1.Name = 'Updated Test Opportunity';
		lead1.FirstName = 'Updated Test';

		DML.Result result = new DML().toUpdate(account1).toUpdate(opportunity1).toUpdate(lead1).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(3, dmlsAfter - dmlsBefore, '3 DML statements should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be updated.');
		Assert.areEqual(1, [SELECT COUNT() FROM Opportunity], 'Opportunity should be updated.');
		Assert.areEqual(1, [SELECT COUNT() FROM Lead], 'Lead should be updated.');

		Assert.areEqual('Updated Test Account', account1.Name, 'Account should be updated.');
		Assert.areEqual('Updated Test Opportunity', opportunity1.Name, 'Opportunity should be updated.');
		Assert.areEqual('Updated Test', lead1.FirstName, 'Lead should be updated.');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(3, result.updates().size(), 'Updated operation result should contain 3 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult accountOperationResult = result.updatesOf(Account.SObjectType);

		Assert.areEqual(1, accountOperationResult.records().size(), 'Updated operation result should contain the updated record.');
		Assert.areEqual(1, accountOperationResult.recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.areEqual(Account.SObjectType, accountOperationResult.objectType(), 'Updated operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, accountOperationResult.operationType(), 'Updated operation result should contain update type.');
		Assert.isFalse(accountOperationResult.hasFailures(), 'Updated operation result should not have failures.');

		DML.OperationResult opportunityOperationResult = result.updatesOf(Opportunity.SObjectType);

		Assert.areEqual(1, opportunityOperationResult.records().size(), 'Updated operation result should contain the updated record.');
		Assert.areEqual(1, opportunityOperationResult.recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.areEqual(Opportunity.SObjectType, opportunityOperationResult.objectType(), 'Updated operation result should contain Opportunity object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, opportunityOperationResult.operationType(), 'Updated operation result should contain update type.');
		Assert.isFalse(opportunityOperationResult.hasFailures(), 'Updated operation result should not have failures.');

		DML.OperationResult leadOperationResult = result.updatesOf(Lead.SObjectType);

		Assert.areEqual(1, leadOperationResult.records().size(), 'Updated operation result should contain the updated record.');
		Assert.areEqual(1, leadOperationResult.recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.areEqual(Lead.SObjectType, leadOperationResult.objectType(), 'Updated operation result should contain Lead object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, leadOperationResult.operationType(), 'Updated operation result should contain update type.');
		Assert.isFalse(leadOperationResult.hasFailures(), 'Updated operation result should not have failures.');
	}

	@IsTest
	static void toUpdateListOfRecords() {
		// Setup
		List<Account> accounts = new List<Account>{ getAccount(1), getAccount(2), getAccount(3) };
		insert accounts;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		accounts[0].Name = 'Updated Test Account 1';
		accounts[1].Name = 'Updated Test Account 2';
		accounts[2].Name = 'Updated Test Account 3';

		new DML().toUpdate(accounts).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(3, [SELECT COUNT() FROM Account], 'Accounts should be updated.');

		Assert.areEqual('Updated Test Account 1', accounts[0].Name, 'Account 1 should be updated.');
		Assert.areEqual('Updated Test Account 2', accounts[1].Name, 'Account 2 should be updated.');
		Assert.areEqual('Updated Test Account 3', accounts[2].Name, 'Account 3 should be updated.');
	}

	@IsTest
	static void toUpdateWithEmptyRecords() {
		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toUpdate(new List<Account>()).commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be updated in the database.');
		Assert.areEqual(0, dmlStatementsAfter - dmlStatementsBefore, 'No DML statements should be executed.');
		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 1 result.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.merges().size(), 'Merged operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');
	}

	// ================================================ UPDATE IMMEDIATELY =================================================

	@IsTest
	static void updateImmediatelySingleRecord() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;
		account1.Name = 'Updated Test Account';

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.OperationResult result = new DML().updateImmediately(account1);

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account WHERE Name = 'Updated Test Account'], 'Single record should be updated.');
		Assert.areEqual('Updated Test Account', account1.Name, 'Account should be updated.');
		Assert.areEqual(1, result.records().size(), 'Updated operation result should contain the updated record.');
		Assert.areEqual(1, result.recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Updated operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, result.operationType(), 'Updated operation result should contain update type.');
		Assert.isFalse(result.hasFailures(), 'Updated operation result should not have failures.');
	}

	@IsTest
	static void updateImmediatelyMultipleRecords() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);
		insert new List<Account>{ account1, account2 };

		account1.Name = 'Updated Test Account 1';
		account2.Name = 'Updated Test Account 2';

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.OperationResult result = new DML().updateImmediately(new List<Account>{ account1, account2 });

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(2, [SELECT COUNT() FROM Account WHERE Name IN ('Updated Test Account 1', 'Updated Test Account 2')], 'Accounts should be updated.');

		Assert.areEqual('Updated Test Account 1', account1.Name, 'Account 1 should be updated.');
		Assert.areEqual('Updated Test Account 2', account2.Name, 'Account 2 should be updated.');

		Assert.areEqual(2, result.records().size(), 'Updated operation result should contain the updated records.');
		Assert.areEqual(2, result.recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Updated operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, result.operationType(), 'Updated operation result should contain update type.');
		Assert.isFalse(result.hasFailures(), 'Updated operation result should not have failures.');
	}

	@IsTest
	static void updateImmediatelyWithDmlRecord() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.OperationResult result = new DML().updateImmediately(DML.Record(account1).with(Account.Name, 'Updated DML Record Account'));

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual('Updated DML Record Account', [SELECT Name FROM Account WHERE Id = :account1.Id].Name, 'Account name should be updated.');
		Assert.areEqual(1, result.records().size(), 'Updated operation result should contain the updated record.');
		Assert.areEqual(1, result.recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Updated operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, result.operationType(), 'Updated operation result should contain update type.');
		Assert.isFalse(result.hasFailures(), 'Updated operation result should not have failures.');
	}

	@IsTest
	static void updateImmediatelyWithDmlRecords() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);
		insert new List<Account>{ account1, account2 };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.OperationResult result = new DML().updateImmediately(DML.Records(new List<Account>{ account1, account2 }).with(Account.Name, 'Updated DML Records Account'));

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(2, [SELECT COUNT() FROM Account WHERE Name = 'Updated DML Records Account'], 'Account names should be updated.');

		Assert.areEqual(2, result.records().size(), 'Updated operation result should contain the updated records.');
		Assert.areEqual(2, result.recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Updated operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, result.operationType(), 'Updated operation result should contain update type.');
		Assert.isFalse(result.hasFailures(), 'Updated operation result should not have failures.');
	}

	// ================================================ UPSERT =================================================

	@IsTest
	static void toUpsertSingleExistingRecord() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		account1.Name = 'Updated Test Account';

		DML.Result result = new DML().toUpsert(account1).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be updated.');

		Assert.areEqual('Updated Test Account', account1.Name, 'Account should be updated.');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(1, result.upserts().size(), 'Upserted operation result should contain 1 result.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult operationResult = result.upsertsOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Upserted operation result should contain the upserted records.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Upserted operation result should contain the upserted record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Upserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPSERT_DML, operationResult.operationType(), 'Upserted operation result should contain upsert type.');
		Assert.isFalse(operationResult.hasFailures(), 'Upserted operation result should not have failures.');
	}

	@IsTest
	static void toUpsertSingleNewRecord() {
		// Setup
		Account account1 = getAccount(1);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toUpsert(account1).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be inserted.');

		Assert.isNotNull(account1.Id, 'Account should be inserted and have an Id.');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(1, result.upserts().size(), 'Upserted operation result should contain 1 result.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult operationResult = result.upsertsOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Upserted operation result should contain the upserted records.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Upserted operation result should contain the upserted record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Upserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPSERT_DML, operationResult.operationType(), 'Upserted operation result should contain upsert type.');
		Assert.isFalse(operationResult.hasFailures(), 'Upserted operation result should not have failures.');
	}

	@IsTest
	static void toUpsertMultipleExistingRecords() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		insert new List<Account>{ account1, account2 };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		account1.Name = 'Updated Test Account 1';
		account2.Name = 'Updated Test Account 2';

		new DML().toUpsert(account1).toUpsert(account2).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(2, [SELECT COUNT() FROM Account], 'Accounts should be updated.');

		Assert.areEqual('Updated Test Account 1', account1.Name, 'Account 1 should be updated.');
		Assert.areEqual('Updated Test Account 2', account2.Name, 'Account 2 should be updated.');
	}

	@IsTest
	static void toUpsertMultipleNewRecords() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toUpsert(account1).toUpsert(account2).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(2, [SELECT COUNT() FROM Account], 'Accounts should be inserted.');

		Assert.isNotNull(account1.Id, 'Account 1 should be inserted and have an Id.');
		Assert.isNotNull(account2.Id, 'Account 2 should be inserted and have an Id.');
	}

	@IsTest
	static void toUpsertExistingAndNewRecords() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		insert account1;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		account1.Name = 'Updated Test Account 1';

		new DML().toUpsert(account1).toUpsert(account2).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(2, [SELECT COUNT() FROM Account], 'Both accounts should be upserted.');

		Assert.areEqual('Updated Test Account 1', account1.Name, 'Account 1 should be updated.');
		Assert.isNotNull(account2.Id, 'Account 2 should be inserted and have an Id.');
	}

	@IsTest
	static void toUpsertListOfRecords() {
		// Setup
		List<Account> existingAccounts = new List<Account>{ getAccount(1), getAccount(2), getAccount(3) };
		insert existingAccounts;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		existingAccounts[0].Name = 'Updated Test Account 1';
		existingAccounts[1].Name = 'Updated Test Account 2';
		existingAccounts[2].Name = 'Updated Test Account 3';

		List<Account> newAccounts = new List<Account>{ getAccount(1), getAccount(2), getAccount(3) };

		new DML().toUpsert(existingAccounts).toUpsert(newAccounts).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(6, [SELECT COUNT() FROM Account], 'Accounts should be updated and inserted.');

		Assert.areEqual('Updated Test Account 1', existingAccounts[0].Name, 'Account 1 should be updated.');
		Assert.areEqual('Updated Test Account 2', existingAccounts[1].Name, 'Account 2 should be updated.');
		Assert.areEqual('Updated Test Account 3', existingAccounts[2].Name, 'Account 3 should be updated.');

		Assert.isNotNull(newAccounts[0].Id, 'New Account 1 should be inserted and have an Id.');
		Assert.isNotNull(newAccounts[1].Id, 'New Account 2 should be inserted and have an Id.');
		Assert.isNotNull(newAccounts[2].Id, 'New Account 3 should be inserted and have an Id.');
	}

	@IsTest
	static void toUpsertWithEmptyRecords() {
		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toUpsert(new List<Account>()).commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be upserted in the database.');
		Assert.areEqual(0, dmlStatementsAfter - dmlStatementsBefore, 'No DML statements should be executed.');
		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 1 result.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.merges().size(), 'Merged operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');
	}

	// ================================================ UPSERT IMMEDIATELY =================================================

	@IsTest
	static void upsertImmediatelySingleRecord() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;
		account1.Name = 'Upserted Test Account';

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.OperationResult result = new DML().upsertImmediately(account1);

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account WHERE Name = 'Upserted Test Account'], 'Single record should be upserted.');
		Assert.areEqual('Upserted Test Account', account1.Name, 'Account should be upserted.');
		Assert.areEqual(1, result.records().size(), 'Upserted operation result should contain the upserted record.');
		Assert.areEqual(1, result.recordResults().size(), 'Upserted operation result should contain the upserted record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Upserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPSERT_DML, result.operationType(), 'Upserted operation result should contain upsert type.');
		Assert.isFalse(result.hasFailures(), 'Upserted operation result should not have failures.');
	}

	@IsTest
	static void upsertImmediatelyMultipleRecords() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);
		insert account1; // Make account1 existing for upsert

		account1.Name = 'Upserted Test Account 1';
		// account2 is new for upsert

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.OperationResult result = new DML().upsertImmediately(new List<Account>{ account1, account2 });

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(2, [SELECT COUNT() FROM Account], 'Accounts should be upserted.');

		Assert.areEqual('Upserted Test Account 1', account1.Name, 'Account 1 should be updated.');
		Assert.isNotNull(account2.Id, 'Account 2 should be inserted and have an Id.');

		Assert.areEqual(2, result.records().size(), 'Upserted operation result should contain the upserted records.');
		Assert.areEqual(2, result.recordResults().size(), 'Upserted operation result should contain the upserted record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Upserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPSERT_DML, result.operationType(), 'Upserted operation result should contain upsert type.');
		Assert.isFalse(result.hasFailures(), 'Upserted operation result should not have failures.');
	}

	@IsTest
	static void upsertImmediatelyWithDmlRecord() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.OperationResult result = new DML().upsertImmediately(DML.Record(account1).with(Account.Name, 'Upserted DML Record Account'));

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual('Upserted DML Record Account', [SELECT Name FROM Account WHERE Id = :account1.Id].Name, 'Account name should be upserted.');
		Assert.areEqual(1, result.records().size(), 'Upserted operation result should contain the upserted record.');
		Assert.areEqual(1, result.recordResults().size(), 'Upserted operation result should contain the upserted record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Upserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPSERT_DML, result.operationType(), 'Upserted operation result should contain upsert type.');
		Assert.isFalse(result.hasFailures(), 'Upserted operation result should not have failures.');
	}

	@IsTest
	static void upsertImmediatelyWithDmlRecords() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);
		insert account1; // Make account1 existing for upsert

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.OperationResult result = new DML().upsertImmediately(DML.Records(new List<Account>{ account1, account2 }).with(Account.Name, 'Upserted DML Records Account'));

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(2, [SELECT COUNT() FROM Account], 'Accounts should be upserted.');
		Assert.areEqual(2, [SELECT COUNT() FROM Account WHERE Name = 'Upserted DML Records Account'], 'Account names should be set.');

		Assert.isNotNull(account2.Id, 'Account 2 should be inserted and have an Id.');

		Assert.areEqual(2, result.records().size(), 'Upserted operation result should contain the upserted records.');
		Assert.areEqual(2, result.recordResults().size(), 'Upserted operation result should contain the upserted record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Upserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPSERT_DML, result.operationType(), 'Upserted operation result should contain upsert type.');
		Assert.isFalse(result.hasFailures(), 'Upserted operation result should not have failures.');
	}

	// ================================================ DELETE =================================================

	@IsTest
	static void toDeleteSingleRecordById() {
		// Setup
		Account account = insertAccount();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toDelete(account.Id).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Account should be deleted.');
	}

	@IsTest
	static void toDeleteSingleRecord() {
		// Setup
		Account account1 = insertAccount();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toDelete(account1).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Account should be deleted.');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(1, result.deletes().size(), 'Deleted operation result should contain 1 result.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult operationResult = result.deletesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Deleted operation result should contain the deleted record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, operationResult.operationType(), 'Deleted operation result should contain delete type.');
		Assert.isFalse(operationResult.hasFailures(), 'Deleted operation result should not have failures.');
	}

	@IsTest
	static void toDeleteMultipleRecords() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		insert new List<Account>{ account1, account2 };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toDelete(account1).toDelete(account2).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Accounts should be deleted.');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(1, result.deletes().size(), 'Deleted operation result should contain 1 result.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult operationResult = result.deletesOf(Account.SObjectType);

		Assert.areEqual(2, operationResult.records().size(), 'Deleted operation result should contain the deleted records.');
		Assert.areEqual(2, operationResult.recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, operationResult.operationType(), 'Deleted operation result should contain delete type.');
		Assert.isFalse(operationResult.hasFailures(), 'Deleted operation result should not have failures.');
	}

	@IsTest
	static void toDeleteListOfRecords() {
		// Setup
		List<Account> accounts = insertAccounts();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toDelete(accounts).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Accounts should be deleted.');
	}

	@IsTest
	static void toDeleteMultipleRecordsById() {
		// Setup
		List<Account> accounts = insertAccounts();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		Set<Id> accountIds = new Map<Id, Account>(accounts).keySet();

		new DML().toDelete(accountIds).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Accounts should be deleted.');
	}

	@IsTest
	static void toDeleteMultipleRecordsTypes() {
		// Setup
		Account account1 = getAccount(1);
		Opportunity opportunity1 = getOpportunity(1);
		Lead lead1 = getLead(1);

		insert new List<SObject>{ account1, opportunity1, lead1 };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toDelete(account1).toDelete(opportunity1).toDelete(lead1).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(3, dmlsAfter - dmlsBefore, '3 DML statements should be executed.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Account should be deleted.');
		Assert.areEqual(0, [SELECT COUNT() FROM Opportunity], 'Opportunity should be deleted.');
		Assert.areEqual(0, [SELECT COUNT() FROM Lead], 'Lead should be deleted.');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(3, result.deletes().size(), 'Deleted operation result should contain 3 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult accountOperationResult = result.deletesOf(Account.SObjectType);

		Assert.areEqual(1, accountOperationResult.records().size(), 'Deleted operation result should contain the deleted record.');
		Assert.areEqual(1, accountOperationResult.recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.areEqual(Account.SObjectType, accountOperationResult.objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, accountOperationResult.operationType(), 'Deleted operation result should contain delete type.');
		Assert.isFalse(accountOperationResult.hasFailures(), 'Deleted operation result should not have failures.');

		DML.OperationResult opportunityOperationResult = result.deletesOf(Opportunity.SObjectType);

		Assert.areEqual(1, opportunityOperationResult.records().size(), 'Deleted operation result should contain the deleted record.');
		Assert.areEqual(1, opportunityOperationResult.recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.areEqual(Opportunity.SObjectType, opportunityOperationResult.objectType(), 'Deleted operation result should contain Opportunity object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, opportunityOperationResult.operationType(), 'Deleted operation result should contain delete type.');
		Assert.isFalse(opportunityOperationResult.hasFailures(), 'Deleted operation result should not have failures.');

		DML.OperationResult leadOperationResult = result.deletesOf(Lead.SObjectType);

		Assert.areEqual(1, leadOperationResult.records().size(), 'Deleted operation result should contain the deleted record.');
		Assert.areEqual(1, leadOperationResult.recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.areEqual(Lead.SObjectType, leadOperationResult.objectType(), 'Deleted operation result should contain Lead object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, leadOperationResult.operationType(), 'Deleted operation result should contain delete type.');
		Assert.isFalse(leadOperationResult.hasFailures(), 'Deleted operation result should not have failures.');
	}

	@IsTest
	static void toDeleteWithoutExistingIds() {
		// Setup
		Account account = getAccount(1);

		DmlException expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toDelete(account).commitWork();
		} catch (DmlException e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual('Only existing records can be registered as deleted.', expectedException.getMessage(), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void toDeleteWithEmptyRecords() {
		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toDelete(new List<Account>()).commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be deleted from the database.');
		Assert.areEqual(0, dmlStatementsAfter - dmlStatementsBefore, 'No DML statements should be executed.');
		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 1 result.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.merges().size(), 'Merged operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');
	}

	// ================================================ DELETE IMMEDIATELY =================================================

	@IsTest
	static void deleteImmediatelySingleRecord() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.OperationResult result = new DML().deleteImmediately(account1);

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Single record should be deleted.');
		Assert.areEqual(1, result.records().size(), 'Deleted operation result should contain the deleted record.');
		Assert.areEqual(1, result.recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, result.operationType(), 'Deleted operation result should contain delete type.');
		Assert.isFalse(result.hasFailures(), 'Deleted operation result should not have failures.');
	}

	@IsTest
	static void deleteImmediatelySingleRecordById() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.OperationResult result = new DML().deleteImmediately(account1.Id);

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Single record should be deleted.');
		Assert.areEqual(1, result.records().size(), 'Deleted operation result should contain the deleted record.');
		Assert.areEqual(1, result.recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, result.operationType(), 'Deleted operation result should contain delete type.');
		Assert.isFalse(result.hasFailures(), 'Deleted operation result should not have failures.');
	}

	@IsTest
	static void deleteImmediatelyMultipleRecords() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);
		insert new List<Account>{ account1, account2 };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.OperationResult result = new DML().deleteImmediately(new List<Account>{ account1, account2 });

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Accounts should be deleted.');

		Assert.areEqual(2, result.records().size(), 'Deleted operation result should contain the deleted records.');
		Assert.areEqual(2, result.recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, result.operationType(), 'Deleted operation result should contain delete type.');
		Assert.isFalse(result.hasFailures(), 'Deleted operation result should not have failures.');
	}

	@IsTest
	static void deleteImmediatelyMultipleRecordsByIds() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		insert new List<Account>{ account1, account2 };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.OperationResult result = new DML().deleteImmediately(new List<Id>{ account1.Id, account2.Id });

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Accounts should be deleted.');

		Assert.areEqual(2, result.records().size(), 'Deleted operation result should contain the deleted records.');
		Assert.areEqual(2, result.recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, result.operationType(), 'Deleted operation result should contain delete type.');
		Assert.isFalse(result.hasFailures(), 'Deleted operation result should not have failures.');
	}

	// ================================================ HARD DELETE =================================================

	@IsTest
	static void toHardDeleteSingleRecordById() {
		// Setup
		Account account = insertAccount();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toHardDelete(account.Id).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(2, dmlsAfter - dmlsBefore, '2 DML statement should be executed.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Account should be hard deleted.');
		// No assertion with ALL ROWS, because there is Salesforce error
	}

	@IsTest
	static void toHardDeleteSingleRecord() {
		// Setup
		Account account1 = insertAccount();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toHardDelete(account1).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(2, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Account should be hard deleted.');
		// No assertion with ALL ROWS, because there is Salesforce error

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(1, result.deletes().size(), 'Deleted operation result should contain 1 result.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult operationResult = result.deletesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Hard deleted operation result should contain the deleted record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Hard deleted operation result should contain the deleted record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Hard deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, operationResult.operationType(), 'Hard deleted operation result should contain delete type.');
		Assert.isFalse(operationResult.hasFailures(), 'Hard deleted operation result should not have failures.');
	}

	@IsTest
	static void toHardDeleteMultipleRecords() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		insert new List<Account>{ account1, account2 };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toHardDelete(account1).toHardDelete(account2).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(2, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Accounts should be hard deleted.');
		// No assertion with ALL ROWS, because there is Salesforce error

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(1, result.deletes().size(), 'Deleted operation result should contain 1 result.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult operationResult = result.deletesOf(Account.SObjectType);

		Assert.areEqual(2, operationResult.records().size(), 'Hard deleted operation result should contain the deleted records.');
		Assert.areEqual(2, operationResult.recordResults().size(), 'Hard deleted operation result should contain the deleted record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Hard deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, operationResult.operationType(), 'Hard deleted operation result should contain delete type.');
		Assert.isFalse(operationResult.hasFailures(), 'Hard deleted operation result should not have failures.');
	}

	@IsTest
	static void toHardDeleteListOfRecords() {
		// Setup
		List<Account> accounts = insertAccounts();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toHardDelete(accounts).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(2, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Accounts should be hard deleted.');
		// No assertion with ALL ROWS, because there is Salesforce error
	}

	@IsTest
	static void toHardDeleteMultipleRecordsById() {
		// Setup
		List<Account> accounts = insertAccounts();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		Set<Id> accountIds = new Map<Id, Account>(accounts).keySet();

		new DML().toHardDelete(accountIds).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(2, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Accounts should be hard deleted.');
		// No assertion with ALL ROWS, because there is Salesforce error
	}

	@IsTest
	static void toHardDeleteMultipleRecordsTypes() {
		// Setup
		Account account1 = getAccount(1);
		Opportunity opportunity1 = getOpportunity(1);
		Lead lead1 = getLead(1);

		insert new List<SObject>{ account1, opportunity1, lead1 };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.Result result = new DML().toHardDelete(account1).toHardDelete(opportunity1).toHardDelete(lead1).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(6, dmlsAfter - dmlsBefore, '6 DML statements should be executed (3 deletes + 3 hard deletes).');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Account should be hard deleted.');
		Assert.areEqual(0, [SELECT COUNT() FROM Opportunity], 'Opportunity should be hard deleted.');
		Assert.areEqual(0, [SELECT COUNT() FROM Lead], 'Lead should be hard deleted.');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(3, result.deletes().size(), 'Deleted operation result should contain 3 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult accountOperationResult = result.deletesOf(Account.SObjectType);

		Assert.areEqual(1, accountOperationResult.records().size(), 'Hard deleted operation result should contain the deleted record.');
		Assert.areEqual(1, accountOperationResult.recordResults().size(), 'Hard deleted operation result should contain the deleted record results.');
		Assert.areEqual(Account.SObjectType, accountOperationResult.objectType(), 'Hard deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, accountOperationResult.operationType(), 'Hard deleted operation result should contain delete type.');
		Assert.isFalse(accountOperationResult.hasFailures(), 'Hard deleted operation result should not have failures.');

		DML.OperationResult opportunityOperationResult = result.deletesOf(Opportunity.SObjectType);

		Assert.areEqual(1, opportunityOperationResult.records().size(), 'Hard deleted operation result should contain the deleted record.');
		Assert.areEqual(1, opportunityOperationResult.recordResults().size(), 'Hard deleted operation result should contain the deleted record results.');
		Assert.areEqual(Opportunity.SObjectType, opportunityOperationResult.objectType(), 'Hard deleted operation result should contain Opportunity object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, opportunityOperationResult.operationType(), 'Hard deleted operation result should contain delete type.');
		Assert.isFalse(opportunityOperationResult.hasFailures(), 'Hard deleted operation result should not have failures.');

		DML.OperationResult leadOperationResult = result.deletesOf(Lead.SObjectType);

		Assert.areEqual(1, leadOperationResult.records().size(), 'Hard deleted operation result should contain the deleted record.');
		Assert.areEqual(1, leadOperationResult.recordResults().size(), 'Hard deleted operation result should contain the deleted record results.');
		Assert.areEqual(Lead.SObjectType, leadOperationResult.objectType(), 'Hard deleted operation result should contain Lead object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, leadOperationResult.operationType(), 'Hard deleted operation result should contain delete type.');
		Assert.isFalse(leadOperationResult.hasFailures(), 'Hard deleted operation result should not have failures.');
	}

	@IsTest
	static void toHardDeleteWithEmptyRecords() {
		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toHardDelete(new List<Account>()).commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be deleted from the database.');
		Assert.areEqual(0, dmlStatementsAfter - dmlStatementsBefore, 'No DML statements should be executed.');
		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.merges().size(), 'Merged operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');
	}

	@IsTest
	static void toHardDeleteWithoutExistingIds() {
		// Setup
		Account account = getAccount(1);

		DmlException expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toHardDelete(account).commitWork();
		} catch (DmlException e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual('Only existing records can be registered as deleted.', expectedException.getMessage(), 'Expected exception message should be thrown.');
	}

	// ================================================ UNDELETE =================================================

	@IsTest
	static void toUndeleteSingleRecordById() {
		// Setup
		Account account = insertAccount();
		delete account;

		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Account should be deleted.');

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		new DML().toUndelete(account.Id).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be undeleted.');
	}

	@IsTest
	static void toUndeleteSingleRecord() {
		// Setup
		Account account1 = insertAccount();
		delete account1;

		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Account should be deleted.');

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.Result result = new DML().toUndelete(account1).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be undeleted.');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(1, result.undeletes().size(), 'Undeleted operation result should contain 1 result.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult operationResult = result.undeletesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Undeleted operation result should contain the undeleted record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Undeleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, operationResult.operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.isFalse(operationResult.hasFailures(), 'Undeleted operation result should not have failures.');
	}

	@IsTest
	static void toUndeleteMultipleRecordsById() {
		// Setup
		List<Account> accounts = insertAccounts();
		delete accounts;

		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Accounts should be deleted.');

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		Set<Id> accountIds = new Map<Id, Account>(accounts).keySet();

		new DML().toUndelete(accountIds).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(accounts.size(), [SELECT COUNT() FROM Account], 'Accounts should be undeleted.');
	}

	@IsTest
	static void toUndeleteMultipleRecords() {
		// Setup
		List<Account> accounts = insertAccounts();
		delete accounts;

		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Accounts should be deleted.');

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.Result result = new DML().toUndelete(accounts).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(accounts.size(), [SELECT COUNT() FROM Account], 'Accounts should be undeleted.');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(1, result.undeletes().size(), 'Undeleted operation result should contain 1 result.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult operationResult = result.undeletesOf(Account.SObjectType);

		Assert.areEqual(3, operationResult.records().size(), 'Undeleted operation result should contain the undeleted records.');
		Assert.areEqual(3, operationResult.recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Undeleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, operationResult.operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.isFalse(operationResult.hasFailures(), 'Undeleted operation result should not have failures.');
	}

	@IsTest
	static void toUndeleteMultipleRecordsTypes() {
		// Setup
		Account account1 = getAccount(1);
		Opportunity opportunity1 = getOpportunity(1);
		Lead lead1 = getLead(1);

		insert new List<SObject>{ account1, opportunity1, lead1 };
		delete new List<SObject>{ account1, opportunity1, lead1 };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.Result result = new DML().toUndelete(account1).toUndelete(opportunity1).toUndelete(lead1).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(3, dmlsAfter - dmlsBefore, '3 DML statements should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be undeleted.');
		Assert.areEqual(1, [SELECT COUNT() FROM Opportunity], 'Opportunity should be undeleted.');
		Assert.areEqual(1, [SELECT COUNT() FROM Lead], 'Lead should be undeleted.');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(3, result.undeletes().size(), 'Undeleted operation result should contain 3 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult accountOperationResult = result.undeletesOf(Account.SObjectType);

		Assert.areEqual(1, accountOperationResult.records().size(), 'Undeleted operation result should contain the undeleted record.');
		Assert.areEqual(1, accountOperationResult.recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.areEqual(Account.SObjectType, accountOperationResult.objectType(), 'Undeleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, accountOperationResult.operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.isFalse(accountOperationResult.hasFailures(), 'Undeleted operation result should not have failures.');

		DML.OperationResult opportunityOperationResult = result.undeletesOf(Opportunity.SObjectType);

		Assert.areEqual(1, opportunityOperationResult.records().size(), 'Undeleted operation result should contain the undeleted record.');
		Assert.areEqual(1, opportunityOperationResult.recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.areEqual(Opportunity.SObjectType, opportunityOperationResult.objectType(), 'Undeleted operation result should contain Opportunity object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, opportunityOperationResult.operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.isFalse(opportunityOperationResult.hasFailures(), 'Undeleted operation result should not have failures.');

		DML.OperationResult leadOperationResult = result.undeletesOf(Lead.SObjectType);

		Assert.areEqual(1, leadOperationResult.records().size(), 'Undeleted operation result should contain the undeleted record.');
		Assert.areEqual(1, leadOperationResult.recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.areEqual(Lead.SObjectType, leadOperationResult.objectType(), 'Undeleted operation result should contain Lead object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, leadOperationResult.operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.isFalse(leadOperationResult.hasFailures(), 'Undeleted operation result should not have failures.');
	}

	@IsTest
	static void toUndeleteWithEmptyRecords() {
		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toUndelete(new List<Account>()).commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be undeleted in the database.');
		Assert.areEqual(0, dmlStatementsAfter - dmlStatementsBefore, 'No DML statements should be executed.');
		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 1 result.');
		Assert.areEqual(0, result.merges().size(), 'Merged operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');
	}

	// ================================================ UNDELETE IMMEDIATELY =================================================

	@IsTest
	static void undeleteImmediatelySingleRecord() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;
		delete account1;

		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Account should be deleted.');

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.OperationResult result = new DML().undeleteImmediately(account1);
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Single record should be undeleted.');
		Assert.areEqual(1, result.records().size(), 'Undeleted operation result should contain the undeleted record.');
		Assert.areEqual(1, result.recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Undeleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, result.operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.isFalse(result.hasFailures(), 'Undeleted operation result should not have failures.');
	}

	@IsTest
	static void undeleteImmediatelySingleRecordById() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;
		delete account1;

		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Account should be deleted.');

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.OperationResult result = new DML().undeleteImmediately(account1.Id);
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Single record should be undeleted.');
		Assert.areEqual(1, result.records().size(), 'Undeleted operation result should contain the undeleted record.');
		Assert.areEqual(1, result.recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Undeleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, result.operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.isFalse(result.hasFailures(), 'Undeleted operation result should not have failures.');
	}

	@IsTest
	static void undeleteImmediatelyMultipleRecords() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);
		insert new List<Account>{ account1, account2 };
		delete new List<Account>{ account1, account2 };

		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Accounts should be deleted.');

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.OperationResult result = new DML().undeleteImmediately(new List<Account>{ account1, account2 });
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(2, [SELECT COUNT() FROM Account], 'Accounts should be undeleted.');

		Assert.areEqual(2, result.records().size(), 'Undeleted operation result should contain the undeleted records.');
		Assert.areEqual(2, result.recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Undeleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, result.operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.isFalse(result.hasFailures(), 'Undeleted operation result should not have failures.');
	}

	@IsTest
	static void undeleteImmediatelyMultipleRecordsByIds() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);
		insert new List<Account>{ account1, account2 };
		delete new List<Account>{ account1, account2 };

		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Accounts should be deleted.');

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.OperationResult result = new DML().undeleteImmediately(new List<Id>{ account1.Id, account2.Id });
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(2, [SELECT COUNT() FROM Account], 'Accounts should be undeleted.');

		Assert.areEqual(2, result.records().size(), 'Undeleted operation result should contain the undeleted records.');
		Assert.areEqual(2, result.recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.areEqual(Account.SObjectType, result.objectType(), 'Undeleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, result.operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.isFalse(result.hasFailures(), 'Undeleted operation result should not have failures.');
	}

	// ================================================ MERGE =================================================

	@IsTest
	static void toMergeSingleDuplicateRecord() {
		// Setup
		Account masterAccount = getAccount(1);
		Account duplicateAccount = getAccount(2);

		insert new List<Account>{ masterAccount, duplicateAccount };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toMerge(masterAccount, duplicateAccount).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Only master account should remain after merge.');
		Assert.areEqual(masterAccount.Id, [SELECT Id FROM Account LIMIT 1].Id, 'Master account should survive the merge.');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(1, result.merges().size(), 'Merged operation result should contain 1 result.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');

		DML.OperationResult operationResult = result.mergesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Merged operation result should contain the merged record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Merged operation result should contain the merged record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Merged operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.MERGE_DML, operationResult.operationType(), 'Merged operation result should contain merge type.');
		Assert.isFalse(operationResult.hasFailures(), 'Merged operation result should not have failures.');
	}

	@IsTest
	static void toMergeSingleDuplicateRecordById() {
		// Setup
		Account masterAccount = getAccount(1);
		Account duplicateAccount = getAccount(2);
		insert new List<Account>{ masterAccount, duplicateAccount };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toMerge(masterAccount, duplicateAccount.Id).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Only master account should remain after merge.');
		Assert.areEqual(masterAccount.Id, [SELECT Id FROM Account LIMIT 1].Id, 'Master account should survive the merge.');

		Assert.areEqual(1, result.merges().size(), 'Merged operation result should contain 1 result.');

		DML.OperationResult operationResult = result.mergesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Merged operation result should contain the merged record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Merged operation result should contain the merged record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Merged operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.MERGE_DML, operationResult.operationType(), 'Merged operation result should contain merge type.');
		Assert.isFalse(operationResult.hasFailures(), 'Merged operation result should not have failures.');
	}

	@IsTest
	static void toMergeMultipleDuplicateRecords() {
		// Setup
		Account masterAccount = getAccount(1);
		Account duplicateAccount1 = getAccount(2);
		Account duplicateAccount2 = getAccount(3);
		insert new List<Account>{ masterAccount, duplicateAccount1, duplicateAccount2 };

		List<Account> duplicateAccounts = new List<Account>{ duplicateAccount1, duplicateAccount2 };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toMerge(masterAccount, duplicateAccounts).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Only master account should remain after merge.');
		Assert.areEqual(masterAccount.Id, [SELECT Id FROM Account LIMIT 1].Id, 'Master account should survive the merge.');

		Assert.areEqual(1, result.merges().size(), 'Merged operation result should contain 1 result.');

		DML.OperationResult operationResult = result.mergesOf(Account.SObjectType);

		Assert.areEqual(2, operationResult.records().size(), 'Merged operation result should contain the merged record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Merged operation result should contain the merged record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Merged operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.MERGE_DML, operationResult.operationType(), 'Merged operation result should contain merge type.');
		Assert.isFalse(operationResult.hasFailures(), 'Merged operation result should not have failures.');
	}

	@IsTest
	static void toMergeMultipleDuplicateRecordsById() {
		// Setup
		Account masterAccount = getAccount(1);
		Account duplicateAccount1 = getAccount(2);
		Account duplicateAccount2 = getAccount(3);
		insert new List<Account>{ masterAccount, duplicateAccount1, duplicateAccount2 };

		Set<Id> duplicateAccountIds = new Set<Id>{ duplicateAccount1.Id, duplicateAccount2.Id };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toMerge(masterAccount, duplicateAccountIds).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Only master account should remain after merge.');
		Assert.areEqual(masterAccount.Id, [SELECT Id FROM Account LIMIT 1].Id, 'Master account should survive the merge.');

		Assert.areEqual(1, result.merges().size(), 'Merged operation result should contain 1 result.');

		DML.OperationResult operationResult = result.mergesOf(Account.SObjectType);

		Assert.areEqual(2, operationResult.records().size(), 'Merged operation result should contain the merged record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Merged operation result should contain the merged record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Merged operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.MERGE_DML, operationResult.operationType(), 'Merged operation result should contain merge type.');
		Assert.isFalse(operationResult.hasFailures(), 'Merged operation result should not have failures.');
	}

	@IsTest
	static void toMergeWithRelatedRecords() {
		// Setup
		Account masterAccount = getAccount(1);
		Account duplicateAccount = getAccount(2);
		insert new List<Account>{ masterAccount, duplicateAccount };

		Contact contactOnDuplicate = getContact(1);
		contactOnDuplicate.AccountId = duplicateAccount.Id;
		insert contactOnDuplicate;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toMerge(masterAccount, duplicateAccount).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Only master account should remain after merge.');
		Assert.areEqual(1, [SELECT COUNT() FROM Contact], 'Contact should still exist.');

		Contact reparentedContact = [SELECT Id, AccountId FROM Contact WHERE Id = :contactOnDuplicate.Id];
		Assert.areEqual(masterAccount.Id, reparentedContact.AccountId, 'Contact should be reparented to master account.');
	}

	@IsTest
	static void toMergeWithoutExistingMasterRecord() {
		// Setup
		Account masterAccount = getAccount(1);
		Account duplicateAccount = getAccount(2);
		insert duplicateAccount;

		DmlException expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toMerge(masterAccount, duplicateAccount).commitWork();
		} catch (DmlException e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual('Only existing records can be merged.', expectedException.getMessage(), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void toMergeWithoutExistingDuplicateRecord() {
		// Setup
		Account masterAccount = getAccount(1);
		Account duplicateAccount = getAccount(2);
		insert masterAccount;

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toMerge(masterAccount, duplicateAccount).commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
	}

	@IsTest
	static void toMergeLeads() {
		// Setup
		Lead masterLead = getLead(1);
		Lead duplicateLead = getLead(2);
		insert new List<Lead>{ masterLead, duplicateLead };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.Result result = new DML().toMerge(masterLead, duplicateLead).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Lead], 'Only master lead should remain after merge.');
		Assert.areEqual(masterLead.Id, [SELECT Id FROM Lead LIMIT 1].Id, 'Master lead should survive the merge.');

		Assert.areEqual(1, result.merges().size(), 'Merged operation result should contain 1 result.');

		DML.OperationResult operationResult = result.mergesOf(Lead.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Merged operation result should contain the merged record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Merged operation result should contain the merged record results.');
		Assert.areEqual(Lead.SObjectType, operationResult.objectType(), 'Merged operation result should contain Lead object type.');
		Assert.areEqual(DML.OperationType.MERGE_DML, operationResult.operationType(), 'Merged operation result should contain merge type.');
		Assert.isFalse(operationResult.hasFailures(), 'Merged operation result should not have failures.');
	}

	@IsTest
	static void toMergeContacts() {
		// Setup
		Contact masterContact = getContact(1);
		Contact duplicateContact = getContact(2);
		insert new List<Contact>{ masterContact, duplicateContact };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.Result result = new DML().toMerge(masterContact, duplicateContact).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Contact], 'Only master contact should remain after merge.');
		Assert.areEqual(masterContact.Id, [SELECT Id FROM Contact LIMIT 1].Id, 'Master contact should survive the merge.');

		Assert.areEqual(1, result.merges().size(), 'Merged operation result should contain 1 result.');

		DML.OperationResult operationResult = result.mergesOf(Contact.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Merged operation result should contain the merged record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Merged operation result should contain the merged record results.');
		Assert.areEqual(Contact.SObjectType, operationResult.objectType(), 'Merged operation result should contain Contact object type.');
		Assert.areEqual(DML.OperationType.MERGE_DML, operationResult.operationType(), 'Merged operation result should contain merge type.');
		Assert.isFalse(operationResult.hasFailures(), 'Merged operation result should not have failures.');
	}

	//  ================================================ PLATFORM EVENT =================================================

	@IsTest
	static void toPublishSingleRecord() {
		// Setup
		FlowOrchestrationEvent event = new FlowOrchestrationEvent();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.Result result = new DML().toPublish(event).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(1, result.events().size(), 'Published operation result should contain 1 result.');

		DML.OperationResult operationResult = result.eventsOf(FlowOrchestrationEvent.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Published operation result should contain the published record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Published operation result should contain the published record results.');
		Assert.areEqual(FlowOrchestrationEvent.SObjectType, operationResult.objectType(), 'Published operation result should contain FlowOrchestrationEvent object type.');
		Assert.areEqual(DML.OperationType.PUBLISH_DML, operationResult.operationType(), 'Published operation result should contain publish type.');
		Assert.isTrue(operationResult.hasFailures(), 'Published operation result should have failures.');
	}

	@IsTest
	static void toPublishMultipleRecords() {
		// Setup
		List<FlowOrchestrationEvent> events = new List<FlowOrchestrationEvent>{ new FlowOrchestrationEvent(), new FlowOrchestrationEvent() };

		Exception expectedException = null;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.Result result = null;
		try {
			result = new DML().toPublish(events).commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.isNull(expectedException, 'Expected exception should not be thrown.');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(1, result.events().size(), 'Published operation result should contain 1 result.');

		DML.OperationResult operationResult = result.eventsOf(FlowOrchestrationEvent.SObjectType);

		Assert.areEqual(2, operationResult.records().size(), 'Published operation result should contain the published records.');
		Assert.areEqual(2, operationResult.recordResults().size(), 'Published operation result should contain the published record results.');
		Assert.areEqual(FlowOrchestrationEvent.SObjectType, operationResult.objectType(), 'Published operation result should contain FlowOrchestrationEvent object type.');
		Assert.areEqual(DML.OperationType.PUBLISH_DML, operationResult.operationType(), 'Published operation result should contain publish type.');
		Assert.isTrue(operationResult.hasFailures(), 'Published operation result should have failures.');
	}

	@IsTest
	static void toPublishWithEmptyRecords() {
		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toPublish(new List<FlowOrchestrationEvent>()).commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, dmlStatementsAfter - dmlStatementsBefore, 'No DML statements should be executed.');
		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.merges().size(), 'Merged operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 1 result.');
	}

	//  ================================================ PLATFORM EVENT - IMMEDIATELY =================================================

	@IsTest
	static void publishImmediatelySingleRecord() {
		// Setup
		FlowOrchestrationEvent event = new FlowOrchestrationEvent();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.OperationResult result = new DML().publishImmediately(event);
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, result.records().size(), 'Published operation result should contain the published record.');
		Assert.areEqual(1, result.recordResults().size(), 'Published operation result should contain the published record results.');
		Assert.areEqual(FlowOrchestrationEvent.SObjectType, result.objectType(), 'Published operation result should contain FlowOrchestrationEvent object type.');
		Assert.areEqual(DML.OperationType.PUBLISH_DML, result.operationType(), 'Published operation result should contain publish type.');
	}

	@IsTest
	static void publishImmediatelyMultipleRecords() {
		// Setup
		List<FlowOrchestrationEvent> events = new List<FlowOrchestrationEvent>{ new FlowOrchestrationEvent(), new FlowOrchestrationEvent() };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.OperationResult operationResult = new DML().publishImmediately(events);
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(2, operationResult.records().size(), 'Published operation result should contain the published records.');
		Assert.areEqual(2, operationResult.recordResults().size(), 'Published operation result should contain the published record results.');
		Assert.areEqual(FlowOrchestrationEvent.SObjectType, operationResult.objectType(), 'Published operation result should contain FlowOrchestrationEvent object type.');
		Assert.areEqual(DML.OperationType.PUBLISH_DML, operationResult.operationType(), 'Published operation result should contain publish type.');
	}

	//  ================================================ DEBUG =================================================

	@IsTest
	static void dryRun() {
		// Setup
		Account account = getAccount(1);

		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		new DML().toInsert(account).dryRun();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Account should not be inserted.');
		Assert.areEqual(
			4,
			dmlStatementsAfter - dmlStatementsBefore,
			'DML statements should be 4, because one for savepoint, one for rollback, one for release savepoint, and one for the insert.'
		);
	}

	@IsTest
	static void dryRunWhenExceptionIsThrown() {
		// Setup
		Account account = getAccount(1);
		account.Name = null;

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toInsert(account).dryRun();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception should be thrown.');
	}

	@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveAsserts')
	@IsTest
	static void preview() {
		// Setup
		Account account = getAccount(1);

		// Test
		new DML().toInsert(account).preview();
	}

	// CONFIGURATION

	@IsTest
	static void commitTransaction() {
		// Setup
		Account account = getAccount(1);

		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		new DML().toInsert(account).commitTransaction();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be inserted.');
		Assert.isTrue(dmlStatementsAfter - dmlStatementsBefore >= 3, 'DML statements should be greater than or equal to 3, because savepoint was set and rollback was called.');
	}

	@IsTest
	static void commitTransactionWhenExceptionIsThrown() {
		// Setup
		Account account = getAccount(1);
		account.Name = null;

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toInsert(account).toInsert(account).commitTransaction();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception should be thrown.');
	}

	@IsTest
	static void commitTransactionWhenAllOrNoneIsFalse() {
		// Setup
		Account account = getAccount(1);

		// Test
		Test.startTest();
		Exception expectedException = null;

		try {
			new DML().toInsert(account).allowPartialSuccess().commitTransaction();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception should be thrown.');
		Assert.areEqual('commitTransaction() is not supported when allOrNone=false', expectedException.getMessage(), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void discardWork() {
		// Setup
		Account account = getAccount(1);

		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toInsert(account).discardWork().commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, dmlStatementsAfter - dmlStatementsBefore, 'DML statements should be 0, because work was discarded.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Account should not be inserted.');

		Assert.areEqual(0, result.inserts().size(), 'Result should contain 0 insert operation results.');
		Assert.areEqual(0, result.updates().size(), 'Result should contain 0 update operation results.');
		Assert.areEqual(0, result.upserts().size(), 'Result should contain 0 upsert operation results.');
		Assert.areEqual(0, result.deletes().size(), 'Result should contain 0 delete operation results.');
		Assert.areEqual(0, result.undeletes().size(), 'Result should contain 0 undelete operation results.');
		Assert.areEqual(0, result.events().size(), 'Result should contain 0 publish operation results.');
	}

	//  ================================================ RECORD =================================================

	@IsTest
	static void singleSObjectRecordWithValue() {
		// Setup
		Account newAccount = getAccount(1);

		// Test
		Test.startTest();
		new DML()
			.toInsert(DML.Record(newAccount).with(Account.Name, 'New Test Account').with(Account.Industry, 'New Test Industry').with(Account.Description, 'New Test Description'))
			.commitWork();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be inserted.');

		List<Account> accounts = [SELECT Id, Name, Industry, Description FROM Account LIMIT 1];

		Assert.areEqual('New Test Account', accounts[0].Name, 'Account name should be "New Test Account".');
		Assert.areEqual('New Test Industry', accounts[0].Industry, 'Account industry should be "New Test Industry".');
		Assert.areEqual('New Test Description', accounts[0].Description, 'Account description should be "New Test Description".');
	}

	@IsTest
	static void singleIdRecordWithValue() {
		// Setup
		Account newAccount = getAccount(1);
		insert newAccount;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		new DML()
			.toUpdate(
				DML.Record(newAccount.Id).with(Account.Name, 'New Test Account').with(Account.Industry, 'New Test Industry').with(Account.Description, 'New Test Description')
			)
			.commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be updated.');

		List<Account> accounts = [SELECT Id, Name, Industry, Description FROM Account LIMIT 1];

		Assert.areEqual('New Test Account', accounts[0].Name, 'Account name should be "New Test Account".');
		Assert.areEqual('New Test Industry', accounts[0].Industry, 'Account industry should be "New Test Industry".');
		Assert.areEqual('New Test Description', accounts[0].Description, 'Account description should be "New Test Description".');
	}

	//  ================================================ RECORDS =================================================

	@IsTest
	static void multipleSObjectRecordsWithValue() {
		// Setup
		Account newAccount1 = getAccount(1);
		Account newAccount2 = getAccount(2);

		List<Account> newAccounts = new List<Account>{ newAccount1, newAccount2 };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		new DML().toInsert(DML.Records(newAccounts).with(Account.Industry, 'New Test Industry').with(Account.Description, 'New Test Description')).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(2, [SELECT COUNT() FROM Account], 'Accounts should be inserted.');

		List<Account> accounts = [SELECT Id, Industry, Description FROM Account LIMIT 2];

		Assert.areEqual('New Test Industry', accounts[0].Industry, 'Account industry should be "New Test Industry".');
		Assert.areEqual('New Test Description', accounts[0].Description, 'Account description should be "New Test Description".');

		Assert.areEqual('New Test Industry', accounts[1].Industry, 'Account industry should be "New Test Industry".');
		Assert.areEqual('New Test Description', accounts[1].Description, 'Account description should be "New Test Description".');
	}

	@IsTest
	static void retrieveResultForWhenIncorrectIdentifierIsUsed() {
		// Setup
		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			DML.retrieveResultFor('dmlMockId');
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual('No result found for dml identifier: dmlMockId', expectedException.getMessage(), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void mockAllDmls() {
		// Setup
		Account account1 = getAccount(1);

		Contact contact1 = getContact(1);
		contact1.Id = DML.randomIdGenerator.get(Contact.SObjectType);

		Opportunity opportunity1 = getOpportunity(1);
		opportunity1.Id = DML.randomIdGenerator.get(Opportunity.SObjectType);

		DML.mock('dmlMockId').allDmls();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		new DML().toInsert(account1).toUpdate(contact1).toDelete(opportunity1).identifier('dmlMockId').commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(0, [SELECT COUNT() FROM Contact], 'No records should be inserted to the database.');
		Assert.areEqual(0, [SELECT COUNT() FROM Opportunity], 'No records should be deleted from the database.');
		Assert.areEqual(1, result.inserts().size(), 'Inserted operation result should contain 1 result.');
		Assert.areEqual(1, result.updates().size(), 'Updated operation result should contain 1 result.');
		Assert.areEqual(1, result.deletes().size(), 'Deleted operation result should contain 1 result.');
		Assert.areEqual(Account.SObjectType, result.insertsOf(Account.SObjectType).objectType(), 'Inserted operation result should contain Account object type.');
		Assert.areEqual(Contact.SObjectType, result.updatesOf(Contact.SObjectType).objectType(), 'Updated operation result should contain Contact object type.');
		Assert.areEqual(Opportunity.SObjectType, result.deletesOf(Opportunity.SObjectType).objectType(), 'Deleted operation result should contain Opportunity object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, result.insertsOf(Account.SObjectType).operationType(), 'Inserted operation result should contain insert type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, result.updatesOf(Contact.SObjectType).operationType(), 'Updated operation result should contain update type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, result.deletesOf(Opportunity.SObjectType).operationType(), 'Deleted operation result should contain delete type.');
	}

	//  ================================================ RESULTS =================================================

	@IsTest
	static void resultAll() {
		// Setup
		Account account = getAccount(1);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.Result result = new DML().toInsert(account).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, result.all().size(), 'Result should contain 1 operation result.');
	}

	@IsTest
	static void resultInserts() {
		// Setup
		Account account1 = getAccount(1);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.Result result = new DML().toInsert(account1).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, result.inserts().size(), 'Result should contain 1 insert operation result.');
		Assert.areEqual(0, result.updates().size(), 'Result should contain 0 update operation results.');
		Assert.areEqual(0, result.upserts().size(), 'Result should contain 0 upsert operation results.');
		Assert.areEqual(0, result.deletes().size(), 'Result should contain 0 delete operation results.');
		Assert.areEqual(0, result.undeletes().size(), 'Result should contain 0 undelete operation results.');
		Assert.areEqual(0, result.events().size(), 'Result should contain 0 publish operation results.');

		DML.OperationResult operationResult = result.insertsOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Inserted operation result should contain the inserted record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Inserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, operationResult.operationType(), 'Inserted operation result should contain insert type.');
		Assert.isFalse(operationResult.hasFailures(), 'Inserted operation result should not have failures.');
	}

	@IsTest
	static void resultUpdates() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		account1.Name = 'Updated Test Account';

		DML.Result result = new DML().toUpdate(account1).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, result.inserts().size(), 'Result should contain 0 insert operation results.');
		Assert.areEqual(1, result.updates().size(), 'Result should contain 1 update operation result.');
		Assert.areEqual(0, result.upserts().size(), 'Result should contain 0 upsert operation results.');
		Assert.areEqual(0, result.deletes().size(), 'Result should contain 0 delete operation results.');
		Assert.areEqual(0, result.undeletes().size(), 'Result should contain 0 undelete operation results.');
		Assert.areEqual(0, result.events().size(), 'Result should contain 0 publish operation results.');

		DML.OperationResult operationResult = result.updatesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Updated operation result should contain the updated record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Updated operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, operationResult.operationType(), 'Updated operation result should contain update type.');
		Assert.isFalse(operationResult.hasFailures(), 'Updated operation result should not have failures.');
	}

	@IsTest
	static void resultUpserts() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		account1.Name = 'Updated Test Account';

		DML.Result result = new DML().toUpsert(account1).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, result.inserts().size(), 'Result should contain 0 insert operation results.');
		Assert.areEqual(0, result.updates().size(), 'Result should contain 0 update operation results.');
		Assert.areEqual(1, result.upserts().size(), 'Result should contain 1 upsert operation result.');
		Assert.areEqual(0, result.deletes().size(), 'Result should contain 0 delete operation results.');
		Assert.areEqual(0, result.undeletes().size(), 'Result should contain 0 undelete operation results.');
		Assert.areEqual(0, result.events().size(), 'Result should contain 0 publish operation results.');

		DML.OperationResult operationResult = result.upsertsOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Upserted operation result should contain the upserted record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Upserted operation result should contain the upserted record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Upserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPSERT_DML, operationResult.operationType(), 'Upserted operation result should contain upsert type.');
		Assert.isFalse(operationResult.hasFailures(), 'Upserted operation result should not have failures.');
	}

	@IsTest
	static void resultDeletes() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.Result result = new DML().toDelete(account1).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, result.inserts().size(), 'Result should contain 0 insert operation results.');
		Assert.areEqual(0, result.updates().size(), 'Result should contain 0 update operation results.');
		Assert.areEqual(0, result.upserts().size(), 'Result should contain 0 upsert operation results.');
		Assert.areEqual(1, result.deletes().size(), 'Result should contain 1 delete operation result.');
		Assert.areEqual(0, result.undeletes().size(), 'Result should contain 0 undelete operation results.');
		Assert.areEqual(0, result.events().size(), 'Result should contain 0 publish operation results.');

		DML.OperationResult operationResult = result.deletesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Deleted operation result should contain the deleted record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, operationResult.operationType(), 'Deleted operation result should contain delete type.');
		Assert.isFalse(operationResult.hasFailures(), 'Deleted operation result should not have failures.');
	}

	@IsTest
	static void resultUndeletes() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;
		delete account1;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.Result result = new DML().toUndelete(account1).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, result.inserts().size(), 'Result should contain 0 insert operation results.');
		Assert.areEqual(0, result.updates().size(), 'Result should contain 0 update operation results.');
		Assert.areEqual(0, result.upserts().size(), 'Result should contain 0 upsert operation results.');
		Assert.areEqual(0, result.deletes().size(), 'Result should contain 0 delete operation results.');
		Assert.areEqual(1, result.undeletes().size(), 'Result should contain 1 undelete operation result.');
		Assert.areEqual(0, result.events().size(), 'Result should contain 0 publish operation results.');

		DML.OperationResult operationResult = result.undeletesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Undeleted operation result should contain the undeleted record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Undeleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, operationResult.operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.isFalse(operationResult.hasFailures(), 'Undeleted operation result should not have failures.');
	}

	@IsTest
	static void resultEvents() {
		// Setup
		FlowOrchestrationEvent event1 = new FlowOrchestrationEvent();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		DML.Result result = new DML().toPublish(event1).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, result.inserts().size(), 'Result should contain 0 insert operation results.');
		Assert.areEqual(0, result.updates().size(), 'Result should contain 0 update operation results.');
		Assert.areEqual(0, result.upserts().size(), 'Result should contain 0 upsert operation results.');
		Assert.areEqual(0, result.deletes().size(), 'Result should contain 0 delete operation results.');
		Assert.areEqual(0, result.undeletes().size(), 'Result should contain 0 undelete operation results.');
		Assert.areEqual(1, result.events().size(), 'Result should contain 1 publish operation result.');

		DML.OperationResult operationResult = result.eventsOf(FlowOrchestrationEvent.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Published operation result should contain the published record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Published operation result should contain the published record results.');
		Assert.areEqual(FlowOrchestrationEvent.SObjectType, operationResult.objectType(), 'Published operation result should contain FlowOrchestrationEvent object type.');
		Assert.areEqual(DML.OperationType.PUBLISH_DML, operationResult.operationType(), 'Published operation result should contain publish type.');
	}

	@IsTest
	static void resultWhenFailure() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			account1.Name = ''; // Name is required

			new DML().toUpdate(account1).commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.isTrue(expectedException.getMessage().contains('Required fields are missing: [Name]'), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void resultWhenFailureButAllowPartialSuccess() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;

		// Test
		Test.startTest();
		account1.Name = ''; // Name is required

		DML.Result result = new DML().toUpdate(account1).allowPartialSuccess().commitWork();
		Test.stopTest();

		// Verify
		DML.OperationResult operationResult = result.updatesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Updated operation result should contain the updated record.');
		Assert.areEqual(0, operationResult.successes().size(), 'Updated operation result should contain 0 success record.');
		Assert.areEqual(1, operationResult.failures().size(), 'Updated operation result should contain 1 failure record.');

		Assert.areEqual(1, operationResult.recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.areEqual(1, operationResult.errors().size(), 'Updated operation result should contain 1 error.');

		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Updated operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, operationResult.operationType(), 'Updated operation result should contain update type.');
		Assert.isTrue(operationResult.hasFailures(), 'Updated operation result should have failures.');

		DML.RecordResult recordResult = operationResult.recordResults()[0];

		Assert.areEqual(account1.Id, recordResult.id(), 'Record result should contain the account id.');
		Assert.areEqual(account1, recordResult.record(), 'Record result should contain the account record.');
		Assert.isFalse(recordResult.isSuccess(), 'Record result should not be successful.');
		Assert.areEqual(1, recordResult.errors().size(), 'Record result should contain 1 error.');

		DML.Error error = recordResult.errors()[0];

		Assert.areEqual('Required fields are missing: [Name]', error.message(), 'Record result should contain the error message.');
		Assert.areEqual(System.StatusCode.REQUIRED_FIELD_MISSING, error.statusCode(), 'Record result should contain the error status code.');
		Assert.isTrue(error.fields().contains('Name'), 'Record result should contain the error fields.');
	}

	@IsTest
	static void resultMerges() {
		// Setup
		Account masterAccount = getAccount(1);
		Account duplicateAccount = getAccount(2);

		insert new List<Account>{ masterAccount, duplicateAccount };

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().toMerge(masterAccount, duplicateAccount).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, result.inserts().size(), 'Result should contain 0 insert operation results.');
		Assert.areEqual(0, result.updates().size(), 'Result should contain 0 update operation results.');
		Assert.areEqual(0, result.upserts().size(), 'Result should contain 0 upsert operation results.');
		Assert.areEqual(0, result.deletes().size(), 'Result should contain 0 delete operation results.');
		Assert.areEqual(0, result.undeletes().size(), 'Result should contain 0 undelete operation results.');
		Assert.areEqual(0, result.events().size(), 'Result should contain 0 publish operation results.');
		Assert.areEqual(1, result.merges().size(), 'Result should contain 1 merge operation result.');

		DML.OperationResult operationResult = result.mergesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Merged operation result should contain the merged record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Merged operation result should contain the merged record results.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Merged operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.MERGE_DML, operationResult.operationType(), 'Merged operation result should contain merge type.');
		Assert.isFalse(operationResult.hasFailures(), 'Merged operation result should not have failures.');
	}

	@IsTest
	static void resultWhenNoOperations() {
		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Result result = new DML().commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be executed.');
		Assert.areEqual(0, result.all().size(), 'Result should contain 0 operation results.');
		Assert.areEqual(0, result.inserts().size(), 'Result should contain 0 insert operation results.');
		Assert.areEqual(0, result.updates().size(), 'Result should contain 0 update operation results.');
		Assert.areEqual(0, result.upserts().size(), 'Result should contain 0 upsert operation results.');
		Assert.areEqual(0, result.deletes().size(), 'Result should contain 0 delete operation results.');
		Assert.areEqual(0, result.undeletes().size(), 'Result should contain 0 undelete operation results.');
		Assert.areEqual(0, result.merges().size(), 'Result should contain 0 merge operation results.');
		Assert.areEqual(0, result.events().size(), 'Result should contain 0 publish operation results.');
	}

	// ================================================ DEPENDENCIES =================================================

	@IsTest
	static void addInRandomOrder() {
		// Setup
		Account account1 = getAccount(1);
		Contact contact1 = getContact(1);
		Opportunity opportunity1 = getOpportunity(1);

		// Test
		Test.startTest();
		Exception expectedException = null;
		try {
			new DML()
				.toInsert(DML.Record(contact1).withRelationship(Contact.AccountId, account1))
				.toInsert(DML.Record(opportunity1).withRelationship(Opportunity.AccountId, account1))
				.toInsert(account1)
				.commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.isTrue(
			expectedException.getMessage().contains('Relationship was registered for a record that has not been registered yet.'),
			'Expected exception message should be thrown.'
		);
	}

	@IsTest
	static void selfDependency() {
		// Setup
		Account account1 = getAccount(1);

		// Test
		Test.startTest();
		Exception expectedException = null;
		try {
			new DML().toInsert(account1).toInsert(DML.Record(account1).withRelationship(Account.ParentId, account1)).commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.isTrue(expectedException.getMessage().contains('Self-dependency detected for record: ' + account1.Id), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void cyclicDependency() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		// Test
		Test.startTest();
		Exception expectedException = null;
		try {
			new DML()
				.toInsert(account1)
				.toInsert(DML.Record(account2).withRelationship(Account.ParentId, account1))
				.toInsert(DML.Record(account1).withRelationship(Account.ParentId, account2))
				.commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.isTrue(expectedException.getMessage().contains('Cyclic dependencies detected among records.'), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void registerComplex() {
		// Setup
		DML uow = new DML();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		for (Integer i = 0; i < 10; i++) {
			Opportunity newOpportunity = new Opportunity(Name = 'UoW Test Name ' + i, StageName = 'Open', CloseDate = System.today());

			uow.toInsert(newOpportunity);

			for (Integer j = 0; j < i + 1; j++) {
				Product2 product = new Product2(Name = newOpportunity.Name + ' : Product : ' + i);

				uow.toInsert(product);

				PricebookEntry pbe = new PricebookEntry(UnitPrice = 10, IsActive = true, UseStandardPrice = false, Pricebook2Id = Test.getStandardPricebookId());

				uow.toInsert(DML.Record(pbe).withRelationship(PricebookEntry.Product2Id, product));

				uow.toInsert(
					DML.Record(new OpportunityLineItem(Quantity = 1, TotalPrice = 10))
						.withRelationship(OpportunityLineItem.PricebookEntryId, pbe)
						.withRelationship(OpportunityLineItem.OpportunityId, newOpportunity)
				);
			}
		}
		uow.commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(4, dmlsAfter - dmlsBefore, '4 DML statements should be executed (Opportunity, Product2, PricebookEntry, OpportunityLineItem).');
		Assert.areEqual(10, [SELECT COUNT() FROM Opportunity], 'Opportunities should be inserted.');
		Assert.areEqual(55, [SELECT COUNT() FROM Product2], 'Products should be inserted.');
		Assert.areEqual(55, [SELECT COUNT() FROM PricebookEntry], 'Pricebook entries should be inserted.');
	}

	@IsTest
	static void insertUpdateAndDeleteWithRelationships() {
		// Setup
		Account existingAccount = getAccount(1);
		insert existingAccount;

		Account newAccount = getAccount(2);
		Contact contact1 = getContact(1);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Result result = new DML()
			.toInsert(newAccount)
			.toInsert(DML.Record(contact1).withRelationship(Contact.AccountId, newAccount))
			.toUpdate(DML.Record(existingAccount).with(Account.Description, 'Marked for review'))
			.toDelete(existingAccount)
			.commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(4, dmlsAfter - dmlsBefore, '4 DML statements should be executed (Account insert, Contact insert, Account update, Account delete).');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Only the new account should exist.');
		Assert.areEqual(1, [SELECT COUNT() FROM Contact], 'Contact should be inserted.');
		Assert.areEqual(newAccount.Id, [SELECT AccountId FROM Contact WHERE Id = :contact1.Id].AccountId, 'Contact should be linked to the new Account.');
		Assert.areEqual(2, result.inserts().size(), 'Inserted operation result should contain 2 object types.');
		Assert.areEqual(1, result.updates().size(), 'Updated operation result should contain 1 object type.');
		Assert.areEqual(1, result.deletes().size(), 'Deleted operation result should contain 1 object type.');
	}

	@IsTest
	static void multiLevelRelationshipHierarchy() {
		// Setup
		Account grandParentAccount = new Account(Name = 'Grand Parent Account');
		Account parentAccount = new Account(Name = 'Parent Account');
		Account childAccount = new Account(Name = 'Child Account');

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML()
			.toInsert(grandParentAccount)
			.toInsert(DML.Record(parentAccount).withRelationship(Account.ParentId, grandParentAccount))
			.toInsert(DML.Record(childAccount).withRelationship(Account.ParentId, parentAccount))
			.commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(3, dmlsAfter - dmlsBefore, '3 DML statements should be executed (one per hierarchy level due to dependencies).');
		Assert.areEqual(3, [SELECT COUNT() FROM Account], 'All accounts should be inserted.');

		Account queriedChild = [SELECT ParentId, Parent.ParentId FROM Account WHERE Id = :childAccount.Id];
		Assert.areEqual(parentAccount.Id, queriedChild.ParentId, 'Child should be linked to parent.');
		Assert.areEqual(grandParentAccount.Id, queriedChild.Parent.ParentId, 'Parent should be linked to grandparent.');
	}

	@IsTest
	static void multipleDependentObjectTypesWithRelationships() {
		// Setup
		Account account1 = getAccount(1);
		Contact contact1 = getContact(1);
		Opportunity opportunity1 = getOpportunity(1);
		Case case1 = new Case(Subject = 'Test Case 1', Status = 'New');

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Result result = new DML()
			.toInsert(account1)
			.toInsert(DML.Record(contact1).withRelationship(Contact.AccountId, account1))
			.toInsert(DML.Record(opportunity1).withRelationship(Opportunity.AccountId, account1))
			.toInsert(DML.Record(case1).withRelationship(Case.AccountId, account1).withRelationship(Case.ContactId, contact1))
			.commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(4, dmlsAfter - dmlsBefore, '4 DML statements should be executed (Account, Contact, Opportunity, Case).');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be inserted.');
		Assert.areEqual(1, [SELECT COUNT() FROM Contact], 'Contact should be inserted.');
		Assert.areEqual(1, [SELECT COUNT() FROM Opportunity], 'Opportunity should be inserted.');
		Assert.areEqual(1, [SELECT COUNT() FROM Case], 'Case should be inserted.');

		Case queriedCase = [SELECT AccountId, ContactId FROM Case WHERE Id = :case1.Id];
		Assert.areEqual(account1.Id, queriedCase.AccountId, 'Case should be linked to Account.');
		Assert.areEqual(contact1.Id, queriedCase.ContactId, 'Case should be linked to Contact.');
		Assert.areEqual(4, result.inserts().size(), 'Inserted operation result should contain 4 object types.');
	}

	@IsTest
	static void insertWithRelationshipsAndImmediateOperations() {
		// Setup
		Account account1 = getAccount(1);
		Contact contact1 = getContact(1);
		Contact contact2 = getContact(2);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML db = new DML();

		// Insert account immediately
		db.insertImmediately(account1);

		// Register contact with relationship to the already-inserted account
		db.toInsert(DML.Record(contact1).withRelationship(Contact.AccountId, account1)).toInsert(DML.Record(contact2).withRelationship(Contact.AccountId, account1)).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(2, dmlsAfter - dmlsBefore, '2 DML statements should be executed (Account immediate, Contacts commit).');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be inserted.');
		Assert.areEqual(2, [SELECT COUNT() FROM Contact], 'Contacts should be inserted.');
		Assert.areEqual(account1.Id, [SELECT AccountId FROM Contact WHERE Id = :contact1.Id].AccountId, 'Contact 1 should be linked to Account.');
		Assert.areEqual(account1.Id, [SELECT AccountId FROM Contact WHERE Id = :contact2.Id].AccountId, 'Contact 2 should be linked to Account.');
	}

	@IsTest
	static void upsertAndInsertWithRelationships() {
		// Setup
		Account existingAccount = getAccount(1);
		insert existingAccount;

		Account newAccount = getAccount(2);
		Contact contact1 = getContact(1);
		Contact contact2 = getContact(2);

		existingAccount.Description = 'Updated Description';

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML()
			.toUpsert(existingAccount) // Update existing
			.toInsert(newAccount) // Insert new
			.toInsert(DML.Record(contact1).withRelationship(Contact.AccountId, existingAccount))
			.toInsert(DML.Record(contact2).withRelationship(Contact.AccountId, newAccount))
			.commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(3, dmlsAfter - dmlsBefore, '3 DML statements should be executed (Account upsert, Account insert, Contact insert).');
		Assert.areEqual(2, [SELECT COUNT() FROM Account], 'Both accounts should exist.');
		Assert.areEqual(2, [SELECT COUNT() FROM Contact], 'Contacts should be inserted.');
		Assert.areEqual('Updated Description', [SELECT Description FROM Account WHERE Id = :existingAccount.Id].Description, 'Existing account should be updated.');
		Assert.areEqual(existingAccount.Id, [SELECT AccountId FROM Contact WHERE Id = :contact1.Id].AccountId, 'Contact 1 should be linked to existing Account.');
		Assert.areEqual(newAccount.Id, [SELECT AccountId FROM Contact WHERE Id = :contact2.Id].AccountId, 'Contact 2 should be linked to new Account.');
	}

	// ================================================================================================
	// =========================================== MOCKING ============================================
	// ================================================================================================

	@IsTest
	static void complexHierarchyWithMocking() {
		// Setup - 3 level hierarchy with multiple branches
		Account parentAccount = new Account(Name = 'Parent');
		Account childAccount1 = new Account(Name = 'Child 1');
		Account childAccount2 = new Account(Name = 'Child 2');
		Contact contact1 = getContact(1);
		Contact contact2 = getContact(2);
		Opportunity opportunity1 = getOpportunity(1);

		DML.mock('dmlMockId').allInserts();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML()
			.identifier('dmlMockId')
			.toInsert(parentAccount)
			.toInsert(DML.Record(childAccount1).withRelationship(Account.ParentId, parentAccount))
			.toInsert(DML.Record(childAccount2).withRelationship(Account.ParentId, parentAccount))
			.toInsert(DML.Record(contact1).withRelationship(Contact.AccountId, childAccount1))
			.toInsert(DML.Record(contact2).withRelationship(Contact.AccountId, childAccount2))
			.toInsert(DML.Record(opportunity1).withRelationship(Opportunity.AccountId, parentAccount))
			.commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(3, result.inserts().size(), 'Inserted operation result should contain 3 object types (Account, Contact, Opportunity).');
		Assert.areEqual(3, result.insertsOf(Account.SObjectType).records().size(), 'Account result should contain 3 records.');
		Assert.areEqual(2, result.insertsOf(Contact.SObjectType).records().size(), 'Contact result should contain 2 records.');
		Assert.areEqual(1, result.insertsOf(Opportunity.SObjectType).records().size(), 'Opportunity result should contain 1 record.');
	}

	// ================================================ MOCKING - INSERT =================================================

	@IsTest
	static void toInsertSingleRecordWithMocking() {
		// Setup
		Account account1 = getAccount(1);

		DML.mock('dmlMockId').allInserts();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toInsert(account1).identifier('dmlMockId').commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(1, result.inserts().size(), 'Inserted operation result should contain 1 result.');
		Assert.areEqual(Account.SObjectType, result.insertsOf(Account.SObjectType).objectType(), 'Inserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, result.insertsOf(Account.SObjectType).operationType(), 'Inserted operation result should contain insert type.');
		Assert.areEqual(1, result.insertsOf(Account.SObjectType).records().size(), 'Inserted operation result should contain the inserted record.');
		Assert.areEqual(1, result.insertsOf(Account.SObjectType).recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.isTrue(result.insertsOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Inserted operation result should contain a successful record result.');
		Assert.isNotNull(result.insertsOf(Account.SObjectType).recordResults()[0].id(), 'Inserted operation result should contain a mocked record Id.');
		Assert.isNotNull(account1.Id, 'Account should have mocked Id.');
	}

	@IsTest
	static void toInsertSingleRecordWithMockingAndRelationship() {
		// Setup
		Account account1 = getAccount(1);
		Contact contact1 = getContact(1);

		DML.mock('dmlMockId').allInserts();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toInsert(account1).toInsert(DML.Record(contact1).withRelationship(Contact.AccountId, account1)).identifier('dmlMockId').commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(0, [SELECT COUNT() FROM Contact], 'No records should be inserted to the database.');
		Assert.areEqual(2, result.inserts().size(), 'Inserted operation result should contain 1 result.');

		DML.OperationResult accountResult = result.insertsOf(Account.SObjectType);

		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Inserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, accountResult.operationType(), 'Inserted operation result should contain insert type.');
		Assert.areEqual(1, accountResult.records().size(), 'Inserted operation result should contain the inserted record.');
		Assert.areEqual(1, accountResult.recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Inserted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Inserted operation result should contain a mocked record Id.');
		Assert.isNotNull(account1.Id, 'Account should have mocked Id.');

		DML.OperationResult contactResult = result.insertsOf(Contact.SObjectType);

		Assert.areEqual(Contact.SObjectType, contactResult.objectType(), 'Inserted operation result should contain Contact object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, contactResult.operationType(), 'Inserted operation result should contain insert type.');
		Assert.areEqual(1, contactResult.records().size(), 'Inserted operation result should contain the inserted record.');
		Assert.areEqual(1, contactResult.recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.isTrue(contactResult.recordResults()[0].isSuccess(), 'Inserted operation result should contain a successful record result.');
		Assert.isNotNull(contactResult.recordResults()[0].id(), 'Inserted operation result should contain a mocked record Id.');
		Assert.isNotNull(contact1.Id, 'Contact should have mocked Id.');
	}

	@IsTest
	static void toInsertMultipleRecordsWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		DML.mock('dmlMockId').allInserts();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toInsert(account1).toInsert(account2).identifier('dmlMockId').commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(1, result.inserts().size(), 'Inserted operation result should contain 1 result.');
		Assert.areEqual(Account.SObjectType, result.insertsOf(Account.SObjectType).objectType(), 'Inserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, result.insertsOf(Account.SObjectType).operationType(), 'Inserted operation result should contain insert type.');
		Assert.areEqual(2, result.insertsOf(Account.SObjectType).records().size(), 'Inserted operation result should contain the inserted records.');
		Assert.areEqual(2, result.insertsOf(Account.SObjectType).recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.isTrue(result.insertsOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Inserted operation result should contain a successful record result.');
		Assert.isTrue(result.insertsOf(Account.SObjectType).recordResults()[1].isSuccess(), 'Inserted operation result should contain a successful record result.');
		Assert.isNotNull(result.insertsOf(Account.SObjectType).recordResults()[0].id(), 'Inserted operation result should contain a mocked record Id.');
		Assert.isNotNull(result.insertsOf(Account.SObjectType).recordResults()[1].id(), 'Inserted operation result should contain a mocked record Id.');
		Assert.isNotNull(account1.Id, 'Account should have mocked Id.');
		Assert.isNotNull(account2.Id, 'Account 2 should have mocked Id.');
	}

	@IsTest
	static void toInsertMultipleRecordsWithMockingSpecificSObjectType() {
		// Setup
		Account account1 = getAccount(1);
		Contact contact1 = getContact(1);

		DML.mock('dmlMockId').insertsFor(Account.SObjectType);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toInsert(account1).toInsert(contact1).identifier('dmlMockId').commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed for contact which is not mocked.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Account should not be inserted, because it was mocked.');
		Assert.areEqual(1, [SELECT COUNT() FROM Contact], 'Contact should be inserted, because only Account was mocked.');
		Assert.areEqual(2, result.inserts().size(), 'Inserted operation result should contain 2 results.');
		Assert.areEqual(Account.SObjectType, result.insertsOf(Account.SObjectType).objectType(), 'Inserted operation result should contain Account object type.');
		Assert.areEqual(Contact.SObjectType, result.insertsOf(Contact.SObjectType).objectType(), 'Inserted operation result should contain Contact object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, result.insertsOf(Account.SObjectType).operationType(), 'Inserted operation result should contain insert type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, result.insertsOf(Contact.SObjectType).operationType(), 'Inserted operation result should contain insert type.');
		Assert.areEqual(1, result.insertsOf(Account.SObjectType).records().size(), 'Inserted operation result should contain the inserted record.');
		Assert.areEqual(1, result.insertsOf(Account.SObjectType).recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.areEqual(1, result.insertsOf(Contact.SObjectType).records().size(), 'Inserted operation result should contain the inserted record.');
		Assert.areEqual(1, result.insertsOf(Contact.SObjectType).recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.isTrue(result.insertsOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Inserted operation result should contain a successful record result.');
		Assert.isTrue(result.insertsOf(Contact.SObjectType).recordResults()[0].isSuccess(), 'Inserted operation result should contain a successful record result.');
		Assert.isNotNull(result.insertsOf(Account.SObjectType).recordResults()[0].id(), 'Inserted operation result should contain a mocked record Id.');
		Assert.isNotNull(result.insertsOf(Contact.SObjectType).recordResults()[0].id(), 'Inserted operation result should contain a mocked record Id.');
		Assert.isNotNull(account1.Id, 'Account should have mocked Id.');
		Assert.isNotNull(contact1.Id, 'Contact should have mocked Id.');
	}

	@IsTest
	static void toInsertMultipleRecordTypesWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Contact contact1 = getContact(1);

		DML.mock('dmlMockId').allInserts();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toInsert(account1).toInsert(contact1).identifier('dmlMockId').commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(0, [SELECT COUNT() FROM Contact], 'No records should be inserted to the database.');
		Assert.areEqual(2, result.inserts().size(), 'Inserted operation result should contain 2 results.');
		Assert.areEqual(Account.SObjectType, result.insertsOf(Account.SObjectType).objectType(), 'Inserted operation result should contain Account object type.');
		Assert.areEqual(Contact.SObjectType, result.insertsOf(Contact.SObjectType).objectType(), 'Inserted operation result should contain Contact object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, result.insertsOf(Account.SObjectType).operationType(), 'Inserted operation result should contain insert type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, result.insertsOf(Contact.SObjectType).operationType(), 'Inserted operation result should contain insert type.');
		Assert.areEqual(1, result.insertsOf(Account.SObjectType).records().size(), 'Inserted operation result should contain the inserted record.');
		Assert.areEqual(1, result.insertsOf(Account.SObjectType).recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.areEqual(1, result.insertsOf(Contact.SObjectType).records().size(), 'Inserted operation result should contain the inserted record.');
		Assert.areEqual(1, result.insertsOf(Contact.SObjectType).recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.isTrue(result.insertsOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Inserted operation result should contain a successful record result.');
		Assert.isTrue(result.insertsOf(Contact.SObjectType).recordResults()[0].isSuccess(), 'Inserted operation result should contain a successful record result.');
		Assert.isNotNull(result.insertsOf(Account.SObjectType).recordResults()[0].id(), 'Inserted operation result should contain a mocked record Id.');
		Assert.isNotNull(result.insertsOf(Contact.SObjectType).recordResults()[0].id(), 'Inserted operation result should contain a mocked record Id.');
		Assert.isNotNull(account1.Id, 'Account should have mocked Id.');
		Assert.isNotNull(contact1.Id, 'Contact should have mocked Id.');
	}

	@IsTest
	static void toInsertWithEmptyRecordWhenMocking() {
		// Setup
		DML.mock('dmlMockId').allInserts();

		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		new DML().toInsert(new List<Account>()).identifier('dmlMockId').commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(0, dmlStatementsAfter - dmlStatementsBefore, 'No DML statements should be executed.');

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.merges().size(), 'Merged operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');
	}

	@IsTest
	static void toInsertWithMockingException() {
		// Setup
		Account account1 = getAccount(1);

		DML.mock('dmlMockId').exceptionOnInserts();

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toInsert(account1).identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
	}

	@IsTest
	static void toInsertWithMockingExceptionWhenAllOrNoneIsSet() {
		// Setup
		Account account1 = getAccount(1);

		DML.mock('dmlMockId').exceptionOnInserts();

		Exception expectedException = null;
		DML.Result result = null;

		// Test
		Test.startTest();
		try {
			result = new DML().toInsert(account1).allowPartialSuccess().identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNull(expectedException, 'Expected exception to not be thrown.');

		DML.OperationResult operationResult = result.insertsOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Result should contain 1 record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Result should contain 1 record result.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Result should contain Account object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, operationResult.operationType(), 'Result should contain insert type.');
		Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Result should contain a failed record result.');
		Assert.isTrue(operationResult.hasFailures(), 'Result should have failures.');
	}

	@IsTest
	static void toInsertWithMockingExceptionForSpecificSObjectType() {
		// Setup
		Account account1 = getAccount(1);

		DML.mock('dmlMockId').exceptionOnInsertsFor(Account.SObjectType);

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toInsert(account1).identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
	}

	@IsTest
	static void toInsertWithMockingExceptionForSpecificSObjectTypeWhenAllOrNoneIsSet() {
		// Setup
		Account account1 = getAccount(1);

		DML.mock('dmlMockId').exceptionOnInsertsFor(Account.SObjectType);

		Exception expectedException = null;
		DML.Result result = null;

		// Test
		Test.startTest();
		try {
			result = new DML().toInsert(account1).allowPartialSuccess().identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNull(expectedException, 'Expected exception to not be thrown.');

		DML.OperationResult operationResult = result.insertsOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Result should contain 1 record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Result should contain 1 record result.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Result should contain Account object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, operationResult.operationType(), 'Result should contain insert type.');
		Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Result should contain a failed record result.');
		Assert.isTrue(operationResult.hasFailures(), 'Result should have failures.');
	}

	//  ================================================ MOCKING - UPDATE =================================================

	@IsTest
	static void toUpdateSingleRecordWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allUpdates();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		account1.Name = 'Updated Test Account';

		new DML().toUpdate(account1).identifier('dmlMockId').commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(1, result.updates().size(), 'Updated operation result should contain 1 result.');
		Assert.areEqual(Account.SObjectType, result.updatesOf(Account.SObjectType).objectType(), 'Updated operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, result.updatesOf(Account.SObjectType).operationType(), 'Updated operation result should contain update type.');
		Assert.areEqual(1, result.updatesOf(Account.SObjectType).records().size(), 'Updated operation result should contain the updated record.');
		Assert.areEqual(1, result.updatesOf(Account.SObjectType).recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.areEqual('Updated Test Account', account1.Name, 'Account should be updated.');
		Assert.isTrue(result.updatesOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Updated operation result should contain a successful record result.');
		Assert.isNotNull(result.updatesOf(Account.SObjectType).recordResults()[0].id(), 'Updated operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toUpdateMultipleRecordsWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);
		account2.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allUpdates();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		account1.Name = 'Updated Test Account 1';
		account2.Name = 'Updated Test Account 2';

		new DML().toUpdate(account1).toUpdate(account2).identifier('dmlMockId').commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(1, result.updates().size(), 'Updated operation result should contain 1 result.');
		Assert.areEqual(Account.SObjectType, result.updatesOf(Account.SObjectType).objectType(), 'Updated operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, result.updatesOf(Account.SObjectType).operationType(), 'Updated operation result should contain update type.');
		Assert.areEqual(2, result.updatesOf(Account.SObjectType).records().size(), 'Updated operation result should contain the updated records.');
		Assert.areEqual(2, result.updatesOf(Account.SObjectType).recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.isTrue(result.updatesOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Updated operation result should contain a successful record result.');
		Assert.isTrue(result.updatesOf(Account.SObjectType).recordResults()[1].isSuccess(), 'Updated operation result should contain a successful record result.');
		Assert.isNotNull(result.updatesOf(Account.SObjectType).recordResults()[0].id(), 'Updated operation result should contain a mocked record Id.');
		Assert.isNotNull(result.updatesOf(Account.SObjectType).recordResults()[1].id(), 'Updated operation result should contain a mocked record Id.');
		Assert.areEqual('Updated Test Account 1', account1.Name, 'Account 1 should be updated.');
		Assert.areEqual('Updated Test Account 2', account2.Name, 'Account 2 should be updated.');
	}

	@IsTest
	static void toUpdateMultipleRecordTypesWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Contact contact1 = getContact(1);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);
		contact1.Id = DML.randomIdGenerator.get(Contact.SObjectType);

		DML.mock('dmlMockId').allUpdates();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		account1.Name = 'Updated Test Account 1';
		contact1.FirstName = 'Updated Test Contact 1';

		new DML().toUpdate(account1).toUpdate(contact1).identifier('dmlMockId').commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(0, [SELECT COUNT() FROM Contact], 'No records should be inserted to the database.');
		Assert.areEqual(2, result.updates().size(), 'Updated operation result should contain 2 results.');
		Assert.areEqual(Account.SObjectType, result.updatesOf(Account.SObjectType).objectType(), 'Updated operation result should contain Account object type.');
		Assert.areEqual(Contact.SObjectType, result.updatesOf(Contact.SObjectType).objectType(), 'Updated operation result should contain Contact object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, result.updatesOf(Account.SObjectType).operationType(), 'Updated operation result should contain update type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, result.updatesOf(Contact.SObjectType).operationType(), 'Updated operation result should contain update type.');
		Assert.areEqual(1, result.updatesOf(Account.SObjectType).records().size(), 'Updated operation result should contain the updated record.');
		Assert.areEqual(1, result.updatesOf(Account.SObjectType).recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.areEqual(1, result.updatesOf(Contact.SObjectType).records().size(), 'Updated operation result should contain the updated record.');
		Assert.areEqual(1, result.updatesOf(Contact.SObjectType).recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.isTrue(result.updatesOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Updated operation result should contain a successful record result.');
		Assert.isTrue(result.updatesOf(Contact.SObjectType).recordResults()[0].isSuccess(), 'Updated operation result should contain a successful record result.');
		Assert.isNotNull(result.updatesOf(Account.SObjectType).recordResults()[0].id(), 'Updated operation result should contain a mocked record Id.');
		Assert.isNotNull(result.updatesOf(Contact.SObjectType).recordResults()[0].id(), 'Updated operation result should contain a mocked record Id.');
		Assert.areEqual('Updated Test Account 1', account1.Name, 'Account 1 should be updated.');
		Assert.areEqual('Updated Test Contact 1', contact1.FirstName, 'Contact 1 should be updated.');
	}

	@IsTest
	static void toUpdateMultipleRecordsWithMockingSpecificSObjectType() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;

		Contact contact1 = getContact(1);
		insert contact1;

		DML.mock('dmlMockId').updatesFor(Account.SObjectType);

		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		account1.Name = 'Updated Test Account 1';
		contact1.FirstName = 'Updated Test Contact 1';

		new DML().toUpdate(account1).toUpdate(contact1).identifier('dmlMockId').commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should not be updated in the database.');
		Assert.areEqual(1, [SELECT COUNT() FROM Contact], 'Contact should not be updated in the database.');
		Assert.areEqual(1, dmlStatementsAfter - dmlStatementsBefore, 'DML statements should be 1, because second commitWork() should not do anything.');
		Assert.areEqual(2, result.updates().size(), 'Updated operation result should contain 2 results.');
		Assert.areEqual(Account.SObjectType, result.updatesOf(Account.SObjectType).objectType(), 'Updated operation result should contain Account object type.');
		Assert.areEqual(Contact.SObjectType, result.updatesOf(Contact.SObjectType).objectType(), 'Updated operation result should contain Contact object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, result.updatesOf(Account.SObjectType).operationType(), 'Updated operation result should contain update type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, result.updatesOf(Contact.SObjectType).operationType(), 'Updated operation result should contain update type.');
		Assert.areEqual(1, result.updatesOf(Account.SObjectType).records().size(), 'Updated operation result should contain the updated record.');
		Assert.areEqual(1, result.updatesOf(Account.SObjectType).recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.areEqual(1, result.updatesOf(Contact.SObjectType).records().size(), 'Updated operation result should contain the updated record.');
		Assert.areEqual(1, result.updatesOf(Contact.SObjectType).recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.isTrue(result.updatesOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Updated operation result should contain a successful record result.');
		Assert.isTrue(result.updatesOf(Contact.SObjectType).recordResults()[0].isSuccess(), 'Updated operation result should contain a successful record result.');
		Assert.isNotNull(result.updatesOf(Account.SObjectType).recordResults()[0].id(), 'Updated operation result should contain a mocked record Id.');
		Assert.isNotNull(result.updatesOf(Contact.SObjectType).recordResults()[0].id(), 'Updated operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toUpdateWithMockingException() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').exceptionOnUpdates();

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toUpdate(account1).identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
	}

	@IsTest
	static void toUpdateWithMockingExceptionWhenAllOrNoneIsSet() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').exceptionOnUpdates();

		Exception expectedException = null;
		DML.Result result = null;

		// Test
		Test.startTest();
		try {
			result = new DML().toUpdate(account1).allowPartialSuccess().identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNull(expectedException, 'Expected exception to not be thrown.');

		DML.OperationResult operationResult = result.updatesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Result should contain 1 record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Result should contain 1 record result.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, operationResult.operationType(), 'Result should contain update type.');
		Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Result should contain a failed record result.');
		Assert.isTrue(operationResult.hasFailures(), 'Result should have failures.');
	}

	@IsTest
	static void toUpdateWithMockingExceptionForSpecificSObjectType() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').exceptionOnUpdatesFor(Account.SObjectType);

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toUpdate(account1).identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
	}

	@IsTest
	static void toUpdateWithMockingExceptionForSpecificSObjectTypeWhenAllOrNoneIsSet() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').exceptionOnUpdatesFor(Account.SObjectType);

		Exception expectedException = null;
		DML.Result result = null;

		// Test
		Test.startTest();
		try {
			result = new DML().toUpdate(account1).allowPartialSuccess().identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNull(expectedException, 'Expected exception to not be thrown.');

		DML.OperationResult operationResult = result.updatesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Result should contain 1 record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Result should contain 1 record result.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, operationResult.operationType(), 'Result should contain update type.');
		Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Result should contain a failed record result.');
		Assert.isTrue(operationResult.hasFailures(), 'Result should have failures.');
	}

	@IsTest
	static void toUpdateWithEmptyRecordsWhenMocking() {
		// Setup
		DML.mock('dmlMockId').allUpdates();

		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		new DML().toUpdate(new List<Account>()).identifier('dmlMockId').commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be updated in the database.');
		Assert.areEqual(0, dmlStatementsAfter - dmlStatementsBefore, 'No DML statements should be executed.');

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 1 result.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.merges().size(), 'Merged operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');
	}

	//  ================================================ MOCKING - UPSERT =================================================

	@IsTest
	static void toUpsertSingleRecordWhenIdIsNotSpecifiedWithMocking() {
		// Setup
		Account account1 = getAccount(1);

		DML.mock('dmlMockId').allUpserts();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		account1.Name = 'Upserted Test Account';

		new DML().toUpsert(account1).identifier('dmlMockId').commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(1, result.upserts().size(), 'Upserted operation result should contain 1 result.');
		Assert.areEqual(Account.SObjectType, result.upsertsOf(Account.SObjectType).objectType(), 'Upserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPSERT_DML, result.upsertsOf(Account.SObjectType).operationType(), 'Upserted operation result should contain upsert type.');
		Assert.areEqual(1, result.upsertsOf(Account.SObjectType).records().size(), 'Upserted operation result should contain the upserted records.');
		Assert.areEqual(1, result.upsertsOf(Account.SObjectType).recordResults().size(), 'Upserted operation result should contain the upserted record results.');
		Assert.areEqual('Upserted Test Account', account1.Name, 'Account should be upserted.');
		Assert.isTrue(result.upsertsOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Upserted operation result should contain a successful record result.');
		Assert.isNotNull(result.upsertsOf(Account.SObjectType).recordResults()[0].id(), 'Upserted operation result should contain a mocked record Id.');
		Assert.isNotNull(account1.Id, 'Account should have mocked Id.');
	}

	@IsTest
	static void toUpsertSingleRecordWhenIdIsSpecifiedWithMocking() {
		// Setup
		Account account1 = getAccount(1);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allUpserts();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		account1.Name = 'Upserted Test Account';

		new DML().toUpsert(account1).identifier('dmlMockId').commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(1, result.upserts().size(), 'Upserted operation result should contain 1 result.');
		Assert.areEqual(Account.SObjectType, result.upsertsOf(Account.SObjectType).objectType(), 'Upserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPSERT_DML, result.upsertsOf(Account.SObjectType).operationType(), 'Upserted operation result should contain upsert type.');
		Assert.areEqual(1, result.upsertsOf(Account.SObjectType).records().size(), 'Upserted operation result should contain the upserted records.');
		Assert.areEqual(1, result.upsertsOf(Account.SObjectType).recordResults().size(), 'Upserted operation result should contain the upserted record results.');
		Assert.areEqual('Upserted Test Account', account1.Name, 'Account should be upserted.');
		Assert.isTrue(result.upsertsOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Upserted operation result should contain a successful record result.');
		Assert.isNotNull(result.upsertsOf(Account.SObjectType).recordResults()[0].id(), 'Upserted operation result should contain a mocked record Id.');
		Assert.isNotNull(account1.Id, 'Account should have mocked Id.');
	}

	@IsTest
	static void toUpsertMultipleRecordsWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		DML.mock('dmlMockId').allUpserts();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		account1.Name = 'Upserted Test Account 1';
		account2.Name = 'Upserted Test Account 2';

		new DML().toUpsert(account1).toUpsert(account2).identifier('dmlMockId').commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(1, result.upserts().size(), 'Upserted operation result should contain 1 result.');
		Assert.areEqual(Account.SObjectType, result.upsertsOf(Account.SObjectType).objectType(), 'Upserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPSERT_DML, result.upsertsOf(Account.SObjectType).operationType(), 'Upserted operation result should contain upsert type.');
		Assert.areEqual(2, result.upsertsOf(Account.SObjectType).records().size(), 'Upserted operation result should contain the upserted records.');
		Assert.areEqual(2, result.upsertsOf(Account.SObjectType).recordResults().size(), 'Upserted operation result should contain the upserted record results.');
		Assert.isTrue(result.upsertsOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Upserted operation result should contain a successful record result.');
		Assert.isTrue(result.upsertsOf(Account.SObjectType).recordResults()[1].isSuccess(), 'Upserted operation result should contain a successful record result.');
		Assert.isNotNull(result.upsertsOf(Account.SObjectType).recordResults()[0].id(), 'Upserted operation result should contain a mocked record Id.');
		Assert.isNotNull(result.upsertsOf(Account.SObjectType).recordResults()[1].id(), 'Upserted operation result should contain a mocked record Id.');
		Assert.areEqual('Upserted Test Account 1', account1.Name, 'Account 1 should be upserted.');
		Assert.areEqual('Upserted Test Account 2', account2.Name, 'Account 2 should be upserted.');
	}

	@IsTest
	static void toUpsertMultipleRecordTypesWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Contact contact1 = getContact(1);

		DML.mock('dmlMockId').allUpserts();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		account1.Name = 'Upserted Test Account 1';
		contact1.FirstName = 'Upserted Test Contact 1';

		new DML().toUpsert(account1).toUpsert(contact1).identifier('dmlMockId').commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(0, [SELECT COUNT() FROM Contact], 'No records should be inserted to the database.');
		Assert.areEqual(2, result.upserts().size(), 'Upserted operation result should contain 2 results.');
		Assert.areEqual(Account.SObjectType, result.upsertsOf(Account.SObjectType).objectType(), 'Upserted operation result should contain Account object type.');
		Assert.areEqual(Contact.SObjectType, result.upsertsOf(Contact.SObjectType).objectType(), 'Upserted operation result should contain Contact object type.');
		Assert.areEqual(DML.OperationType.UPSERT_DML, result.upsertsOf(Account.SObjectType).operationType(), 'Upserted operation result should contain upsert type.');
		Assert.areEqual(DML.OperationType.UPSERT_DML, result.upsertsOf(Contact.SObjectType).operationType(), 'Upserted operation result should contain upsert type.');
		Assert.areEqual(1, result.upsertsOf(Account.SObjectType).records().size(), 'Upserted operation result should contain the upserted record.');
		Assert.areEqual(1, result.upsertsOf(Account.SObjectType).recordResults().size(), 'Upserted operation result should contain the upserted record results.');
		Assert.areEqual(1, result.upsertsOf(Contact.SObjectType).records().size(), 'Upserted operation result should contain the upserted record.');
		Assert.areEqual(1, result.upsertsOf(Contact.SObjectType).recordResults().size(), 'Upserted operation result should contain the upserted record results.');
		Assert.isTrue(result.upsertsOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Upserted operation result should contain a successful record result.');
		Assert.isTrue(result.upsertsOf(Contact.SObjectType).recordResults()[0].isSuccess(), 'Upserted operation result should contain a successful record result.');
		Assert.isNotNull(result.upsertsOf(Account.SObjectType).recordResults()[0].id(), 'Upserted operation result should contain a mocked record Id.');
		Assert.isNotNull(result.upsertsOf(Contact.SObjectType).recordResults()[0].id(), 'Upserted operation result should contain a mocked record Id.');
		Assert.areEqual('Upserted Test Account 1', account1.Name, 'Account 1 should be updated.');
		Assert.areEqual('Upserted Test Contact 1', contact1.FirstName, 'Contact 1 should be updated.');
	}

	@IsTest
	static void toUpsertMultipleRecordsWithMockingSpecificSObjectType() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;

		Contact contact1 = getContact(1);

		DML.mock('dmlMockId').upsertsFor(Contact.SObjectType);

		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		account1.Name = 'Upserted Test Account 1';
		contact1.FirstName = 'Upserted Test Contact 1';

		new DML().toUpsert(account1).toUpsert(contact1).identifier('dmlMockId').commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should not be updated in the database.');
		Assert.areEqual(0, [SELECT COUNT() FROM Contact], 'Contact should be upserted in the database.');
		Assert.areEqual(1, dmlStatementsAfter - dmlStatementsBefore, 'DML statements should be 1, because second commitWork() should not do anything.');
		Assert.areEqual(2, result.upserts().size(), 'Upserted operation result should contain 2 results.');
		Assert.areEqual(Account.SObjectType, result.upsertsOf(Account.SObjectType).objectType(), 'Upserted operation result should contain Account object type.');
		Assert.areEqual(Contact.SObjectType, result.upsertsOf(Contact.SObjectType).objectType(), 'Upserted operation result should contain Contact object type.');
		Assert.areEqual(DML.OperationType.UPSERT_DML, result.upsertsOf(Account.SObjectType).operationType(), 'Upserted operation result should contain upsert type.');
		Assert.areEqual(DML.OperationType.UPSERT_DML, result.upsertsOf(Contact.SObjectType).operationType(), 'Upserted operation result should contain upsert type.');
		Assert.areEqual(1, result.upsertsOf(Account.SObjectType).records().size(), 'Upserted operation result should contain the upserted record.');
		Assert.areEqual(1, result.upsertsOf(Account.SObjectType).recordResults().size(), 'Upserted operation result should contain the upserted record results.');
		Assert.areEqual(1, result.upsertsOf(Contact.SObjectType).records().size(), 'Upserted operation result should contain the upserted record.');
		Assert.areEqual(1, result.upsertsOf(Contact.SObjectType).recordResults().size(), 'Upserted operation result should contain the upserted record results.');
		Assert.isTrue(result.upsertsOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Upserted operation result should contain a successful record result.');
		Assert.isTrue(result.upsertsOf(Contact.SObjectType).recordResults()[0].isSuccess(), 'Upserted operation result should contain a successful record result.');
		Assert.isNotNull(result.upsertsOf(Account.SObjectType).recordResults()[0].id(), 'Upserted operation result should contain a mocked record Id.');
		Assert.isNotNull(result.upsertsOf(Contact.SObjectType).recordResults()[0].id(), 'Upserted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toUpsertWithMockingException() {
		// Setup
		Account account1 = getAccount(1);

		DML.mock('dmlMockId').exceptionOnUpserts();

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toUpsert(account1).identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
	}

	@IsTest
	static void toUpsertWithMockingExceptionWhenAllOrNoneIsSet() {
		// Setup
		Account account1 = getAccount(1);

		DML.mock('dmlMockId').exceptionOnUpserts();

		Exception expectedException = null;
		DML.Result result = null;

		// Test
		Test.startTest();
		try {
			result = new DML().toUpsert(account1).allowPartialSuccess().identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNull(expectedException, 'Expected exception to not be thrown.');

		DML.OperationResult operationResult = result.upsertsOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Result should contain 1 record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Result should contain 1 record result.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPSERT_DML, operationResult.operationType(), 'Result should contain upsert type.');
		Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Result should contain a failed record result.');
		Assert.isTrue(operationResult.hasFailures(), 'Result should have failures.');
	}

	@IsTest
	static void toUpsertWithMockingExceptionForSpecificSObjectType() {
		// Setup
		Account account1 = getAccount(1);

		DML.mock('dmlMockId').exceptionOnUpsertsFor(Account.SObjectType);

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toUpsert(account1).identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
	}

	@IsTest
	static void toUpsertWithMockingExceptionForSpecificSObjectTypeWhenAllOrNoneIsSet() {
		// Setup
		Account account1 = getAccount(1);

		DML.mock('dmlMockId').exceptionOnUpsertsFor(Account.SObjectType);

		Exception expectedException = null;
		DML.Result result = null;

		// Test
		Test.startTest();
		try {
			result = new DML().toUpsert(account1).allowPartialSuccess().identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNull(expectedException, 'Expected exception to not be thrown.');

		DML.OperationResult operationResult = result.upsertsOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Result should contain 1 record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Result should contain 1 record result.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPSERT_DML, operationResult.operationType(), 'Result should contain upsert type.');
		Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Result should contain a failed record result.');
		Assert.isTrue(operationResult.hasFailures(), 'Result should have failures.');
	}

	@IsTest
	static void toUpsertWithEmptyRecordsWhenMocking() {
		// Setup
		DML.mock('dmlMockId').allUpserts();

		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		new DML().toUpsert(new List<Account>()).identifier('dmlMockId').commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be upserted in the database.');
		Assert.areEqual(0, dmlStatementsAfter - dmlStatementsBefore, 'No DML statements should be executed.');

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.merges().size(), 'Merged operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');
	}

	//  ================================================ MOCKING - DELETE =================================================

	@IsTest
	static void toDeleteSingleRecordWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allDeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toDelete(account1).identifier('dmlMockId').commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(1, result.deletes().size(), 'Deleted operation result should contain 1 result.');
		Assert.areEqual(Account.SObjectType, result.deletesOf(Account.SObjectType).objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, result.deletesOf(Account.SObjectType).operationType(), 'Deleted operation result should contain delete type.');
		Assert.areEqual(1, result.deletesOf(Account.SObjectType).records().size(), 'Deleted operation result should contain the deleted record.');
		Assert.areEqual(1, result.deletesOf(Account.SObjectType).recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.isTrue(result.deletesOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isNotNull(result.deletesOf(Account.SObjectType).recordResults()[0].id(), 'Deleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toDeleteSingleRecordByIdWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allDeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').toDelete(account1.Id).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be deleted from the database.');
		Assert.isNotNull(account1.Id, 'Account should have mocked Id.');

		DML.OperationResult accountResult = result.deletesOf(Account.SObjectType);

		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, accountResult.operationType(), 'Deleted operation result should contain delete type.');
		Assert.areEqual(1, accountResult.records().size(), 'Deleted operation result should contain the deleted record.');
		Assert.areEqual(1, accountResult.recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Deleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toDeleteMultipleRecordsWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);
		account2.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allDeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toDelete(account1).toDelete(account2).identifier('dmlMockId').commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(1, result.deletes().size(), 'Deleted operation result should contain 1 result.');
		Assert.areEqual(Account.SObjectType, result.deletesOf(Account.SObjectType).objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, result.deletesOf(Account.SObjectType).operationType(), 'Deleted operation result should contain delete type.');
		Assert.areEqual(2, result.deletesOf(Account.SObjectType).records().size(), 'Deleted operation result should contain the deleted records.');
		Assert.areEqual(2, result.deletesOf(Account.SObjectType).recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.isTrue(result.deletesOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isTrue(result.deletesOf(Account.SObjectType).recordResults()[1].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isNotNull(result.deletesOf(Account.SObjectType).recordResults()[0].id(), 'Deleted operation result should contain a mocked record Id.');
		Assert.isNotNull(result.deletesOf(Account.SObjectType).recordResults()[1].id(), 'Deleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toDeleteMultipleRecordsByIdsWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);
		account2.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allDeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').toDelete(new List<Id>{ account1.Id, account2.Id }).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be deleted from the database.');
		Assert.areEqual(1, result.deletes().size(), 'Deleted operation result should contain 1 result.');
		Assert.isNotNull(account1.Id, 'Account 1 should have mocked Id.');
		Assert.isNotNull(account2.Id, 'Account 2 should have mocked Id.');

		DML.OperationResult accountResult = result.deletesOf(Account.SObjectType);

		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, accountResult.operationType(), 'Deleted operation result should contain delete type.');
		Assert.areEqual(2, accountResult.records().size(), 'Deleted operation result should contain the deleted records.');
		Assert.areEqual(2, accountResult.recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isTrue(accountResult.recordResults()[1].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Deleted operation result should contain a mocked record Id.');
		Assert.isNotNull(accountResult.recordResults()[1].id(), 'Deleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toDeleteWithEmptyRecordsWhenMocking() {
		// Setup
		DML.mock('dmlMockId').allDeletes();

		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		new DML().toDelete(new List<Account>()).identifier('dmlMockId').commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be deleted from the database.');
		Assert.areEqual(0, dmlStatementsAfter - dmlStatementsBefore, 'No DML statements should be executed.');

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 1 result.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.merges().size(), 'Merged operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');
	}

	@IsTest
	static void toDeleteMultipleRecordTypesWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Contact contact1 = getContact(1);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);
		contact1.Id = DML.randomIdGenerator.get(Contact.SObjectType);

		DML.mock('dmlMockId').allDeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toDelete(account1).toDelete(contact1).identifier('dmlMockId').commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No Account records should exist, because delete was mocked.');
		Assert.areEqual(0, [SELECT COUNT() FROM Contact], 'No Contact records should exist, because delete was mocked.');
		Assert.areEqual(2, result.deletes().size(), 'Deleted operation result should contain 2 results.');
		Assert.areEqual(Account.SObjectType, result.deletesOf(Account.SObjectType).objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(Contact.SObjectType, result.deletesOf(Contact.SObjectType).objectType(), 'Deleted operation result should contain Contact object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, result.deletesOf(Account.SObjectType).operationType(), 'Deleted operation result should contain delete type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, result.deletesOf(Contact.SObjectType).operationType(), 'Deleted operation result should contain delete type.');
		Assert.areEqual(1, result.deletesOf(Account.SObjectType).records().size(), 'Deleted operation result should contain the deleted record.');
		Assert.areEqual(1, result.deletesOf(Account.SObjectType).recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.areEqual(1, result.deletesOf(Contact.SObjectType).records().size(), 'Deleted operation result should contain the deleted record.');
		Assert.areEqual(1, result.deletesOf(Contact.SObjectType).recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.isTrue(result.deletesOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isTrue(result.deletesOf(Contact.SObjectType).recordResults()[0].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isNotNull(result.deletesOf(Account.SObjectType).recordResults()[0].id(), 'Deleted operation result should contain a mocked record Id.');
		Assert.isNotNull(result.deletesOf(Contact.SObjectType).recordResults()[0].id(), 'Deleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toDeleteMultipleRecordsWithMockingSpecificSObjectType() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;

		Contact contact1 = getContact(1);
		insert contact1;

		DML.mock('dmlMockId').deletesFor(Account.SObjectType);

		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		new DML().toDelete(account1).toDelete(contact1).identifier('dmlMockId').commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should not be deleted from the database.');
		Assert.areEqual(0, [SELECT COUNT() FROM Contact], 'Contact should be deleted from the database.');
		Assert.areEqual(1, dmlStatementsAfter - dmlStatementsBefore, 'DML statements should be 1, because second commitWork() should not do anything.');
		Assert.areEqual(2, result.deletes().size(), 'Deleted operation result should contain 2 results.');
		Assert.areEqual(Account.SObjectType, result.deletesOf(Account.SObjectType).objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(Contact.SObjectType, result.deletesOf(Contact.SObjectType).objectType(), 'Deleted operation result should contain Contact object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, result.deletesOf(Account.SObjectType).operationType(), 'Deleted operation result should contain delete type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, result.deletesOf(Contact.SObjectType).operationType(), 'Deleted operation result should contain delete type.');
		Assert.areEqual(1, result.deletesOf(Account.SObjectType).records().size(), 'Deleted operation result should contain the deleted record.');
		Assert.areEqual(1, result.deletesOf(Account.SObjectType).recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.areEqual(1, result.deletesOf(Contact.SObjectType).records().size(), 'Deleted operation result should contain the deleted record.');
		Assert.areEqual(1, result.deletesOf(Contact.SObjectType).recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.isTrue(result.deletesOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isTrue(result.deletesOf(Contact.SObjectType).recordResults()[0].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isNotNull(result.deletesOf(Account.SObjectType).recordResults()[0].id(), 'Deleted operation result should contain a mocked record Id.');
		Assert.isNotNull(result.deletesOf(Contact.SObjectType).recordResults()[0].id(), 'Deleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toDeleteWithMockingException() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').exceptionOnDeletes();

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toDelete(account1).identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
	}

	@IsTest
	static void toDeleteWithMockingExceptionWhenAllOrNoneIsSet() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').exceptionOnDeletes();

		Exception expectedException = null;
		DML.Result result = null;

		// Test
		Test.startTest();
		try {
			result = new DML().toDelete(account1).allowPartialSuccess().identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNull(expectedException, 'Expected exception to not be thrown.');

		DML.OperationResult operationResult = result.deletesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Result should contain 1 record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Result should contain 1 record result.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, operationResult.operationType(), 'Result should contain delete type.');
		Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Result should contain a failed record result.');
		Assert.isTrue(operationResult.hasFailures(), 'Result should have failures.');
	}

	@IsTest
	static void toDeleteWithMockingExceptionForSpecificSObjectType() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').exceptionOnDeletesFor(Account.SObjectType);

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toDelete(account1).identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
	}

	@IsTest
	static void toDeleteWithMockingExceptionForSpecificSObjectTypeWhenAllOrNoneIsSet() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').exceptionOnDeletesFor(Account.SObjectType);

		Exception expectedException = null;
		DML.Result result = null;

		// Test
		Test.startTest();
		try {
			result = new DML().toDelete(account1).allowPartialSuccess().identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNull(expectedException, 'Expected exception to not be thrown.');

		DML.OperationResult operationResult = result.deletesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Result should contain 1 record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Result should contain 1 record result.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, operationResult.operationType(), 'Result should contain delete type.');
		Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Result should contain a failed record result.');
		Assert.isTrue(operationResult.hasFailures(), 'Result should have failures.');
	}

	//  ================================================ MOCKING - HARD DELETE =================================================

	@IsTest
	static void toHardDeleteSingleRecordWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allDeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toHardDelete(account1).identifier('dmlMockId').commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be hard deleted from the database.');
		Assert.areEqual(1, result.deletes().size(), 'Deleted operation result should contain 1 result.');
		Assert.areEqual(Account.SObjectType, result.deletesOf(Account.SObjectType).objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, result.deletesOf(Account.SObjectType).operationType(), 'Deleted operation result should contain delete type.');
		Assert.areEqual(1, result.deletesOf(Account.SObjectType).records().size(), 'Deleted operation result should contain the deleted record.');
		Assert.areEqual(1, result.deletesOf(Account.SObjectType).recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.isTrue(result.deletesOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isNotNull(result.deletesOf(Account.SObjectType).recordResults()[0].id(), 'Deleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toHardDeleteMultipleRecordsWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);
		account2.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allDeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toHardDelete(account1).toHardDelete(account2).identifier('dmlMockId').commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be hard deleted from the database.');
		Assert.areEqual(1, result.deletes().size(), 'Deleted operation result should contain 1 result.');
		Assert.areEqual(Account.SObjectType, result.deletesOf(Account.SObjectType).objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, result.deletesOf(Account.SObjectType).operationType(), 'Deleted operation result should contain delete type.');
		Assert.areEqual(2, result.deletesOf(Account.SObjectType).records().size(), 'Deleted operation result should contain the deleted records.');
		Assert.areEqual(2, result.deletesOf(Account.SObjectType).recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.isTrue(result.deletesOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isTrue(result.deletesOf(Account.SObjectType).recordResults()[1].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isNotNull(result.deletesOf(Account.SObjectType).recordResults()[0].id(), 'Deleted operation result should contain a mocked record Id.');
		Assert.isNotNull(result.deletesOf(Account.SObjectType).recordResults()[1].id(), 'Deleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toHardDeleteByIdWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allDeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').toHardDelete(account1.Id).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be hard deleted from the database.');
		Assert.isNotNull(account1.Id, 'Account should have mocked Id.');

		DML.OperationResult accountResult = result.deletesOf(Account.SObjectType);

		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, accountResult.operationType(), 'Deleted operation result should contain delete type.');
		Assert.areEqual(1, accountResult.records().size(), 'Deleted operation result should contain the deleted record.');
		Assert.areEqual(1, accountResult.recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Deleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toHardDeleteByIdsWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);
		account2.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allDeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').toHardDelete(new Set<Id>{ account1.Id, account2.Id }).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be hard deleted from the database.');
		Assert.isNotNull(account1.Id, 'Account 1 should have mocked Id.');
		Assert.isNotNull(account2.Id, 'Account 2 should have mocked Id.');

		DML.OperationResult accountResult = result.deletesOf(Account.SObjectType);

		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, accountResult.operationType(), 'Deleted operation result should contain delete type.');
		Assert.areEqual(2, accountResult.records().size(), 'Deleted operation result should contain the deleted records.');
		Assert.areEqual(2, accountResult.recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isTrue(accountResult.recordResults()[1].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Deleted operation result should contain a mocked record Id.');
		Assert.isNotNull(accountResult.recordResults()[1].id(), 'Deleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toHardDeleteWithMockingException() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').exceptionOnDeletes();

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toHardDelete(account1).identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
	}

	@IsTest
	static void toHardDeleteWithMockingExceptionForSpecificSObjectType() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').exceptionOnDeletesFor(Account.SObjectType);

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toHardDelete(account1).identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
	}

	@IsTest
	static void toHardDeleteWithEmptyRecordsWhenMocking() {
		// Setup
		DML.mock('dmlMockId').allDeletes();

		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		new DML().toHardDelete(new List<Account>()).identifier('dmlMockId').commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be deleted from the database.');
		Assert.areEqual(0, dmlStatementsAfter - dmlStatementsBefore, 'No DML statements should be executed.');

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.merges().size(), 'Merged operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');
	}

	//  ================================================ MOCKING - UNDELETE =================================================

	@IsTest
	static void toUndeleteSingleRecordWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allUndeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		new DML().toUndelete(account1).identifier('dmlMockId').commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(1, result.undeletes().size(), 'Undeleted operation result should contain 1 result.');
		Assert.areEqual(Account.SObjectType, result.deletesOf(Account.SObjectType).objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, result.undeletesOf(Account.SObjectType).operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.areEqual(1, result.undeletesOf(Account.SObjectType).records().size(), 'Undeleted operation result should contain the undeleted record.');
		Assert.areEqual(1, result.undeletesOf(Account.SObjectType).recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.isTrue(result.undeletesOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Undeleted operation result should contain a successful record result.');
		Assert.isNotNull(result.undeletesOf(Account.SObjectType).recordResults()[0].id(), 'Undeleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toUndeleteMultipleRecordsWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);
		account2.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allUndeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		new DML().toUndelete(account1).toUndelete(account2).identifier('dmlMockId').commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(1, result.undeletes().size(), 'Undeleted operation result should contain 1 result.');
		Assert.areEqual(Account.SObjectType, result.undeletesOf(Account.SObjectType).objectType(), 'Undeleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, result.undeletesOf(Account.SObjectType).operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.areEqual(2, result.undeletesOf(Account.SObjectType).records().size(), 'Undeleted operation result should contain the undeleted records.');
		Assert.areEqual(2, result.undeletesOf(Account.SObjectType).recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.isTrue(result.undeletesOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Undeleted operation result should contain a successful record result.');
		Assert.isTrue(result.undeletesOf(Account.SObjectType).recordResults()[1].isSuccess(), 'Undeleted operation result should contain a successful record result.');
		Assert.isNotNull(result.undeletesOf(Account.SObjectType).recordResults()[0].id(), 'Undeleted operation result should contain a mocked record Id.');
		Assert.isNotNull(result.undeletesOf(Account.SObjectType).recordResults()[1].id(), 'Undeleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toUndeleteByIdWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allUndeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').toUndelete(account1.Id).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be undeleted in the database.');
		Assert.isNotNull(account1.Id, 'Account should have mocked Id.');

		DML.OperationResult accountResult = result.undeletesOf(Account.SObjectType);

		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Undeleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, accountResult.operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.areEqual(1, accountResult.records().size(), 'Undeleted operation result should contain the undeleted record.');
		Assert.areEqual(1, accountResult.recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Undeleted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Undeleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toUndeleteByIdsWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);
		account2.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allUndeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').toUndelete(new List<Id>{ account1.Id, account2.Id }).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be undeleted in the database.');
		Assert.isNotNull(account1.Id, 'Account 1 should have mocked Id.');
		Assert.isNotNull(account2.Id, 'Account 2 should have mocked Id.');

		DML.OperationResult accountResult = result.undeletesOf(Account.SObjectType);

		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Undeleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, accountResult.operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.areEqual(2, accountResult.records().size(), 'Undeleted operation result should contain the undeleted records.');
		Assert.areEqual(2, accountResult.recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Undeleted operation result should contain a successful record result.');
		Assert.isTrue(accountResult.recordResults()[1].isSuccess(), 'Undeleted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Undeleted operation result should contain a mocked record Id.');
		Assert.isNotNull(accountResult.recordResults()[1].id(), 'Undeleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toUndeleteMultipleRecordTypesWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Contact contact1 = getContact(1);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);
		contact1.Id = DML.randomIdGenerator.get(Contact.SObjectType);

		DML.mock('dmlMockId').allUndeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		new DML().toUndelete(account1).toUndelete(contact1).identifier('dmlMockId').commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No Account records should exist, because undelete was mocked.');
		Assert.areEqual(0, [SELECT COUNT() FROM Contact], 'No Contact records should exist, because undelete was mocked.');
		Assert.areEqual(2, result.undeletes().size(), 'Undeleted operation result should contain 2 results.');
		Assert.areEqual(Account.SObjectType, result.undeletesOf(Account.SObjectType).objectType(), 'Undeleted operation result should contain Account object type.');
		Assert.areEqual(Contact.SObjectType, result.undeletesOf(Contact.SObjectType).objectType(), 'Undeleted operation result should contain Contact object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, result.undeletesOf(Account.SObjectType).operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, result.undeletesOf(Contact.SObjectType).operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.areEqual(1, result.undeletesOf(Account.SObjectType).records().size(), 'Undeleted operation result should contain the undeleted record.');
		Assert.areEqual(1, result.undeletesOf(Account.SObjectType).recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.areEqual(1, result.undeletesOf(Contact.SObjectType).records().size(), 'Undeleted operation result should contain the undeleted record.');
		Assert.areEqual(1, result.undeletesOf(Contact.SObjectType).recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.isTrue(result.undeletesOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Undeleted operation result should contain a successful record result.');
		Assert.isTrue(result.undeletesOf(Contact.SObjectType).recordResults()[0].isSuccess(), 'Undeleted operation result should contain a successful record result.');
		Assert.isNotNull(result.undeletesOf(Account.SObjectType).recordResults()[0].id(), 'Undeleted operation result should contain a mocked record Id.');
		Assert.isNotNull(result.undeletesOf(Contact.SObjectType).recordResults()[0].id(), 'Undeleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toUndeleteMultipleRecordsWithMockingSpecificSObjectType() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;
		delete account1;

		Contact contact1 = getContact(1);
		insert contact1;
		delete contact1;

		DML.mock('dmlMockId').undeletesFor(Account.SObjectType);

		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		new DML().toUndelete(account1).toUndelete(contact1).identifier('dmlMockId').commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Account should not be undeleted in the database.');
		Assert.areEqual(1, [SELECT COUNT() FROM Contact], 'Contact should be undeleted in the database.');
		Assert.areEqual(1, dmlStatementsAfter - dmlStatementsBefore, 'DML statements should be 1, because second commitWork() should not do anything.');
		Assert.areEqual(2, result.undeletes().size(), 'Undeleted operation result should contain 2 results.');
		Assert.areEqual(Account.SObjectType, result.undeletesOf(Account.SObjectType).objectType(), 'Undeleted operation result should contain Account object type.');
		Assert.areEqual(Contact.SObjectType, result.undeletesOf(Contact.SObjectType).objectType(), 'Undeleted operation result should contain Contact object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, result.undeletesOf(Account.SObjectType).operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, result.undeletesOf(Contact.SObjectType).operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.areEqual(1, result.undeletesOf(Account.SObjectType).records().size(), 'Undeleted operation result should contain the undeleted record.');
		Assert.areEqual(1, result.undeletesOf(Account.SObjectType).recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.areEqual(1, result.undeletesOf(Contact.SObjectType).records().size(), 'Undeleted operation result should contain the undeleted record.');
		Assert.areEqual(1, result.undeletesOf(Contact.SObjectType).recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.isTrue(result.undeletesOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Undeleted operation result should contain a successful record result.');
		Assert.isTrue(result.undeletesOf(Contact.SObjectType).recordResults()[0].isSuccess(), 'Undeleted operation result should contain a successful record result.');
		Assert.isNotNull(result.undeletesOf(Account.SObjectType).recordResults()[0].id(), 'Undeleted operation result should contain a mocked record Id.');
		Assert.isNotNull(result.undeletesOf(Contact.SObjectType).recordResults()[0].id(), 'Undeleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toUndeleteWithMockingException() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').exceptionOnUndeletes();

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toUndelete(account1).identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
	}

	@IsTest
	static void toUndeleteWithMockingExceptionWhenAllOrNoneIsSet() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').exceptionOnUndeletes();

		Exception expectedException = null;
		DML.Result result = null;

		// Test
		Test.startTest();
		try {
			result = new DML().toUndelete(account1).allowPartialSuccess().identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNull(expectedException, 'Expected exception to not be thrown.');

		DML.OperationResult operationResult = result.undeletesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Result should contain 1 record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Result should contain 1 record result.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, operationResult.operationType(), 'Result should contain undelete type.');
		Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Result should contain a failed record result.');
		Assert.isTrue(operationResult.hasFailures(), 'Result should have failures.');
	}

	@IsTest
	static void toUndeleteWithMockingExceptionForSpecificSObjectType() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').exceptionOnUndeletesFor(Account.SObjectType);

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toUndelete(account1).identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
	}

	@IsTest
	static void toUndeleteWithMockingExceptionForSpecificSObjectTypeWhenAllOrNoneIsSet() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').exceptionOnUndeletesFor(Account.SObjectType);

		Exception expectedException = null;
		DML.Result result = null;

		// Test
		Test.startTest();
		try {
			result = new DML().toUndelete(account1).allowPartialSuccess().identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNull(expectedException, 'Expected exception to not be thrown.');

		DML.OperationResult operationResult = result.undeletesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Result should contain 1 record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Result should contain 1 record result.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, operationResult.operationType(), 'Result should contain undelete type.');
		Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Result should contain a failed record result.');
		Assert.isTrue(operationResult.hasFailures(), 'Result should have failures.');
	}

	@IsTest
	static void toUndeleteWithEmptyRecordsWhenMocking() {
		// Setup
		DML.mock('dmlMockId').allUndeletes();

		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		new DML().toUndelete(new List<Account>()).identifier('dmlMockId').commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be undeleted in the database.');
		Assert.areEqual(0, dmlStatementsAfter - dmlStatementsBefore, 'No DML statements should be executed.');

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.merges().size(), 'Merged operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 0 results.');
	}

	//  ================================================ MOCKING - MERGE =================================================

	@IsTest
	static void toMergeSingleRecordWithMocking() {
		// Setup
		Account masterAccount = getAccount(1);
		Account duplicateAccount = getAccount(2);

		masterAccount.Id = DML.randomIdGenerator.get(Account.SObjectType);
		duplicateAccount.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allMerges();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		new DML().toMerge(masterAccount, duplicateAccount).identifier('dmlMockId').commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be in the database.');
		Assert.areEqual(1, result.merges().size(), 'Merged operation result should contain 1 result.');
		Assert.areEqual(Account.SObjectType, result.mergesOf(Account.SObjectType).objectType(), 'Merged operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.MERGE_DML, result.mergesOf(Account.SObjectType).operationType(), 'Merged operation result should contain merge type.');
		Assert.areEqual(1, result.mergesOf(Account.SObjectType).records().size(), 'Merged operation result should contain the merged record.');
		Assert.areEqual(1, result.mergesOf(Account.SObjectType).recordResults().size(), 'Merged operation result should contain the merged record results.');
		Assert.isTrue(result.mergesOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Merged operation result should contain a successful record result.');
		Assert.isNotNull(result.mergesOf(Account.SObjectType).recordResults()[0].id(), 'Merged operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toMergeMultipleRecordTypesWithMocking() {
		// Setup
		Account masterAccount = getAccount(1);
		Account duplicateAccount = getAccount(2);
		Lead masterLead = getLead(1);
		Lead duplicateLead = getLead(2);

		masterAccount.Id = DML.randomIdGenerator.get(Account.SObjectType);
		duplicateAccount.Id = DML.randomIdGenerator.get(Account.SObjectType);
		masterLead.Id = DML.randomIdGenerator.get(Lead.SObjectType);
		duplicateLead.Id = DML.randomIdGenerator.get(Lead.SObjectType);

		DML.mock('dmlMockId').allMerges();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		new DML().toMerge(masterAccount, duplicateAccount).toMerge(masterLead, duplicateLead).identifier('dmlMockId').commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No Account records should be in the database.');
		Assert.areEqual(0, [SELECT COUNT() FROM Lead], 'No Lead records should be in the database.');
		Assert.areEqual(2, result.merges().size(), 'Merged operation result should contain 2 results.');
		Assert.areEqual(Account.SObjectType, result.mergesOf(Account.SObjectType).objectType(), 'Merged operation result should contain Account object type.');
		Assert.areEqual(Lead.SObjectType, result.mergesOf(Lead.SObjectType).objectType(), 'Merged operation result should contain Lead object type.');
		Assert.areEqual(DML.OperationType.MERGE_DML, result.mergesOf(Account.SObjectType).operationType(), 'Merged operation result should contain merge type.');
		Assert.areEqual(DML.OperationType.MERGE_DML, result.mergesOf(Lead.SObjectType).operationType(), 'Merged operation result should contain merge type.');
		Assert.areEqual(1, result.mergesOf(Account.SObjectType).records().size(), 'Merged operation result should contain the merged record.');
		Assert.areEqual(1, result.mergesOf(Account.SObjectType).recordResults().size(), 'Merged operation result should contain the merged record results.');
		Assert.areEqual(1, result.mergesOf(Lead.SObjectType).records().size(), 'Merged operation result should contain the merged record.');
		Assert.areEqual(1, result.mergesOf(Lead.SObjectType).recordResults().size(), 'Merged operation result should contain the merged record results.');
		Assert.isTrue(result.mergesOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Merged operation result should contain a successful record result.');
		Assert.isTrue(result.mergesOf(Lead.SObjectType).recordResults()[0].isSuccess(), 'Merged operation result should contain a successful record result.');
	}

	@IsTest
	static void toMergeWithMockingSpecificSObjectType() {
		// Setup
		Account masterAccount = getAccount(1);
		Account duplicateAccount = getAccount(2);
		insert new List<Account>{ masterAccount, duplicateAccount };

		Lead masterLead = getLead(1);
		Lead duplicateLead = getLead(2);

		masterLead.Id = DML.randomIdGenerator.get(Lead.SObjectType);
		duplicateLead.Id = DML.randomIdGenerator.get(Lead.SObjectType);

		DML.mock('dmlMockId').mergesFor(Lead.SObjectType);

		// Test
		Test.startTest();
		new DML().toMerge(masterAccount, duplicateAccount).toMerge(masterLead, duplicateLead).identifier('dmlMockId').commitWork();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account merge should not be mocked.');
		Assert.areEqual(0, [SELECT COUNT() FROM Lead], 'Lead merge should be mocked.');
		Assert.areEqual(2, result.merges().size(), 'Merged operation result should contain 2 results.');
		Assert.areEqual(Account.SObjectType, result.mergesOf(Account.SObjectType).objectType(), 'Merged operation result should contain Account object type.');
		Assert.areEqual(Lead.SObjectType, result.mergesOf(Lead.SObjectType).objectType(), 'Merged operation result should contain Lead object type.');
	}

	@IsTest
	static void toMergeWithMockingException() {
		// Setup
		Account masterAccount = getAccount(1);
		Account duplicateAccount = getAccount(2);

		masterAccount.Id = DML.randomIdGenerator.get(Account.SObjectType);
		duplicateAccount.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').exceptionOnMerges();

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toMerge(masterAccount, duplicateAccount).identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
	}

	@IsTest
	static void toMergeWithMockingExceptionWhenAllOrNoneIsSet() {
		// Setup
		Account masterAccount = getAccount(1);
		Account duplicateAccount = getAccount(2);

		masterAccount.Id = DML.randomIdGenerator.get(Account.SObjectType);
		duplicateAccount.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').exceptionOnMerges();

		Exception expectedException = null;
		DML.Result result = null;

		// Test
		Test.startTest();
		try {
			result = new DML().toMerge(masterAccount, duplicateAccount).allowPartialSuccess().identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNull(expectedException, 'Expected exception to not be thrown.');

		DML.OperationResult operationResult = result.mergesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Result should contain 1 record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Result should contain 1 record result.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Result should contain Account object type.');
		Assert.areEqual(DML.OperationType.MERGE_DML, operationResult.operationType(), 'Result should contain merge type.');
		Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Result should contain a failed record result.');
		Assert.isTrue(operationResult.hasFailures(), 'Result should have failures.');
	}

	@IsTest
	static void toMergeWithMockingExceptionForSpecificSObjectType() {
		// Setup
		Account masterAccount = getAccount(1);
		Account duplicateAccount = getAccount(2);

		masterAccount.Id = DML.randomIdGenerator.get(Account.SObjectType);
		duplicateAccount.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').exceptionOnMergesFor(Account.SObjectType);

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toMerge(masterAccount, duplicateAccount).identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
	}

	@IsTest
	static void toMergeWithMockingExceptionForSpecificSObjectTypeWhenAllOrNoneIsSet() {
		// Setup
		Account masterAccount = getAccount(1);
		Account duplicateAccount = getAccount(2);

		masterAccount.Id = DML.randomIdGenerator.get(Account.SObjectType);
		duplicateAccount.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').exceptionOnMergesFor(Account.SObjectType);

		Exception expectedException = null;
		DML.Result result = null;

		// Test
		Test.startTest();
		try {
			result = new DML().toMerge(masterAccount, duplicateAccount).allowPartialSuccess().identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNull(expectedException, 'Expected exception to not be thrown.');

		DML.OperationResult operationResult = result.mergesOf(Account.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Result should contain 1 record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Result should contain 1 record result.');
		Assert.areEqual(Account.SObjectType, operationResult.objectType(), 'Result should contain Account object type.');
		Assert.areEqual(DML.OperationType.MERGE_DML, operationResult.operationType(), 'Result should contain merge type.');
		Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Result should contain a failed record result.');
		Assert.isTrue(operationResult.hasFailures(), 'Result should have failures.');
	}

	@IsTest
	static void toMergeWithEmptyRecordsWhenMocking() {
		// Setup
		Account masterAccount = getAccount(1);
		masterAccount.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allMerges();

		// Test
		Test.startTest();
		Exception expectedException = null;

		try {
			new DML().toMerge(masterAccount, new List<Account>()).identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify);
		Assert.isNull(expectedException, 'Expected exception to not be thrown.');
	}

	//  ================================================ MOCKING - PUBLISH =================================================

	@IsTest
	static void toPublishSingleRecordWithMocking() {
		// Setup
		FlowOrchestrationEvent event = new FlowOrchestrationEvent();

		DML.mock('dmlMockId').allPublishes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		new DML().toPublish(event).identifier('dmlMockId').commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(1, result.events().size(), 'Published operation result should contain 1 result.');
		Assert.areEqual(
			FlowOrchestrationEvent.SObjectType,
			result.eventsOf(FlowOrchestrationEvent.SObjectType).objectType(),
			'Published operation result should contain FlowOrchestrationEvent object type.'
		);
		Assert.areEqual(
			DML.OperationType.PUBLISH_DML,
			result.eventsOf(FlowOrchestrationEvent.SObjectType).operationType(),
			'Published operation result should contain publish type.'
		);
		Assert.areEqual(1, result.eventsOf(FlowOrchestrationEvent.SObjectType).records().size(), 'Published operation result should contain the published record.');
		Assert.areEqual(1, result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults().size(), 'Published operation result should contain the published record results.');
		Assert.isTrue(result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults()[0].isSuccess(), 'Published operation result should contain a successful record result.');
		Assert.isNotNull(result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults()[0].id(), 'Published operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toPublishSingleRecordWithMockingSpecificSObjectType() {
		// Setup
		FlowOrchestrationEvent event = new FlowOrchestrationEvent();

		DML.mock('dmlMockId').publishesFor(FlowOrchestrationEvent.SObjectType);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		new DML().toPublish(event).identifier('dmlMockId').commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(1, result.events().size(), 'Published operation result should contain 1 result.');
		Assert.areEqual(
			FlowOrchestrationEvent.SObjectType,
			result.eventsOf(FlowOrchestrationEvent.SObjectType).objectType(),
			'Published operation result should contain FlowOrchestrationEvent object type.'
		);
		Assert.areEqual(
			DML.OperationType.PUBLISH_DML,
			result.eventsOf(FlowOrchestrationEvent.SObjectType).operationType(),
			'Published operation result should contain publish type.'
		);
		Assert.areEqual(1, result.eventsOf(FlowOrchestrationEvent.SObjectType).records().size(), 'Published operation result should contain the published record.');
		Assert.areEqual(1, result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults().size(), 'Published operation result should contain the published record results.');
		Assert.isTrue(result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults()[0].isSuccess(), 'Published operation result should contain a successful record result.');
		Assert.isNotNull(result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults()[0].id(), 'Published operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toPublishMultipleRecordsWithMocking() {
		// Setup
		FlowOrchestrationEvent event1 = new FlowOrchestrationEvent();
		FlowOrchestrationEvent event2 = new FlowOrchestrationEvent();

		DML.mock('dmlMockId').allPublishes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		new DML().toPublish(event1).toPublish(event2).identifier('dmlMockId').commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(1, result.events().size(), 'Published operation result should contain 1 result.');
		Assert.areEqual(
			FlowOrchestrationEvent.SObjectType,
			result.eventsOf(FlowOrchestrationEvent.SObjectType).objectType(),
			'Published operation result should contain FlowOrchestrationEvent object type.'
		);
		Assert.areEqual(
			DML.OperationType.PUBLISH_DML,
			result.eventsOf(FlowOrchestrationEvent.SObjectType).operationType(),
			'Published operation result should contain publish type.'
		);
		Assert.areEqual(2, result.eventsOf(FlowOrchestrationEvent.SObjectType).records().size(), 'Published operation result should contain the published records.');
		Assert.areEqual(2, result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults().size(), 'Published operation result should contain the published record results.');
		Assert.isTrue(result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults()[0].isSuccess(), 'Published operation result should contain a successful record result.');
		Assert.isTrue(result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults()[1].isSuccess(), 'Published operation result should contain a successful record result.');
		Assert.isNotNull(result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults()[0].id(), 'Published operation result should contain a mocked record Id.');
		Assert.isNotNull(result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults()[1].id(), 'Published operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toPublishWithMockingException() {
		// Setup
		FlowOrchestrationEvent event = new FlowOrchestrationEvent();

		DML.mock('dmlMockId').exceptionOnPublishes();

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toPublish(event).identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
	}

	@IsTest
	static void toPublishWithMockingExceptionWhenAllOrNoneIsSet() {
		// Setup
		FlowOrchestrationEvent event = new FlowOrchestrationEvent();

		DML.mock('dmlMockId').exceptionOnPublishes();

		Exception expectedException = null;
		DML.Result result = null;

		// Test
		Test.startTest();
		try {
			result = new DML().toPublish(event).allowPartialSuccess().identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNull(expectedException, 'Expected exception to not be thrown.');

		DML.OperationResult operationResult = result.eventsOf(FlowOrchestrationEvent.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Result should contain 1 record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Result should contain 1 record result.');
		Assert.areEqual(FlowOrchestrationEvent.SObjectType, operationResult.objectType(), 'Result should contain FlowOrchestrationEvent object type.');
		Assert.areEqual(DML.OperationType.PUBLISH_DML, operationResult.operationType(), 'Result should contain publish type.');
		Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Result should contain a failed record result.');
		Assert.isTrue(operationResult.hasFailures(), 'Result should have failures.');
	}

	@IsTest
	static void toPublishWithMockingExceptionForSpecificSObjectType() {
		// Setup
		FlowOrchestrationEvent event = new FlowOrchestrationEvent();

		DML.mock('dmlMockId').exceptionOnPublishesFor(FlowOrchestrationEvent.SObjectType);

		Exception expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toPublish(event).identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
	}

	@IsTest
	static void toPublishWithMockingExceptionForSpecificSObjectTypeWhenAllOrNoneIsSet() {
		// Setup
		FlowOrchestrationEvent event = new FlowOrchestrationEvent();

		DML.mock('dmlMockId').exceptionOnPublishesFor(FlowOrchestrationEvent.SObjectType);

		Exception expectedException = null;
		DML.Result result = null;

		// Test
		Test.startTest();
		try {
			result = new DML().toPublish(event).allowPartialSuccess().identifier('dmlMockId').commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNull(expectedException, 'Expected exception to not be thrown.');

		DML.OperationResult operationResult = result.eventsOf(FlowOrchestrationEvent.SObjectType);

		Assert.areEqual(1, operationResult.records().size(), 'Result should contain 1 record.');
		Assert.areEqual(1, operationResult.recordResults().size(), 'Result should contain 1 record result.');
		Assert.areEqual(FlowOrchestrationEvent.SObjectType, operationResult.objectType(), 'Result should contain FlowOrchestrationEvent object type.');
		Assert.areEqual(DML.OperationType.PUBLISH_DML, operationResult.operationType(), 'Result should contain publish type.');
		Assert.isFalse(operationResult.recordResults()[0].isSuccess(), 'Result should contain a failed record result.');
		Assert.isTrue(operationResult.hasFailures(), 'Result should have failures.');
	}

	@IsTest
	static void toPublishWithEmptyRecordsWhenMocking() {
		// Setup
		DML.mock('dmlMockId').allPublishes();

		// Test
		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		new DML().toPublish(new List<FlowOrchestrationEvent>()).identifier('dmlMockId').commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, dmlStatementsAfter - dmlStatementsBefore, 'No DML statements should be executed.');

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, result.inserts().size(), 'Inserted operation result should contain 0 results.');
		Assert.areEqual(0, result.upserts().size(), 'Upserted operation result should contain 0 results.');
		Assert.areEqual(0, result.updates().size(), 'Updated operation result should contain 0 results.');
		Assert.areEqual(0, result.deletes().size(), 'Deleted operation result should contain 0 results.');
		Assert.areEqual(0, result.undeletes().size(), 'Undeleted operation result should contain 0 results.');
		Assert.areEqual(0, result.merges().size(), 'Merged operation result should contain 0 results.');
		Assert.areEqual(0, result.events().size(), 'Published operation result should contain 1 result.');
	}

	//  ================================================ MOCKING - INSERT IMMEDIATELY =================================================

	@IsTest
	static void toInsertImmediatelySingleRecordWithMocking() {
		// Setup
		Account account1 = getAccount(1);

		DML.mock('dmlMockId').allInserts();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').insertImmediately(account1);

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.isNotNull(account1.Id, 'Account should have mocked Id.');

		DML.OperationResult accountResult = result.insertsOf(Account.SObjectType);

		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Inserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.INSERT_DML, accountResult.operationType(), 'Inserted operation result should contain insert type.');
		Assert.areEqual(1, accountResult.records().size(), 'Inserted operation result should contain the inserted record.');
		Assert.areEqual(1, accountResult.recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Inserted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Inserted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toInsertImmediatelyMultipleRecordsWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		DML.mock('dmlMockId').allInserts();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').insertImmediately(new List<Account>{ account1, account2 });

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(1, result.inserts().size(), 'Inserted operation result should contain 2 results.');
		Assert.isNotNull(account1.Id, 'Account 1 should have mocked Id.');
		Assert.isNotNull(account2.Id, 'Account 2 should have mocked Id.');

		DML.OperationResult accountResult = result.insertsOf(Account.SObjectType);

		Assert.areEqual(DML.OperationType.INSERT_DML, accountResult.operationType(), 'Inserted operation result should contain insert type.');
		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Inserted operation result should contain Account object type.');
		Assert.areEqual(2, accountResult.records().size(), 'Inserted operation result should contain the inserted records.');
		Assert.areEqual(2, accountResult.recordResults().size(), 'Inserted operation result should contain the inserted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Inserted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Inserted operation result should contain a mocked record Id.');
	}

	//  ================================================ MOCKING - UPSERT IMMEDIATELY =================================================

	@IsTest
	static void toUpsertImmediatelySingleRecordWithMocking() {
		// Setup
		Account account1 = getAccount(1);

		DML.mock('dmlMockId').allUpserts();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').upsertImmediately(account1);

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be upserted to the database.');
		Assert.isNotNull(account1.Id, 'Account should have mocked Id.');

		DML.OperationResult accountResult = result.upsertsOf(Account.SObjectType);

		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Upserted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPSERT_DML, accountResult.operationType(), 'Upserted operation result should contain upsert type.');
		Assert.areEqual(1, accountResult.records().size(), 'Upserted operation result should contain the upserted record.');
		Assert.areEqual(1, accountResult.recordResults().size(), 'Upserted operation result should contain the upserted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Upserted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Upserted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toUpsertImmediatelyMultipleRecordsWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		DML.mock('dmlMockId').allUpserts();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').upsertImmediately(new List<Account>{ account1, account2 });

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be upserted to the database.');
		Assert.areEqual(1, result.upserts().size(), 'Upserted operation result should contain 2 results.');
		Assert.isNotNull(account1.Id, 'Account 1 should have mocked Id.');
		Assert.isNotNull(account2.Id, 'Account 2 should have mocked Id.');

		DML.OperationResult accountResult = result.upsertsOf(Account.SObjectType);

		Assert.areEqual(DML.OperationType.UPSERT_DML, accountResult.operationType(), 'Upserted operation result should contain upsert type.');
		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Upserted operation result should contain Account object type.');
		Assert.areEqual(2, accountResult.records().size(), 'Upserted operation result should contain the upserted records.');
		Assert.areEqual(2, accountResult.recordResults().size(), 'Upserted operation result should contain the upserted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Upserted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Upserted operation result should contain a mocked record Id.');
		Assert.isNotNull(accountResult.recordResults()[1].id(), 'Upserted operation result should contain a mocked record Id.');
	}

	// MOCKING - UPDATE IMMEDIATELY

	@IsTest
	static void toUpdateImmediatelySingleRecordWithMocking() {
		// Setup
		Account account1 = getAccount(1);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allUpdates();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').updateImmediately(account1);

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be updated to the database.');
		Assert.isNotNull(account1.Id, 'Account should have mocked Id.');

		DML.OperationResult accountResult = result.updatesOf(Account.SObjectType);

		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Updated operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UPDATE_DML, accountResult.operationType(), 'Updated operation result should contain update type.');
		Assert.areEqual(1, accountResult.records().size(), 'Updated operation result should contain the updated record.');
		Assert.areEqual(1, accountResult.recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Updated operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Updated operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toUpdateImmediatelyMultipleRecordsWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);
		account2.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allUpdates();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').updateImmediately(new List<Account>{ account1, account2 });

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be updated to the database.');
		Assert.areEqual(1, result.updates().size(), 'Updated operation result should contain 2 results.');
		Assert.isNotNull(account1.Id, 'Account 1 should have mocked Id.');
		Assert.isNotNull(account2.Id, 'Account 2 should have mocked Id.');

		DML.OperationResult accountResult = result.updatesOf(Account.SObjectType);

		Assert.areEqual(DML.OperationType.UPDATE_DML, accountResult.operationType(), 'Updated operation result should contain update type.');
		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Updated operation result should contain Account object type.');
		Assert.areEqual(2, accountResult.records().size(), 'Updated operation result should contain the updated records.');
		Assert.areEqual(2, accountResult.recordResults().size(), 'Updated operation result should contain the updated record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Updated operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Updated operation result should contain a mocked record Id.');
		Assert.isNotNull(accountResult.recordResults()[1].id(), 'Updated operation result should contain a mocked record Id.');
	}

	//  ================================================ MOCKING - DELETE IMMEDIATELY =================================================

	@IsTest
	static void toDeleteImmediatelySingleRecordWithMocking() {
		// Setup
		Account account1 = getAccount(1);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allDeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').deleteImmediately(account1);

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be deleted from the database.');
		Assert.isNotNull(account1.Id, 'Account should have mocked Id.');

		DML.OperationResult accountResult = result.deletesOf(Account.SObjectType);

		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, accountResult.operationType(), 'Deleted operation result should contain delete type.');
		Assert.areEqual(1, accountResult.records().size(), 'Deleted operation result should contain the deleted record.');
		Assert.areEqual(1, accountResult.recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Deleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toDeleteImmediatelyByIdsWithMocking() {
		// Setup
		Account account1 = getAccount(1);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allDeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').deleteImmediately(account1.Id);

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be deleted from the database.');
		Assert.isNotNull(account1.Id, 'Account should have mocked Id.');

		DML.OperationResult accountResult = result.deletesOf(Account.SObjectType);

		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, accountResult.operationType(), 'Deleted operation result should contain delete type.');
		Assert.areEqual(1, accountResult.records().size(), 'Deleted operation result should contain the deleted record.');
		Assert.areEqual(1, accountResult.recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Deleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toDeleteImmediatelyMultipleRecordsWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);
		account2.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allDeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').deleteImmediately(new List<Account>{ account1, account2 });

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be deleted from the database.');
		Assert.areEqual(1, result.deletes().size(), 'Deleted operation result should contain 2 results.');
		Assert.isNotNull(account1.Id, 'Account 1 should have mocked Id.');
		Assert.isNotNull(account2.Id, 'Account 2 should have mocked Id.');

		DML.OperationResult accountResult = result.deletesOf(Account.SObjectType);

		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, accountResult.operationType(), 'Deleted operation result should contain delete type.');
		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(2, accountResult.records().size(), 'Deleted operation result should contain the deleted records.');
		Assert.areEqual(2, accountResult.recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Deleted operation result should contain a mocked record Id.');
		Assert.isNotNull(accountResult.recordResults()[1].id(), 'Deleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toDeleteImmediatelyMultipleRecordsByIdsWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);
		account2.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allDeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').deleteImmediately(new List<Id>{ account1.Id, account2.Id });

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be deleted from the database.');
		Assert.areEqual(1, result.deletes().size(), 'Deleted operation result should contain 2 results.');
		Assert.isNotNull(account1.Id, 'Account 1 should have mocked Id.');
		Assert.isNotNull(account2.Id, 'Account 2 should have mocked Id.');

		DML.OperationResult accountResult = result.deletesOf(Account.SObjectType);

		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Deleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.DELETE_DML, accountResult.operationType(), 'Deleted operation result should contain delete type.');
		Assert.areEqual(2, accountResult.records().size(), 'Deleted operation result should contain the deleted records.');
		Assert.areEqual(2, accountResult.recordResults().size(), 'Deleted operation result should contain the deleted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Deleted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Deleted operation result should contain a mocked record Id.');
		Assert.isNotNull(accountResult.recordResults()[1].id(), 'Deleted operation result should contain a mocked record Id.');
	}

	//  ================================================ MOCKING - UNDELETE IMMEDIATELY =================================================

	@IsTest
	static void toUndeleteImmediatelySingleRecordWithMocking() {
		// Setup
		Account account1 = getAccount(1);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allUndeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').undeleteImmediately(account1);

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be undeleted from the database.');
		Assert.isNotNull(account1.Id, 'Account should have mocked Id.');

		DML.OperationResult accountResult = result.undeletesOf(Account.SObjectType);

		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Undeleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, accountResult.operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.areEqual(1, accountResult.records().size(), 'Undeleted operation result should contain the undeleted record.');
		Assert.areEqual(1, accountResult.recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Undeleted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Undeleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void toUndeleteImmediatelyMultipleRecordsWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);
		account2.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allUndeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').undeleteImmediately(new List<Account>{ account1, account2 });

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be undeleted from the database.');
		Assert.areEqual(1, result.undeletes().size(), 'Undeleted operation result should contain 2 results.');
		Assert.isNotNull(account1.Id, 'Account 1 should have mocked Id.');
		Assert.isNotNull(account2.Id, 'Account 2 should have mocked Id.');

		DML.OperationResult accountResult = result.undeletesOf(Account.SObjectType);

		Assert.areEqual(DML.OperationType.UNDELETE_DML, accountResult.operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Undeleted operation result should contain Account object type.');
		Assert.areEqual(2, accountResult.records().size(), 'Undeleted operation result should contain the undeleted records.');
		Assert.areEqual(2, accountResult.recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Undeleted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Undeleted operation result should contain a mocked record Id.');
		Assert.isNotNull(accountResult.recordResults()[1].id(), 'Undeleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void undeleteImmediatelyByIdWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allUndeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').undeleteImmediately(account1.Id);

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be undeleted from the database.');
		Assert.isNotNull(account1.Id, 'Account should have mocked Id.');

		DML.OperationResult accountResult = result.undeletesOf(Account.SObjectType);

		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Undeleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, accountResult.operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.areEqual(1, accountResult.records().size(), 'Undeleted operation result should contain the undeleted record.');
		Assert.areEqual(1, accountResult.recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Undeleted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Undeleted operation result should contain a mocked record Id.');
	}

	@IsTest
	static void undeleteImmediatelyByIdsWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		account1.Id = DML.randomIdGenerator.get(Account.SObjectType);
		account2.Id = DML.randomIdGenerator.get(Account.SObjectType);

		DML.mock('dmlMockId').allUndeletes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').undeleteImmediately(new List<Id>{ account1.Id, account2.Id });

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		DML.Result result = DML.retrieveResultFor('dmlMockId');

		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be undeleted from the database.');
		Assert.isNotNull(account1.Id, 'Account 1 should have mocked Id.');
		Assert.isNotNull(account2.Id, 'Account 2 should have mocked Id.');

		DML.OperationResult accountResult = result.undeletesOf(Account.SObjectType);

		Assert.areEqual(Account.SObjectType, accountResult.objectType(), 'Undeleted operation result should contain Account object type.');
		Assert.areEqual(DML.OperationType.UNDELETE_DML, accountResult.operationType(), 'Undeleted operation result should contain undelete type.');
		Assert.areEqual(2, accountResult.records().size(), 'Undeleted operation result should contain the undeleted records.');
		Assert.areEqual(2, accountResult.recordResults().size(), 'Undeleted operation result should contain the undeleted record results.');
		Assert.isTrue(accountResult.recordResults()[0].isSuccess(), 'Undeleted operation result should contain a successful record result.');
		Assert.isTrue(accountResult.recordResults()[1].isSuccess(), 'Undeleted operation result should contain a successful record result.');
		Assert.isNotNull(accountResult.recordResults()[0].id(), 'Undeleted operation result should contain a mocked record Id.');
		Assert.isNotNull(accountResult.recordResults()[1].id(), 'Undeleted operation result should contain a mocked record Id.');
	}

	//  ================================================ MOCKING - PUBLISH IMMEDIATELY =================================================

	@IsTest
	static void publishImmediatelySingleRecordWithMocking() {
		// Setup
		FlowOrchestrationEvent event = new FlowOrchestrationEvent();

		DML.mock('dmlMockId').allPublishes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').publishImmediately(event);

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(1, result.events().size(), 'Published operation result should contain 1 result.');
		Assert.areEqual(
			FlowOrchestrationEvent.SObjectType,
			result.eventsOf(FlowOrchestrationEvent.SObjectType).objectType(),
			'Published operation result should contain FlowOrchestrationEvent object type.'
		);
		Assert.areEqual(
			DML.OperationType.PUBLISH_DML,
			result.eventsOf(FlowOrchestrationEvent.SObjectType).operationType(),
			'Published operation result should contain publish type.'
		);
		Assert.areEqual(1, result.eventsOf(FlowOrchestrationEvent.SObjectType).records().size(), 'Published operation result should contain the published record.');
		Assert.areEqual(1, result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults().size(), 'Published operation result should contain the published record results.');
		Assert.isTrue(result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults()[0].isSuccess(), 'Published operation result should contain a successful record result.');
		Assert.isNotNull(result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults()[0].id(), 'Published operation result should contain a mocked record Id.');
	}

	@IsTest
	static void publishImmediatelyMultipleRecordsWithMocking() {
		// Setup
		FlowOrchestrationEvent event1 = new FlowOrchestrationEvent();
		FlowOrchestrationEvent event2 = new FlowOrchestrationEvent();

		DML.mock('dmlMockId').allPublishes();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().identifier('dmlMockId').publishImmediately(new List<FlowOrchestrationEvent>{ event1, event2 });

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(1, result.events().size(), 'Published operation result should contain 1 result.');
		Assert.areEqual(
			FlowOrchestrationEvent.SObjectType,
			result.eventsOf(FlowOrchestrationEvent.SObjectType).objectType(),
			'Published operation result should contain FlowOrchestrationEvent object type.'
		);
		Assert.areEqual(
			DML.OperationType.PUBLISH_DML,
			result.eventsOf(FlowOrchestrationEvent.SObjectType).operationType(),
			'Published operation result should contain publish type.'
		);
		Assert.areEqual(2, result.eventsOf(FlowOrchestrationEvent.SObjectType).records().size(), 'Published operation result should contain the published records.');
		Assert.areEqual(2, result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults().size(), 'Published operation result should contain the published record results.');
		Assert.isTrue(result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults()[0].isSuccess(), 'Published operation result should contain a successful record result.');
		Assert.isTrue(result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults()[1].isSuccess(), 'Published operation result should contain a successful record result.');
		Assert.isNotNull(result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults()[0].id(), 'Published operation result should contain a mocked record Id.');
		Assert.isNotNull(result.eventsOf(FlowOrchestrationEvent.SObjectType).recordResults()[1].id(), 'Published operation result should contain a mocked record Id.');
	}

	//  ================================================ MOCKING - OTHERS =================================================

	@IsTest
	static void retrieveResultForWhichDoesNotExist() {
		// Setup
		DML.mock('dmlMockId').allInserts();

		// Test
		Test.startTest();
		Exception expectedException = null;
		try {
			DML.retrieveResultFor('dmlMockId');
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.isTrue(expectedException.getMessage().contains('No result found for dml identifier: dmlMockId'), 'Expected exception message should be thrown.');
	}

	//  ================================================ OPTIONS =================================================

	@IsTest
	static void sharedDmlInstance() {
		Account account = getAccount(1);

		Test.startTest();
		Integer dmlStatementsBefore = Limits.getDMLStatements();

		DML.Shared.toInsert(account).commitWork();
		DML.Shared.commitWork();

		Integer dmlStatementsAfter = Limits.getDMLStatements();
		Test.stopTest();

		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Account should be inserted.');
		Assert.areEqual(1, dmlStatementsAfter - dmlStatementsBefore, 'DML statements should be 1, because second commitWork() should not do anything.');
	}

	@IsTest
	static void sharedDmlInstanceWithMocking() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		DML.mock('dmlMockId').allInserts();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Shared.identifier('dmlMockId').toInsert(account1).toInsert(account2).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		DML.Result result = DML.retrieveResultFor('dmlMockId');

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the mocking.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No records should be inserted to the database.');
		Assert.areEqual(1, result.inserts().size(), 'Inserted operation result should contain 1 result.');
		Assert.areEqual(2, result.insertsOf(Account.SObjectType).records().size(), 'Inserted operation result should contain 2 records.');
		Assert.isTrue(result.insertsOf(Account.SObjectType).recordResults()[0].isSuccess(), 'Inserted operation result should contain a successful record result.');
		Assert.isTrue(result.insertsOf(Account.SObjectType).recordResults()[1].isSuccess(), 'Inserted operation result should contain a successful record result.');
	}

	@IsTest
	static void sharedDmlInstanceMultipleOperations() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;

		Account account2 = getAccount(2);
		Contact contact1 = getContact(1);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		account1.Name = 'Updated Account';

		DML.Shared.toInsert(account2).toUpdate(account1).toInsert(contact1).commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(3, dmlsAfter - dmlsBefore, '3 DML statements should be executed (2 inserts + 1 update).');
		Assert.areEqual(2, [SELECT COUNT() FROM Account], 'Two accounts should exist.');
		Assert.areEqual(1, [SELECT COUNT() FROM Contact], 'One contact should exist.');
		Assert.areEqual('Updated Account', [SELECT Name FROM Account WHERE Id = :account1.Id].Name, 'Account 1 should be updated.');
	}

	@IsTest
	static void sharedDmlInstanceDiscardWork() {
		// Setup
		Account account1 = getAccount(1);
		Account account2 = getAccount(2);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		DML.Shared.toInsert(account1).toInsert(account2).discardWork();
		DML.Shared.commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(0, dmlsAfter - dmlsBefore, 'No DML statements should be executed, because work was discarded.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'No accounts should be inserted, because work was discarded.');
		Assert.isNull(account1.Id, 'Account 1 should not have an Id.');
		Assert.isNull(account2.Id, 'Account 2 should not have an Id.');
	}

	@IsTest
	static void allowFieldTruncationOption() {
		// Setup
		String longAccountName = 'Test Account ' + 'Test'.repeat(' ', 100);
		Account account = getAccount(1);
		account.Name = longAccountName;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		Database.DmlOptions options = new Database.DmlOptions();
		options.allowFieldTruncation = true;

		new DML().toInsert(account).options(options).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		List<Account> accounts = getAccounts();

		Assert.areEqual(1, accounts.size(), 'Account should be inserted.');
		Assert.areEqual(255, accounts[0].Name.length(), 'Account name should be 255 characters long, because allowFieldTruncation is true.');
	}

	@IsTest
	static void optionsAllOrNoneDisabled() {
		// Setup
		List<Account> accounts = new List<Account>{
			getAccount(1),
			new Account() // Name is required
		};

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		Database.DmlOptions options = new Database.DmlOptions();
		options.optAllOrNone = false;

		new DML().toInsert(accounts).options(options).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Only one account should be inserted, because one has missing required field.');
	}

	@IsTest
	static void skipDuplicateRules() {
		// Setup
		Account account = getAccount(1);
		Account duplicateAccount = new Account(Name = account.Name);

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		new DML().toInsert(account).toInsert(duplicateAccount).skipDuplicateRules().commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(2, [SELECT COUNT() FROM Account], 'Both accounts should be inserted, because skipDuplicateRules is true.');
	}

	@IsTest
	static void optionsAllOrNoneEnabled() {
		// Setup
		List<Account> accounts = new List<Account>{
			getAccount(1),
			new Account() // Name is required
		};

		Exception expectedException = null;

		// Test
		Test.startTest();
		Database.DmlOptions options = new Database.DmlOptions();
		options.optAllOrNone = true;

		try {
			new DML().toInsert(accounts).options(options).commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.isTrue(expectedException.getMessage().contains('Required fields are missing: [Name]'), 'Expected exception message should be thrown.');
	}

	//  ================================================ OPTIONS - ALLOW PARTIAL SUCCESS =================================================

	@IsTest
	static void toInsertWithPartialSuccess() {
		// Setup
		List<Account> accounts = new List<Account>{
			getAccount(1),
			new Account() // Name is required
		};

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		new DML().toInsert(accounts).allowPartialSuccess().commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Only one account should be inserted, because one has missing required field.');
	}

	@IsTest
	static void toUpdateWithPartialSuccess() {
		// Setup
		List<Account> accounts = new List<Account>{ getAccount(1), getAccount(2) };
		insert accounts;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		accounts[0].Name = null;
		accounts[1].Name = 'Test Account 1 New Name';

		new DML().toUpdate(accounts).allowPartialSuccess().commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, 'No DML statements should be made, because of the partial success.');
		Assert.areEqual(
			2,
			[SELECT COUNT() FROM Account WHERE Name IN ('Test Account 1', 'Test Account 1 New Name')],
			'Accounts should be present with expected names after partial success update.'
		);
	}

	@IsTest
	static void toUpsertWithPartialSuccess() {
		// Setup
		List<Account> accounts = new List<Account>{ getAccount(1), getAccount(2) };
		insert accounts;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();

		accounts[0].Name = null; // Name will not change, because it's set to null
		accounts[1].Name = 'Test Account 1 New Name';

		accounts.add(getAccount(3)); // New account

		new DML().toUpsert(accounts).allowPartialSuccess().commitWork();

		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(
			3,
			[SELECT COUNT() FROM Account WHERE Name IN ('Test Account 1', 'Test Account 1 New Name', 'Test Account 3')],
			'Accounts should be upserted with expected names.'
		);
	}

	@IsTest
	static void toDeleteWithPartialSuccess() {
		// Setup
		List<Account> accounts = new List<Account>{ getAccount(1), getAccount(2) };
		insert accounts;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		new DML().toDelete(accounts).allowPartialSuccess().commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Accounts should be deleted.');
	}

	@IsTest
	static void toHardDeleteWithPartialSuccess() {
		// Setup
		List<Account> accounts = new List<Account>{ getAccount(1), getAccount(2) };

		insert accounts;

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		new DML().toHardDelete(accounts).allowPartialSuccess().commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(2, dmlsAfter - dmlsBefore, '2 DML statements should be executed (1 delete + 1 hard delete).');
		Assert.areEqual(0, [SELECT COUNT() FROM Account], 'Accounts should be hard deleted.');
		// No assertion with ALL ROWS, because there is Salesforce error
	}

	//  ================================================ OPTIONS - USER MODE =================================================

	@IsTest
	static void toInsertUserMode() {
		// Setup
		Case newCase = getCase(1);

		Exception expectedException = null;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			try {
				new DML().toInsert(newCase).commitWork(); // user mode by default
			} catch (Exception e) {
				expectedException = e;
			}
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual('Access to entity \'Case\' denied', expectedException.getMessage(), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void toInsertWithUserModeExplicitlySet() {
		// Setup
		Case newCase = getCase(1);

		Exception expectedException = null;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			try {
				new DML().toInsert(newCase).userMode().commitWork();
			} catch (Exception e) {
				expectedException = e;
			}
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual('Access to entity \'Case\' denied', expectedException.getMessage(), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void toUpdateWithUserMode() {
		// Setup
		Case newCase = getCase(1);
		insert newCase;

		Exception expectedException = null;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			try {
				newCase.Subject = 'Updated Test Case';
				new DML().toUpdate(newCase).commitWork(); // user mode by default
			} catch (Exception e) {
				expectedException = e;
			}
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual('Access to entity \'Case\' denied', expectedException.getMessage(), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void toUpdateWithUserModeExplicitlySet() {
		// Setup
		Case newCase = getCase(1);
		insert newCase;

		Exception expectedException = null;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			try {
				newCase.Subject = 'Updated Test Case';
				new DML().toUpdate(newCase).userMode().commitWork();
			} catch (Exception e) {
				expectedException = e;
			}
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual('Access to entity \'Case\' denied', expectedException.getMessage(), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void toUpsertWithUserMode() {
		// Setup
		Case newCase1 = getCase(1);
		Case newCase2 = getCase(2);

		insert newCase1;

		Exception expectedException = null;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			try {
				newCase1.Subject = 'Updated Test Case';

				new DML().toUpsert(newCase1).toUpsert(newCase2).commitWork(); // user mode by default
			} catch (Exception e) {
				expectedException = e;
			}
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.isTrue(
			expectedException.getMessage().contains('Operation failed due to fields being inaccessible on Sobject Case, check errors on Exception or Result'),
			'Expected exception message should be thrown.'
		);
	}

	@IsTest
	static void toUpsertWithUserModeExplicitlySet() {
		// Setup
		Case newCase1 = getCase(1);
		Case newCase2 = getCase(2);

		insert newCase1;

		Exception expectedException = null;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			try {
				newCase1.Subject = 'Updated Test Case';

				new DML().toUpsert(newCase1).toUpsert(newCase2).userMode().commitWork();
			} catch (Exception e) {
				expectedException = e;
			}
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.isTrue(
			expectedException.getMessage().contains('Operation failed due to fields being inaccessible on Sobject Case, check errors on Exception or Result'),
			'Expected exception message should be thrown.'
		);
	}

	@IsTest
	static void toDeleteWithUserMode() {
		// Setup
		Case newCase = getCase(1);
		insert newCase;

		Exception expectedException = null;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			try {
				new DML().toDelete(newCase).commitWork(); // user mode by default
			} catch (Exception e) {
				expectedException = e;
			}
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual('Access to entity \'Case\' denied', expectedException.getMessage(), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void toDeleteWithUserModeExplicitlySet() {
		// Setup
		Case newCase = getCase(1);
		insert newCase;

		Exception expectedException = null;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			try {
				new DML().toDelete(newCase).userMode().commitWork();
			} catch (Exception e) {
				expectedException = e;
			}
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual('Access to entity \'Case\' denied', expectedException.getMessage(), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void toHardDeleteWithUserMode() {
		// Setup
		Case newCase = getCase(1);
		insert newCase;

		Exception expectedException = null;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			try {
				new DML().toHardDelete(newCase).commitWork(); // user mode by default
			} catch (Exception e) {
				expectedException = e;
			}
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual('Access to entity \'Case\' denied', expectedException.getMessage(), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void toHardDeleteWithSystemMode() {
		// Setup
		Case newCase = getCase(1);
		insert newCase;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			new DML().toHardDelete(newCase).systemMode().withoutSharing().commitWork();
		}
		Test.stopTest();

		// Verify
		Assert.areEqual(0, [SELECT COUNT() FROM Case], 'Cases should be hard deleted.');
		// No assertion with ALL ROWS, because there is Salesforce error
	}

	@IsTest
	static void toUndeleteWithUserMode() {
		// Setup
		Case newCase = getCase(1);
		insert newCase;

		delete newCase;

		Assert.areEqual(0, [SELECT COUNT() FROM Case], 'Cases should be deleted.');

		Exception expectedException = null;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			try {
				new DML().toUndelete(newCase).commitWork(); // user mode by default
			} catch (Exception e) {
				expectedException = e;
			}
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.isTrue(expectedException.getMessage().contains('invalid record id'), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void toUndeleteWithUserModeExplicitlySet() {
		// Setup
		Case newCase = getCase(1);
		insert newCase;

		delete newCase;

		Assert.areEqual(0, [SELECT COUNT() FROM Case], 'Cases should be deleted.');

		Exception expectedException = null;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			try {
				new DML().toUndelete(newCase).userMode().commitWork();
			} catch (Exception e) {
				expectedException = e;
			}
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.isTrue(expectedException.getMessage().contains('invalid record id'), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void toMergeWithUserMode() {
		// Setup
		Account masterAccount = getAccount(1);
		Account duplicateAccount = getAccount(2);
		insert new List<Account>{ masterAccount, duplicateAccount };

		Exception expectedException = null;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			try {
				new DML().toMerge(masterAccount, duplicateAccount).commitWork(); // user mode by default
			} catch (Exception e) {
				expectedException = e;
			}
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
	}

	//  ================================================ OPTIONS - SYSTEM MODE =================================================

	@IsTest
	static void toInsertSystemMode() {
		// Setup
		Case newCase = getCase(1);

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			new DML().toInsert(newCase).systemMode().commitWork();
		}
		Test.stopTest();

		// Verify
		Assert.areEqual(1, [SELECT COUNT() FROM Case], 'Case should be inserted.');
		Assert.isNotNull(newCase.Id, 'Case should be inserted and have an Id.');
	}

	@IsTest
	static void toUpdateWithSystemMode() {
		// Setup
		Case newCase = getCase(1);
		insert newCase;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			newCase.Subject = 'Updated Test Case';

			new DML().toUpdate(newCase).systemMode().withoutSharing().commitWork();
		}
		Test.stopTest();

		// Verify
		Assert.areEqual(1, [SELECT COUNT() FROM Case], 'Case should be updated.');
		Assert.isNotNull(newCase.Id, 'Case should be updated and have an Id.');
	}

	@IsTest
	static void toUpdateWithSystemModeAndWithSharing() {
		// Setup
		Contact newContact = getContact(1);
		insert newContact;

		Exception expectedException = null;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			try {
				newContact.FirstName = 'Updated Test Contact';
				new DML().toUpdate(newContact).systemMode().withSharing().commitWork();
			} catch (Exception e) {
				expectedException = e;
			}
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.isTrue(expectedException.getMessage().contains('insufficient access rights on cross-reference id'), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void toUpsertWithSystemMode() {
		// Setup
		Case newCase1 = getCase(1);
		Case newCase2 = getCase(2);

		insert newCase1;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			newCase1.Subject = 'Updated Test Case';

			new DML().toUpsert(newCase1).toUpsert(newCase2).systemMode().withoutSharing().commitWork();
		}
		Test.stopTest();

		// Verify
		Assert.areEqual(2, [SELECT COUNT() FROM Case], 'Cases should be upserted.');

		Assert.isNotNull(newCase1.Id, 'Case 1 should be upserted and have an Id.');
		Assert.isNotNull(newCase2.Id, 'Case 2 should be upserted and have an Id.');
	}

	@IsTest
	static void toUpsertWithSystemModeAndWithSharing() {
		// Setup
		Contact newContact1 = getContact(1);
		Contact newContact2 = getContact(2);

		insert newContact1;

		Exception expectedException = null;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			try {
				newContact1.FirstName = 'Updated Test Contact';
				new DML().toUpsert(newContact1).toUpsert(newContact2).withSharing().systemMode().commitWork();
			} catch (Exception e) {
				expectedException = e;
			}
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.isTrue(expectedException.getMessage().contains('insufficient access rights on cross-reference id'), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void toDeleteWithSystemMode() {
		// Setup
		Case newCase = getCase(1);
		insert newCase;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			new DML().toDelete(newCase).systemMode().withoutSharing().commitWork();
		}
		Test.stopTest();

		// Verify
		Assert.areEqual(0, [SELECT COUNT() FROM Case], 'Cases should be deleted.');
	}

	@IsTest
	static void toDeleteWithSystemModeAndWithSharing() {
		// Setup
		Case newCase = getCase(1);
		insert newCase;

		Exception expectedException = null;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			try {
				new DML().toDelete(newCase).systemMode().withoutSharing().commitWork();
			} catch (Exception e) {
				expectedException = e;
			}
		}
		Test.stopTest();

		// Verify
		Assert.areEqual(0, [SELECT COUNT() FROM Case], 'Case should be deleted with system mode and without sharing.');
		Assert.isNull(expectedException, 'No exception should be thrown.');
	}

	@IsTest
	static void toUndeleteWithSystemMode() {
		// Setup
		Case newCase = getCase(1);
		insert newCase;

		delete newCase;

		Assert.areEqual(0, [SELECT COUNT() FROM Case], 'Cases should be deleted.');

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			new DML().toUndelete(newCase).systemMode().withoutSharing().commitWork();
		}
		Test.stopTest();

		// Verify
		Assert.areEqual(1, [SELECT COUNT() FROM Case], 'Cases should be undeleted.');
	}

	@IsTest
	static void toUndeleteWithSystemModeAndWithSharing() {
		// Setup
		Case newCase = getCase(1);
		insert newCase;

		delete newCase;

		Assert.areEqual(0, [SELECT COUNT() FROM Case], 'Cases should be deleted.');

		Exception expectedException = null;

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			try {
				new DML().toUndelete(newCase).systemMode().withSharing().commitWork();
			} catch (Exception e) {
				expectedException = e;
			}
		}
		Test.stopTest();

		// Verify
		Assert.areEqual(0, [SELECT COUNT() FROM Case], 'Case should not be undeleted, because user has no access with sharing mode.');
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.isTrue(expectedException.getMessage().contains('insufficient access rights on object id'), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void toMergeWithSystemMode() {
		// Setup
		Account masterAccount = getAccount(1);
		Account duplicateAccount = getAccount(2);
		insert new List<Account>{ masterAccount, duplicateAccount };

		// Test
		Test.startTest();
		System.runAs(minimumAccessUser()) {
			new DML().toMerge(masterAccount, duplicateAccount).systemMode().withoutSharing().commitWork();
		}
		Test.stopTest();

		// Verify
		Assert.areEqual(1, [SELECT COUNT() FROM Account], 'Only master account should remain after merge.');
	}

	// =================================================================================================
	// ================================================ VALIDATION =================================================
	// =================================================================================================

	//  ================================================ VALIDATION - INSERT =================================================

	@IsTest
	static void toInsertWithInvalidRelationshipSingleRecord() {
		// Setup
		Account newAccount = getAccount(1);
		Contact newContact = getContact(1);

		// Test
		Test.startTest();
		Exception expectedException = null;

		try {
			new DML().toInsert(newAccount).toInsert(DML.Record(newContact).withRelationship(Contact.LastName, newAccount)).commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual('Invalid argument: LastName. Field supplied is not a relationship field.', expectedException.getMessage(), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void toInsertWithInvalidTargetRelationshipFieldSingleRecord() {
		// Setup
		Account newAccount = getAccount(1);
		Contact newContact = getContact(1);

		// Test
		Test.startTest();
		Exception expectedException = null;

		try {
			new DML().toInsert(newAccount).toInsert(DML.Record(newContact).withRelationship(Contact.LastName, Account.Name, 'Test')).commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual(
			'Invalid argument: relationshipField. Field supplied is not a relationship field.',
			expectedException.getMessage(),
			'Expected exception message should be thrown.'
		);
	}

	@IsTest
	static void recordWithEmptyId() {
		// Setup
		Account account = getAccount(1);

		// Test
		Test.startTest();
		Exception expectedException = null;
		try {
			new DML().toInsert(DML.Record(account.Id)).commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.isTrue(expectedException.getMessage().contains('Invalid argument: recordId. Record ID cannot be null.'), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void toInsertWithInvalidExternalRelationshipSingleRecord() {
		// Setup
		Account newAccount = getAccount(1);
		Contact newContact = getContact(1);

		// Test
		Test.startTest();
		Exception expectedException = null;

		try {
			new DML().toInsert(newAccount).toInsert(DML.Record(newContact).withRelationship(Contact.AccountId, Account.Name, 'Test')).commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual(
			'Invalid argument: externalIdField. Field supplied is not marked as an External Identifier.',
			expectedException.getMessage(),
			'Expected exception message should be thrown.'
		);
	}

	@IsTest
	static void toInsertWithExistingIds() {
		// Setup
		Account account = getAccount(1);
		insert account;

		DmlException expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toInsert(account).commitWork();
		} catch (DmlException e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual('Only new records can be registered as new.', expectedException.getMessage(), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void toInsertWithInvalidTargetRelationshipFieldMultipleRecords() {
		// Setup
		Account newAccount = getAccount(1);
		Contact newContact1 = getContact(1);
		Contact newContact2 = getContact(2);

		List<Contact> contacts = new List<Contact>{ newContact1, newContact2 };

		// Test
		Test.startTest();
		Exception expectedException = null;

		try {
			new DML().toInsert(newAccount).toInsert(DML.Records(contacts).withRelationship(Contact.LastName, newAccount)).commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual('Invalid argument: LastName. Field supplied is not a relationship field.', expectedException.getMessage(), 'Expected exception message should be thrown.');
	}

	@IsTest
	static void toInsertWithInvalidExternalRelationshipMultipleRecords() {
		// Setup
		Account newAccount = getAccount(1);
		Contact newContact1 = getContact(1);
		Contact newContact2 = getContact(2);

		List<Contact> contacts = new List<Contact>{ newContact1, newContact2 };

		// Test
		Test.startTest();
		Exception expectedException = null;

		try {
			new DML().toInsert(newAccount).toInsert(DML.Records(contacts).withRelationship(Contact.LastName, Account.Name, 'Test')).commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual(
			'Invalid argument: relationshipField. Field supplied is not a relationship field.',
			expectedException.getMessage(),
			'Expected exception message should be thrown.'
		);
	}

	@IsTest
	static void toInsertWithInvalidExternalIdFieldMultipleRecords() {
		// Setup
		Account newAccount = getAccount(1);
		Contact newContact1 = getContact(1);
		Contact newContact2 = getContact(2);

		List<Contact> contacts = new List<Contact>{ newContact1, newContact2 };

		// Test
		Test.startTest();
		Exception expectedException = null;

		try {
			new DML().toInsert(newAccount).toInsert(DML.Records(contacts).withRelationship(Contact.AccountId, Account.Name, 'Test')).commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual(
			'Invalid argument: externalIdField. Field supplied is not marked as an External Identifier.',
			expectedException.getMessage(),
			'Expected exception message should be thrown.'
		);
	}

	// ================================================ VALIDATION - UPDATE =================================================

	@IsTest
	static void toUpdateSingleRecordTwice() {
		// Setup
		Account account1 = getAccount(1);
		insert account1;

		// Test
		Test.startTest();
		Exception expectedException = null;

		try {
			account1.Name = 'Updated Test Account';

			DML db = new DML();

			db.toUpdate(account1);

			Account duplicatedAccount = new Account(Id = account1.Id, Name = 'Updated Test Account 2');

			db.toUpdate(duplicatedAccount);

			db.commitWork();
		} catch (Exception e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual(
			'Duplicate records found during registration. Fix the code or use the combineOnDuplicate() method.',
			expectedException.getMessage(),
			'Expected exception message should be thrown.'
		);
	}

	@IsTest
	static void toUpdateWithoutExistingIds() {
		// Setup
		Account account = getAccount(1);

		DmlException expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toUpdate(account).commitWork();
		} catch (DmlException e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual('Only existing records can be updated.', expectedException.getMessage(), 'Expected exception message should be thrown.');
	}

	//  ================================================ VALIDATION - UNDELETE =================================================

	@IsTest
	static void toUndeleteWithoutExistingIds() {
		// Setup
		Account account = getAccount(1);

		DmlException expectedException = null;

		// Test
		Test.startTest();
		try {
			new DML().toUndelete(account).commitWork();
		} catch (DmlException e) {
			expectedException = e;
		}
		Test.stopTest();

		// Verify
		Assert.isNotNull(expectedException, 'Expected exception to be thrown.');
		Assert.areEqual('Only deleted records can be undeleted.', expectedException.getMessage(), 'Expected exception message should be thrown.');
	}

	//  ================================================ HOOK =================================================

	@IsTest
	static void commitHook() {
		// Setup
		Account account = getAccount(1);

		MyHook hook = new MyHook();

		// Test
		Test.startTest();
		Integer dmlsBefore = Limits.getDMLStatements();
		new DML().toInsert(account).commitHook(hook).commitWork();
		Integer dmlsAfter = Limits.getDMLStatements();
		Test.stopTest();

		// Verify
		Assert.areEqual(1, dmlsAfter - dmlsBefore, '1 DML statement should be executed.');
		Assert.isTrue(hook.beforeCalled, 'Before hook should be called.');
		Assert.isTrue(hook.afterCalled, 'After hook should be called.');
	}

	public class MyHook implements DML.Hook {
		private Boolean beforeCalled = false;
		private Boolean afterCalled = false;

		public void before() {
			beforeCalled = true;
		}

		public void after(DML.Result result) {
			afterCalled = true;

			Assert.isNotNull(result, 'Result should not be null.');
		}
	}

	// HELPERS

	static Account getAccount(Integer index) {
		return new Account(Name = 'Test Account ' + index);
	}

	static Contact getContact(Integer index) {
		return new Contact(FirstName = 'Test ' + index, LastName = 'Contact ' + index);
	}

	static Opportunity getOpportunity(Integer index) {
		return new Opportunity(Name = 'Test Opportunity ' + index, CloseDate = Date.today(), StageName = 'Prospecting');
	}

	static Lead getLead(Integer index) {
		return new Lead(FirstName = 'Test ' + index, LastName = 'Lead ' + index, Company = 'Test Company ' + index);
	}

	static Case getCase(Integer index) {
		return new Case(Status = 'New', Origin = 'Web', Subject = 'Test ' + index);
	}

	static Account insertAccount() {
		Account account = new Account(Name = 'Test Account');
		insert account;

		return account;
	}

	@SuppressWarnings('PMD.AvoidNonRestrictiveQueries')
	static List<Account> getAccounts() {
		return [SELECT Id, Name FROM Account];
	}

	static List<Account> insertAccounts() {
		List<Account> accounts = new List<Account>{ new Account(Name = 'Test Account 1'), new Account(Name = 'Test Account 2'), new Account(Name = 'Test Account 3') };
		insert accounts;

		return accounts;
	}

	static User minimumAccessUser() {
		return new User(
			Alias = 'newUser',
			Email = 'newuser@testorg.com',
			EmailEncodingKey = 'UTF-8',
			LastName = 'Testing',
			LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US',
			Profile = new Profile(Name = 'Minimum Access - Salesforce'),
			TimeZoneSidKey = 'America/Los_Angeles',
			UserName = 'btcdmllibuser@testorg.com'
		);
	}
}
