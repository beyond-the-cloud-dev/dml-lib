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
private class DML_Test {
	// ================================================ INSERT =================================================

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

	// ================================================ UPDATE =================================================

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

	// ================================================ UPSERT =================================================

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

	// ================================================ DELETE =================================================

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

	// ================================================ HARD DELETE =================================================

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

	//  ================================================ PLATFORM EVENT =================================================

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

	//  ================================================ RECORDS =================================================

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

	// ================================================ RESULTS =================================================

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

	//  ================================================ DEPENDENCIES =================================================

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

	// ================================================================================================
	// =========================================== MOCKING ============================================
	// ================================================================================================

	//  ================================================ MOCKING - INSERT =================================================

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

	@SuppressWarnings('PMD.AvoidNonRestrictiveQueries')
	static List<Account> getAccounts() {
		return [SELECT Id, Name FROM Account];
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
