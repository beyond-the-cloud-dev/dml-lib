/**
 * Copyright (c) 2025 Beyond The Cloud Sp. z o.o. (BeyondTheCloud.Dev)
 * Licensed under the MIT License (https://github.com/beyond-the-cloud-dev/dml-lib/blob/main/LICENSE)
 *
 * v2.0.0
 *
 * PMD False Positives:
 * - MethodNamingConventions - Some methods are uppercase to indicate that they are "constructors" of other internal classes
 * - CyclomaticComplexity: It is a library and we tried to put everything into ONE class
 * - CognitiveComplexity: It is a library and we tried to put everything into ONE class
 * - ExcessivePublicCount: It is a library and we tried to put everything into ONE class
 * - FieldDeclarationsShouldBeAtStart: The most important methods and interfaces are at the top of the class
 * - AvoidDebugStatements: Debug statements are used for debugging purposes
 * - OperationWithLimitsInLoop: DMLs are executed by SObject OperationType and the loop is through different types
 * - ApexCRUDViolation: DMLs are executed by User Mode or System Mode
 * - ExcessiveClassLength: The class is a library and we tried to put everything into ONE class
 * - NcssTypeCount: The class is a library and we tried to put everything into ONE class
 * - PropertyNamingConventions: Some properties are PascalCase to indicate that they are "constructors" of other internal classes
 * - FieldNamingConventions: Some fields has not standard naming convention on purpose
 * - AvoidGlobalModifier - DML has package version
 **/
@SuppressWarnings('PMD.MethodNamingConventions,PMD.CyclomaticComplexity,PMD.CognitiveComplexity,PMD.ExcessivePublicCount,PMD.FieldDeclarationsShouldBeAtStart,PMD.AvoidDebugStatements,PMD.OperationWithLimitsInLoop,PMD.ApexCRUDViolation,PMD.ExcessiveClassLength,PMD.NcssTypeCount,PMD.PropertyNamingConventions,PMD.FieldNamingConventions,PMD.AvoidGlobalModifier')
global inherited sharing class DML implements Commitable {
	global static Commitable Shared {
		get {
			if (Shared == null) {
				Shared = new DML();
			}
			return Shared;
		}
		private set;
	}

	global static Record Record(SObject record) {
		return new DmlRecord(record);
	}

	global static Record Record(Id recordId) {
		return new DmlRecord(recordId);
	}

	global static Records Records(List<SObject> records) {
		return new DmlRecords(records);
	}

	global static Records Records(Iterable<Id> recordIds) {
		return new DmlRecords(recordIds);
	}

	global interface Commitable {
		// Insert
		Commitable toInsert(SObject record);
		Commitable toInsert(DML.Record record);
		Commitable toInsert(List<SObject> records);
		Commitable toInsert(DML.Records records);
		// Update
		Commitable toUpdate(SObject record);
		Commitable toUpdate(DML.Record record);
		Commitable toUpdate(List<SObject> records);
		Commitable toUpdate(DML.Records records);
		// Upsert
		Commitable toUpsert(SObject record);
		Commitable toUpsert(SObject record, SObjectField externalIdField);
		Commitable toUpsert(DML.Record record);
		Commitable toUpsert(List<SObject> records);
		Commitable toUpsert(List<SObject> records, SObjectField externalIdField);
		Commitable toUpsert(DML.Records records);
		// Delete
		Commitable toDelete(Id recordId);
		Commitable toDelete(SObject record);
		Commitable toDelete(Iterable<Id> recordIds);
		Commitable toDelete(List<SObject> records);
		// Hard Delete
		Commitable toHardDelete(Id recordId);
		Commitable toHardDelete(SObject record);
		Commitable toHardDelete(Iterable<Id> recordIds);
		Commitable toHardDelete(List<SObject> records);
		// Undelete
		Commitable toUndelete(Id recordId);
		Commitable toUndelete(SObject record);
		Commitable toUndelete(Iterable<Id> recordIds);
		Commitable toUndelete(List<SObject> records);
		// Merge
		Commitable toMerge(SObject mergeToRecord, SObject duplicatedRecord);
		Commitable toMerge(SObject mergeToRecord, List<SObject> duplicateRecords);
		Commitable toMerge(SObject mergeToRecord, Id duplicatedRecordId);
		Commitable toMerge(SObject mergeToRecord, Iterable<Id> duplicatedRecordIds);
		// Platform Event
		Commitable toPublish(SObject record);
		Commitable toPublish(List<SObject> records);
		// Immediate Insert
		OperationResult insertImmediately(SObject record);
		OperationResult insertImmediately(DML.Record record);
		OperationResult insertImmediately(List<SObject> records);
		OperationResult insertImmediately(DML.Records records);
		// Immediate Update
		OperationResult updateImmediately(SObject record);
		OperationResult updateImmediately(DML.Record record);
		OperationResult updateImmediately(List<SObject> records);
		OperationResult updateImmediately(DML.Records records);
		// Immediate Upsert
		OperationResult upsertImmediately(SObject record);
		OperationResult upsertImmediately(DML.Record record);
		OperationResult upsertImmediately(List<SObject> records);
		OperationResult upsertImmediately(DML.Records records);
		// Immediate Delete
		OperationResult deleteImmediately(Id recordId);
		OperationResult deleteImmediately(SObject record);
		OperationResult deleteImmediately(Iterable<Id> recordIds);
		OperationResult deleteImmediately(List<SObject> records);
		// Immediate Undelete
		OperationResult undeleteImmediately(Id recordId);
		OperationResult undeleteImmediately(SObject record);
		OperationResult undeleteImmediately(Iterable<Id> recordIds);
		OperationResult undeleteImmediately(List<SObject> records);
		// Immediate Publish
		OperationResult publishImmediately(SObject record);
		OperationResult publishImmediately(List<SObject> records);
		// Mocking
		Commitable identifier(String dmlIdentifier); // used for mocking and tracking results
		// Debug
		void preview();
		// Field Level Security
		Commitable userMode();
		Commitable systemMode();
		// Sharing Mode
		Commitable withSharing();
		Commitable withoutSharing();
		// Other configs
		Commitable allowPartialSuccess();
		Commitable skipDuplicateRules();
		Commitable options(Database.DmlOptions options);
		Commitable discardWork();
		Commitable commitHook(DML.Hook callback);
		Commitable combineOnDuplicate();
		// Save
		Result dryRun();
		Result commitWork();
		Result commitTransaction(); // make a savepoint and rollback on exception
	}

	global interface Record {
		Record with(SObjectField field, Object value); 
		Record withRelationship(SObjectField targetField, SObject relatedRecord);
		Record withRelationship(SObjectField targetField, SObjectField relatedObjectExternalIdField, Object relatedRecordExternalId);

		// for internal use only
		EnhancedRecord get();
		SObjectType getSObjectType();
	}

	global interface Records {
		Records with(SObjectField field, Object value); 
		Records withRelationship(SObjectField targetField, SObject relatedRecord);
		Records withRelationship(SObjectField targetField, SObjectField relatedObjectExternalIdField, Object relatedRecordExternalId);
		
		// for internal use only
		List<Record> get();
		SObjectType getSObjectType();
	}

	global interface Result {
		List<OperationResult> all();
		// Per Operation
		List<OperationResult> inserts();
		List<OperationResult> updates();
		List<OperationResult> upserts();
		List<OperationResult> deletes();
		List<OperationResult> undeletes();
		List<OperationResult> merges();
		List<OperationResult> events();
		// Per Object OperationType
		OperationResult insertsOf(Schema.SObjectType objectType);
		OperationResult updatesOf(Schema.SObjectType objectType);
		OperationResult upsertsOf(Schema.SObjectType objectType);
		OperationResult deletesOf(Schema.SObjectType objectType);
		OperationResult undeletesOf(Schema.SObjectType objectType);
		OperationResult mergesOf(Schema.SObjectType objectType);
		OperationResult eventsOf(Schema.SObjectType objectType);
	}

	global interface OperationResult {
		// Metadata
		DML.OperationType operationType();
		Schema.SObjectType objectType();
		Boolean hasFailures();
		// Errors
		List<Error> errors();
		// Records
		List<SObject> records();
		List<SObject> successes();
		List<SObject> failures();
		// Details
		List<RecordResult> recordResults();
	}

	global interface RecordResult {
		Id id();
		SObject record();
		Boolean isSuccess();
		List<Error> errors();
	}

	global interface Error {
		String message();
		System.StatusCode statusCode();
		List<String> fields();
	}

	// Mocking

	global static DML.Mockable mock(String dmlIdentifier) {
		if (!dmlIdentifierToMock.containsKey(dmlIdentifier)) {
			dmlIdentifierToMock.put(dmlIdentifier, new DmlMock());
		}
		return dmlIdentifierToMock.get(dmlIdentifier);
	}

	global static DML.Result retrieveResultFor(String dmlIdentifier) {
		if (!dmlIdentifierToResult.containsKey(dmlIdentifier)) {
			throw new DmlException('No result found for dml identifier: ' + dmlIdentifier);
		}
		return dmlIdentifierToResult.get(dmlIdentifier);
	}

	global interface Mockable {
		Mockable allDmls();
		// Per Operation
		Mockable allInserts();
		Mockable allUpdates();
		Mockable allUpserts();
		Mockable allDeletes();
		Mockable allUndeletes();
		Mockable allMerges();
		Mockable allPublishes();
		// Per Object OperationType
		Mockable insertsFor(SObjectType objectType);
		Mockable updatesFor(SObjectType objectType);
		Mockable upsertsFor(SObjectType objectType);
		Mockable deletesFor(SObjectType objectType);
		Mockable undeletesFor(SObjectType objectType);
		Mockable mergesFor(SObjectType objectType);
		Mockable publishesFor(SObjectType objectType);
		// Errors
		Mockable exceptionOnInserts();
		Mockable exceptionOnUpdates();
		Mockable exceptionOnUpserts();
		Mockable exceptionOnDeletes();
		Mockable exceptionOnUndeletes();
		Mockable exceptionOnMerges();
		Mockable exceptionOnPublishes();
		// Per Operation Type Per Object Type
		Mockable exceptionOnInsertsFor(SObjectType objectType);
		Mockable exceptionOnUpdatesFor(SObjectType objectType);
		Mockable exceptionOnUpsertsFor(SObjectType objectType);
		Mockable exceptionOnDeletesFor(SObjectType objectType);
		Mockable exceptionOnUndeletesFor(SObjectType objectType);
		Mockable exceptionOnMergesFor(SObjectType objectType);
		Mockable exceptionOnPublishesFor(SObjectType objectType);
	}

	// Hooks

	global interface Hook {
		void before();
		void after(Result result);
	}

	// Implementation

	global enum OperationType { INSERT_DML, UPSERT_DML, UPDATE_DML, MERGE_DML, DELETE_DML, UNDELETE_DML, PUBLISH_DML }

	private Configuration configuration;
	private CommandsStorage commandsStorage;
	private DependencyOrchestrator dependencyOrchestrator;
	private LinearOrchestrator linearOrchestrator;

	private Hook hook = null;

	@TestVisible
	private static final RandomIdGenerator randomIdGenerator = new RandomIdGenerator();
	private static final Map<String, Result> dmlIdentifierToResult = new Map<String, Result>();
	private static final Map<String, DmlMock> dmlIdentifierToMock = new Map<String, DmlMock>();

	global DML() {
		this.configuration = new Configuration();
		this.commandsStorage = new CommandsStorage();
		this.dependencyOrchestrator = new DependencyOrchestrator();
		this.linearOrchestrator = new LinearOrchestrator(this.configuration);
	}

	global DML(List<SObjectType> customExecutionOrder) {
		this();
		this.configuration.executionOrder(customExecutionOrder);
	}
	
	// Insert

	global Commitable toInsert(SObject record) {
		return this.toInsert(Record(record));
	}

	global Commitable toInsert(Record record) {
		return this.registerInDependencyOrchestrator(this.getInsertCommand(record.getSObjectType()), record);
	}

	global Commitable toInsert(List<SObject> records) {
		return this.toInsert(Records(records));
	}
	
	global Commitable toInsert(Records records) {
		return this.registerInDependencyOrchestrator(this.getInsertCommand(records.getSObjectType()), records);
	}

	global OperationResult insertImmediately(SObject record) {
		return this.insertImmediately(Record(record));
	}

	global OperationResult insertImmediately(Record record) {
		return this.executeImmediately(this.getInsertCommand(record.getSObjectType()), record);
	}

	global OperationResult insertImmediately(List<SObject> records) {
		return this.insertImmediately(Records(records));
	}

	global OperationResult insertImmediately(Records records) {
		return this.executeImmediately(this.getInsertCommand(records.getSObjectType()), records);
	}

	private InsertCommand getInsertCommand(SObjectType objectType) {
		return new InsertCommand(objectType, this.configuration);
	}

	// Update
	
	global Commitable toUpdate(SObject record) {
		return this.toUpdate(Record(record));
	}

	global Commitable toUpdate(Record record) {
		return this.registerInLinearOrchestrator(this.getUpdateCommand(record.getSObjectType()), record);
	}

	global Commitable toUpdate(List<SObject> records) {
		return this.toUpdate(Records(records));
	}

	global Commitable toUpdate(Records records) {
		return this.registerInLinearOrchestrator(this.getUpdateCommand(records.getSObjectType()), records);
	}

	global OperationResult updateImmediately(SObject record) {
		return this.updateImmediately(Record(record));
	}

	global OperationResult updateImmediately(Record record) {
		return this.executeImmediately(this.getUpdateCommand(record.getSObjectType()), record);
	}

	global OperationResult updateImmediately(List<SObject> records) {
		return this.updateImmediately(Records(records));
	}

	global OperationResult updateImmediately(Records records) {
		return this.executeImmediately(this.getUpdateCommand(records.getSObjectType()), records);
	}

	private UpdateCommand getUpdateCommand(SObjectType objectType) {
		return new UpdateCommand(objectType, this.configuration);
	}

	// Upsert

	global Commitable toUpsert(SObject record) {
		return this.toUpsert(Record(record));
	}

	global Commitable toUpsert(SObject record, SObjectField externalIdField) {
		return this.registerInDependencyOrchestrator(this.getUpsertCommand(record.getSObjectType()).withExternalIdField(externalIdField), Record(record));
	}

	global Commitable toUpsert(Record record) {
		return this.registerInDependencyOrchestrator(this.getUpsertCommand(record.getSObjectType()), record);
	}

	global Commitable toUpsert(List<SObject> records) {
		return this.toUpsert(Records(records));
	}

	global Commitable toUpsert(List<SObject> records, SObjectField externalIdField) {
		return this.registerInDependencyOrchestrator(this.getUpsertCommand(records.getSObjectType()).withExternalIdField(externalIdField), Records(records));
	}

	global Commitable toUpsert(Records records) {
		return this.registerInDependencyOrchestrator(this.getUpsertCommand(records.getSObjectType()), records);
	}

	global OperationResult upsertImmediately(SObject record) {
		return this.upsertImmediately(Record(record));
	}

	global OperationResult upsertImmediately(Record record) {
		return this.executeImmediately(this.getUpsertCommand(record.getSObjectType()), record);
	}

	global OperationResult upsertImmediately(List<SObject> records) {
		return this.upsertImmediately(Records(records));
	}

	global OperationResult upsertImmediately(Records records) {
		return this.executeImmediately(this.getUpsertCommand(records.getSObjectType()), records);
	}

	private UpsertCommand getUpsertCommand(SObjectType objectType) {
		return new UpsertCommand(objectType, this.configuration);
	}

	// Delete

	global Commitable toDelete(Id recordId) {
		return this.toDelete(Record(recordId));
	}

	global Commitable toDelete(SObject record) {
		return this.toDelete(Record(record));
	}

	private Commitable toDelete(Record record) {
		return this.registerInLinearOrchestrator(this.getDeleteCommand(record.getSObjectType()), record);
	}

	global Commitable toDelete(Iterable<Id> recordIds) {
		return this.toDelete(Records(recordIds));
	}

	global Commitable toDelete(List<SObject> records) {
		return this.toDelete(Records(records));
	}

	private Commitable toDelete(Records records) {
		return this.registerInLinearOrchestrator(this.getDeleteCommand(records.getSObjectType()), records);
	}

	global OperationResult deleteImmediately(Id recordId) {
		return this.deleteImmediately(Record(recordId));
	}

	global OperationResult deleteImmediately(SObject record) {
		return this.deleteImmediately(Record(record));
	}

	private OperationResult deleteImmediately(Record record) {
		return this.executeImmediately(this.getDeleteCommand(record.getSObjectType()), record);
	}

	global OperationResult deleteImmediately(Iterable<Id> recordIds) {
		return this.deleteImmediately(Records(recordIds));
	}

	global OperationResult deleteImmediately(List<SObject> records) {
		return this.deleteImmediately(Records(records));
	}

	private OperationResult deleteImmediately(Records records) {
		return this.executeImmediately(this.getDeleteCommand(records.getSObjectType()), records);
	}

	private DeleteCommand getDeleteCommand(SObjectType objectType) {
		return new DeleteCommand(objectType, this.configuration);
	}

	// Hard Delete

	global Commitable toHardDelete(Id recordId) {
		Record dmlRecord = Record(recordId);
		return this.registerInLinearOrchestrator(this.getDeleteCommand(dmlRecord.getSObjectType()).withHardDelete(), dmlRecord);

	}

	global Commitable toHardDelete(SObject record) {
		Record dmlRecord = Record(record);
		return this.registerInLinearOrchestrator(this.getDeleteCommand(dmlRecord.getSObjectType()).withHardDelete(), dmlRecord);
	}

	global Commitable toHardDelete(Iterable<Id> recordIds) {
		Records dmlRecords = Records(recordIds);
		return this.registerInLinearOrchestrator(this.getDeleteCommand(dmlRecords.getSObjectType()).withHardDelete(), dmlRecords);
	}

	global Commitable toHardDelete(List<SObject> records) {
		Records dmlRecords = Records(records);
		return this.registerInLinearOrchestrator(this.getDeleteCommand(dmlRecords.getSObjectType()).withHardDelete(), dmlRecords);
	}

	// Undelete

	global Commitable toUndelete(Id recordId) {
		return this.toUndelete(Record(recordId));
	}

	global Commitable toUndelete(SObject record) {
		return this.toUndelete(Record(record));
	}

	private Commitable toUndelete(Record record) {
		return this.registerInLinearOrchestrator(this.getUndeleteCommand(record.getSObjectType()), record);
	}

	global Commitable toUndelete(Iterable<Id> recordIds) {
		return this.toUndelete(Records(recordIds));
	}

	global Commitable toUndelete(List<SObject> records) {
		return this.toUndelete(Records(records));
	}

	private Commitable toUndelete(Records records) {
		return this.registerInLinearOrchestrator(this.getUndeleteCommand(records.getSObjectType()), records);
	}

	global OperationResult undeleteImmediately(Id recordId) {
		return this.undeleteImmediately(Record(recordId));
	}

	global OperationResult undeleteImmediately(SObject record) {
		return this.undeleteImmediately(Record(record));
	}

	private OperationResult undeleteImmediately(Record record) {
		return this.executeImmediately(this.getUndeleteCommand(record.getSObjectType()), record);
	}

	global OperationResult undeleteImmediately(Iterable<Id> recordIds) {
		return this.undeleteImmediately(Records(recordIds));
	}

	global OperationResult undeleteImmediately(List<SObject> records) {
		return this.undeleteImmediately(Records(records));
	}

	private OperationResult undeleteImmediately(Records records) {
		return this.executeImmediately(this.getUndeleteCommand(records.getSObjectType()), records);
	}

	private UndeleteCommand getUndeleteCommand(SObjectType objectType) {
		return new UndeleteCommand(objectType, this.configuration);
	}

	// Merge

	global Commitable toMerge(SObject mergeToRecord, SObject duplicatedRecord) {
		Record dmlMergeToRecord = Record(mergeToRecord);
		return this.toMerge(dmlMergeToRecord.getSObjectType(), this.configuration, dmlMergeToRecord, Record(duplicatedRecord));
	}

	global Commitable toMerge(SObject mergeToRecord, Id duplicatedRecordId) {
		Record dmlMergeToRecord = Record(mergeToRecord);
		return this.toMerge(dmlMergeToRecord.getSObjectType(), this.configuration, dmlMergeToRecord, Record(duplicatedRecordId));
	}

	private Commitable toMerge(SObjectType objectType, Configuration configuration, Record mergeToRecord, Record duplicatedRecord) {
		return this.registerInLinearOrchestrator(this.getMergeCommand(objectType, configuration, mergeToRecord), duplicatedRecord);
	}

	global Commitable toMerge(SObject mergeToRecord, List<SObject> duplicateRecords) {
		Record dmlMergeToRecord = Record(mergeToRecord);
		return this.toMerge(dmlMergeToRecord.getSObjectType(), this.configuration, dmlMergeToRecord, Records(duplicateRecords));
	}

	global Commitable toMerge(SObject mergeToRecord, Iterable<Id> duplicatedRecordIds) {
		Record dmlMergeToRecord = Record(mergeToRecord);
		return this.toMerge(dmlMergeToRecord.getSObjectType(), this.configuration, dmlMergeToRecord, Records(duplicatedRecordIds));
	}

	private Commitable toMerge(SObjectType objectType, Configuration configuration, Record mergeToRecord, Records duplicateRecords) {
		return this.registerInLinearOrchestrator(this.getMergeCommand(objectType, configuration, mergeToRecord), duplicateRecords);
	}

	private MergeCommand getMergeCommand(SObjectType objectType, Configuration configuration, Record mergeToRecord) {
		return new MergeCommand(objectType, configuration, mergeToRecord);
	}

	// Platform Event

	global Commitable toPublish(SObject record) {
		Record dmlRecord = Record(record);
		return this.registerInLinearOrchestrator(this.getPlatformEventCommand(dmlRecord.getSObjectType()), dmlRecord);
	}

	global Commitable toPublish(List<SObject> records) {
		Records dmlRecords = Records(records);
		return this.registerInLinearOrchestrator(this.getPlatformEventCommand(dmlRecords.getSObjectType()), dmlRecords);
	}

	global OperationResult publishImmediately(SObject record) {
		Record dmlRecord = Record(record);
		return this.executeImmediately(this.getPlatformEventCommand(dmlRecord.getSObjectType()), dmlRecord);
	}

	global OperationResult publishImmediately(List<SObject> records) {
		Records dmlRecords = Records(records);
		return this.executeImmediately(this.getPlatformEventCommand(dmlRecords.getSObjectType()), dmlRecords);
	}

	private PlatformEventCommand getPlatformEventCommand(SObjectType objectType) {
		return new PlatformEventCommand(objectType, this.configuration);
	}

	// Helpers

	private OperationResult executeImmediately(DmlStrategy command, Record record) {
		DmlStrategy existing = this.commandsStorage.intern(command);
		return existing.execute(new List<EnhancedRecord>{ record.get() });
	}

	private OperationResult executeImmediately(DmlStrategy command, Records records) {
		DmlStrategy existing = this.commandsStorage.intern(command);
		return existing.execute(records);
	}

	private Commitable registerInDependencyOrchestrator(DmlStrategy command, Record record) {
		DmlStrategy existing = this.commandsStorage.intern(command);
		this.dependencyOrchestrator.register(existing, record);
		return this;
	}

	private Commitable registerInDependencyOrchestrator(DmlStrategy command, Records records) {
		DmlStrategy existing = this.commandsStorage.intern(command);
		this.dependencyOrchestrator.register(existing, records);
		return this;
	}

	private Commitable registerInLinearOrchestrator(DmlStrategy command, Record record) {
		DmlStrategy existing = this.commandsStorage.intern(command);
		this.linearOrchestrator.register(existing, record);
		return this;
	}

	private Commitable registerInLinearOrchestrator(DmlStrategy command, Records records) {
		DmlStrategy existing = this.commandsStorage.intern(command);
		this.linearOrchestrator.register(existing, records);
		return this;
	}

	// Identifier

	global Commitable identifier(String dmlIdentifier) {
		this.configuration.identifier(dmlIdentifier);
		return this;
	}

	// Debug

	global void preview() {
		this.configuration.preview();
		// this.orchestrator.preview(); TODO
	}

	// Field Level Security

	global Commitable userMode() {
		return this.setAccessMode(System.AccessLevel.USER_MODE);
	}

	global Commitable systemMode() {
		return this.setAccessMode(System.AccessLevel.SYSTEM_MODE);
	}

	private Commitable setAccessMode(System.AccessLevel accessMode) {
		this.configuration.accessMode(accessMode);
		return this;
	}

	// Sharing Mode

	global Commitable withSharing() {
		this.configuration.withSharing();
		return this;
	}

	global Commitable withoutSharing() {
		this.configuration.withoutSharing();
		return this;
	}

	// Other configs

	global Commitable allowPartialSuccess() {
		this.configuration.allowPartialSuccess();
		return this;
	}

	global Commitable skipDuplicateRules() {
		this.configuration.skipDuplicateRules();
		return this;
	}

	global Commitable combineOnDuplicate() {
		this.configuration.combineOnDuplicate();
		return this;
	}

	global Commitable options(Database.DmlOptions options) {
		this.configuration.options(options);
		return this;
	}

	global Commitable discardWork() {
		this.reset();
		return this;
	}

	// Hooks

	global Commitable commitHook(Hook callback) {
		this.hook = callback;
		return this;
	}

	global Result dryRun() {
		Savepoint savePoint = Database.setSavepoint();

		try {
			DMLResult result = new DmlResult();

			this.hook?.before();

			this.dependencyOrchestrator.execute(result);
			this.linearOrchestrator.execute(result);

			this.hook?.after(result);

			return result;
		} finally {
			Database.rollback(savePoint);
			Database.releaseSavepoint(savePoint);
		}
	}

	global Result commitWork() {
		DMLResult result = new DmlResult();

		try {
			this.hook?.before();

			this.dependencyOrchestrator.execute(result);
			this.linearOrchestrator.execute(result);

			this.storeResult(result);

			this.hook?.after(result);
		} finally {
			this.reset();
		}

		return result;
	}

	private void storeResult(DMLResult result) {
		if (String.isBlank(this.configuration.dmlIdentifier)) {
			return;
		}

		dmlIdentifierToResult.put(this.configuration.dmlIdentifier, result);
	}

	global Result commitTransaction() {
		if (!this.configuration.allOrNone) {
			throw new DmlException('commitTransaction() is not supported when allOrNone=false');
		}

		Savepoint savePoint = Database.setSavepoint();

		try {
			return this.commitWork();
		} catch (Exception e) {
			Database.rollback(savePoint);
			throw e;
		} finally {
			Database.releaseSavepoint(savePoint);
		}
	}

	private void reset() {
		this.dependencyOrchestrator = new DependencyOrchestrator();
		this.linearOrchestrator = new LinearOrchestrator(this.configuration);
	}

	private class CommandsStorage {
		private Map<String, DmlStrategy> commandByHashCode = new Map<String, DmlStrategy>();

		private DmlStrategy intern(DmlStrategy candidate) {
			String commandHashCode = candidate.hashCode();

			DmlStrategy existing = this.commandByHashCode.get(commandHashCode);

			if (existing == null) {
				this.commandByHashCode.put(commandHashCode, candidate);
				return candidate;
			}

			return existing;
		}
	}

	private class DependencyOrchestrator { // TODO Insert, Upsert
		private List<EnhancedRecord> enhancedRecords = new List<EnhancedRecord>();

		private Map<Id, EnhancedRecord> enhancedRecordsById = new Map<Id, EnhancedRecord>();
		private OrderDependencyGraph orderDependencyGraph = new OrderDependencyGraph();

		private void register(DmlStrategy command, Records records) {
			for (Record record : records.get()) {
				this.register(command, record);
			}
		}

		private void register(DmlStrategy command, Record record) {
			EnhancedRecord enhancedRecord = record.get();

			command.validate(enhancedRecord);
			enhancedRecord.associateRecordWithCommand(command);

			this.enhancedRecords.add(enhancedRecord);
		}

		private void execute(DmlResult result) {

			for (EnhancedRecord enhancedRecord : this.enhancedRecords) {
				if (enhancedRecord.currentRecord.Id == null) {
					enhancedRecord.setTemporaryId(); // only to build dependency graph
				}

			    Id enhancedRecordId = enhancedRecord.getRecordId();
			
				this.enhancedRecordsById.put(enhancedRecordId, enhancedRecord);

				enhancedRecord.addToDependencyGraph(this.orderDependencyGraph);
			}

			List<List<Id>> executionWaves = this.orderDependencyGraph.computeExecutionWaves();

			for (List<Id> waveRecordIds : executionWaves) {
				for (ProcessingGroup processingGroup : this.getWaves(waveRecordIds)) {
					DmlStrategy command = processingGroup.command;
					result.add(command.getOperationType(), command.commitWork(processingGroup.records)); //TODO
				}
			}
		}

		private List<ProcessingGroup> getWaves(List<Id> enhancedRecordIds) {
			Map<String, ProcessingGroup> processingGroupsByCommandId = new Map<String, ProcessingGroup>();

			for (Id enhancedRecordId : enhancedRecordIds) {
				EnhancedRecord enhancedRecord = this.enhancedRecordsById.get(enhancedRecordId);

				if (enhancedRecord.hasTemporaryId) {
					enhancedRecord.currentRecord.Id = null; // TODO 
				}

				String commandId = enhancedRecord.command.hashCode();

				if (!processingGroupsByCommandId.containsKey(commandId)) {
					ProcessingGroup processingGroup = new ProcessingGroup();

					processingGroup.command = enhancedRecord.command;
					processingGroup.records = new List<EnhancedRecord>();

					processingGroupsByCommandId.put(commandId, processingGroup);
				}

				processingGroupsByCommandId.get(commandId).records.add(enhancedRecord);
			}

			return processingGroupsByCommandId.values();
		}
	}

	private class LinearOrchestrator { // TODO Update, Delete, Merge, Undelete, Publish
		private Map<Id, EnhancedRecord> enhancedRecordsById = new Map<Id, EnhancedRecord>();
		private Map<String, ProcessingGroup> processingGroupByCommandId = new Map<String, ProcessingGroup>();
		private Map<OperationType, List<ProcessingGroup>> processingGroupsByOperationType = new Map<OperationType, List<ProcessingGroup>>{
			OperationType.UPDATE_DML => new List<ProcessingGroup>(),
			OperationType.MERGE_DML => new List<ProcessingGroup>(),
			OperationType.DELETE_DML => new List<ProcessingGroup>(),
			OperationType.UNDELETE_DML => new List<ProcessingGroup>(),
			OperationType.PUBLISH_DML => new List<ProcessingGroup>()
		};

		private Configuration configuration;

		public LinearOrchestrator(Configuration configuration) {
			this.configuration = configuration;
		}

		private void register(DmlStrategy command, Records records) {
			for (Record record : records.get()) {
				this.register(command, record);
			}
		}

		private void register(DmlStrategy command, Record record) {
			command.validate(record.get());
			
			ProcessingGroup processingGroup = this.processingGroupByCommandId.get(command.hashCode()) ;

			EnhancedRecord enhancedRecord = record.get();

			Id enhancedRecordId = enhancedRecord.getRecordId();

			if (enhancedRecordId != null) {
				if (this.enhancedRecordsById.containsKey(enhancedRecordId)) {
					this.configuration.duplicateCombineStrategy.combine(this.enhancedRecordsById.get(enhancedRecordId), enhancedRecord);
				}

				this.enhancedRecordsById.put(enhancedRecordId, enhancedRecord);
			}

			// this.configuration.duplicateCombineStrategy.combine(existingCommand, command); // TODO

			if (processingGroup == null) {
				processingGroup = new ProcessingGroup();

				processingGroup.command = command;

				this.processingGroupByCommandId.put(command.hashCode(), processingGroup);
				this.processingGroupsByOperationType.get(command.getOperationType()).add(processingGroup);
			}


			processingGroup.add(enhancedRecord);
		}

		private void execute(DmlResult result) {
			for (OperationType operationType : this.processingGroupsByOperationType.keySet()) {
				for (ProcessingGroup processingGroup : this.processingGroupsByOperationType.get(operationType)) {
					result.add(operationType, processingGroup.command.commitWork(processingGroup.records)); // TODO command.execute(processingGroup.records)
				}
			}
		}
	}

	private class ProcessingGroup {
		private DmlStrategy command;
		private List<EnhancedRecord> records = new List<EnhancedRecord>(); // TODO replace with Set

		private void add(EnhancedRecord enhancedRecord) { // TODO Here combine strategy should be applied
			this.records.add(enhancedRecord);


		}
	}

	private class DmlResult implements Result {
		private Map<OperationType, Map<SObjectType, OperationResult>> operationResultsByObjectType = new Map<OperationType, Map<SObjectType, OperationResult>>();

		public DmlResult() {
			for (OperationType operationType : OperationType.values()) {
				this.operationResultsByObjectType.put(operationType, new Map<SObjectType, OperationResult>());
			}
		}

		public DmlResult add(OperationType operationType, OperationResult result) {
			this.operationResultsByObjectType.get(operationType).put(result.objectType(), result);
			return this;
		}

		public List<OperationResult> inserts() {
			return this.getOperationResults(OperationType.INSERT_DML);
		}

		public List<OperationResult> updates() {
			return this.getOperationResults(OperationType.UPDATE_DML);
		}

		public List<OperationResult> upserts() {
			return this.getOperationResults(OperationType.UPSERT_DML);
		}

		public List<OperationResult> deletes() {
			return this.getOperationResults(OperationType.DELETE_DML);
		}

		public List<OperationResult> undeletes() {
			return this.getOperationResults(OperationType.UNDELETE_DML);
		}

		public List<OperationResult> merges() {
			return this.getOperationResults(OperationType.MERGE_DML);
		}

		public List<OperationResult> events() {
			return this.getOperationResults(OperationType.PUBLISH_DML);
		}

		public OperationResult insertsOf(SObjectType objectType) {
			return this.getOperationResult(OperationType.INSERT_DML, objectType);
		}

		public OperationResult updatesOf(SObjectType objectType) {
			return this.getOperationResult(OperationType.UPDATE_DML, objectType);
		}

		public OperationResult upsertsOf(SObjectType objectType) {
			return this.getOperationResult(OperationType.UPSERT_DML, objectType);
		}

		public OperationResult deletesOf(SObjectType objectType) {
			return this.getOperationResult(OperationType.DELETE_DML, objectType);
		}

		public OperationResult undeletesOf(SObjectType objectType) {
			return this.getOperationResult(OperationType.UNDELETE_DML, objectType);
		}

		public OperationResult mergesOf(SObjectType objectType) {
			return this.getOperationResult(OperationType.MERGE_DML, objectType);
		}

		public OperationResult eventsOf(SObjectType objectType) {
			return this.getOperationResult(OperationType.PUBLISH_DML, objectType);
		}

		private List<OperationResult> getOperationResults(OperationType operationType) {
			return this.operationResultsByObjectType.get(operationType).values();
		}

		private OperationResult getOperationResult(OperationType operationType, SObjectType objectType) {
			return this.operationResultsByObjectType.get(operationType).get(objectType) ?? new OperationSummary(objectType, operationType);
		}

		public List<OperationResult> all() {
			List<OperationResult> allResults = new List<OperationResult>();

			for (OperationType operationType : this.operationResultsByObjectType.keySet()) {
				allResults.addAll(this.operationResultsByObjectType.get(operationType).values());
			}

			return allResults;
		}
	}

	private class Configuration {
		private List<SObjectType> customExecutionOrder = new List<SObjectType>();
		private System.AccessLevel accessMode = System.AccessLevel.USER_MODE;
		private Database.DmlOptions options = new Database.DMLOptions();
		private DmlSharing sharingExecutor = new InheritedSharing();
		private DuplicateCombineStrategy duplicateCombineStrategy = new ThrownExceptionDuplicateStrategy();
		private Boolean allOrNone = true;
		private String dmlIdentifier = null;

		public Configuration() {
			this.options.optAllOrNone = true;
		}

		public void accessMode(System.AccessLevel accessMode) {
			this.accessMode = accessMode;
		}

		public void withSharing() {
			this.sharingExecutor = new WithSharing();
		}

		public void withoutSharing() {
			this.sharingExecutor = new WithoutSharing();
		}

		public void executionOrder(List<SObjectType> customExecutionOrder) {
			this.customExecutionOrder = customExecutionOrder;
		}

		public void identifier(String dmlIdentifier) {
			this.dmlIdentifier = dmlIdentifier;
		}

		public void allowPartialSuccess() {
			this.allOrNone = false;
			this.options.optAllOrNone = false;
		}

		public void combineOnDuplicate() {
			this.duplicateCombineStrategy = new MergeDuplicateStrategy();
		}

		public void options(Database.DmlOptions options) {
			this.options = options;
			this.options.optAllOrNone = this.options.optAllOrNone ?? this.allOrNone ?? true;
		}

		public void preview() {
			System.debug(LoggingLevel.ERROR, 
				'\n\n============ DML Configuration ============' +
				'\nCustom Execution Order: ' + this.customExecutionOrder +
				'\nOptions: ' + JSON.serializePretty(this.options) +
				'\nSharing Executor: ' + String.valueOf(this.sharingExecutor).split(':')[0] +
				'\nAll Or None: ' + this.allOrNone +
				'\nDML Identifier: ' + this.dmlIdentifier +
				'\n=======================================\n'
			);	
		}

		public void skipDuplicateRules() {
			this.options.duplicateRuleHeader.allowSave = true;
		}
	}

	private class DmlCommandComparator implements System.Comparator<DmlStrategy> {		
		private List<SObjectType> sobjectExecutionOrder;

		public DmlCommandComparator(List<SObjectType> sobjectExecutionOrder) {
			this.sobjectExecutionOrder = sobjectExecutionOrder;
		}
	
		public Integer compare(DmlStrategy a, DmlStrategy b) {
			return this.sobjectExecutionOrder.indexOf(a.getObjectType()) - this.sobjectExecutionOrder.indexOf(b.getObjectType());
		}
	}

	private abstract class DmlStrategy {
		private SObjectType objectType;
		private Configuration globalConfiguration;

		public DmlStrategy(SObjectType objectType, Configuration configuration) {
			this.objectType = objectType;
			this.globalConfiguration = configuration;
		}

		private void preview() {
			System.debug(LoggingLevel.ERROR,
				'\n\n============ ' + this.getOperationType() + ' Preview ============'
				+ '\nObject Type: ' + this.objectType
				+ '\n=======================================\n'
			);
		}

		private void validateCustomExecutionOrder() {
			if (this.globalConfiguration.customExecutionOrder.isEmpty()) {
				return;
			}

			if (!this.globalConfiguration.customExecutionOrder.contains(this.getObjectType())) {
				throw new DmlException('Only the following types can be registered: ' + this.globalConfiguration.customExecutionOrder);
			}
		}

		private SObjectType getObjectType() {
			return this.objectType;
		}

		private OperationResult commitWork(Record record) {
			return this.commitWork(new List<EnhancedRecord>{ record.get() });
		}

		private OperationResult commitWork(Records records) {
			List<EnhancedRecord> enhancedRecords = new List<EnhancedRecord>();
			for (Record record : records.get()) {
				enhancedRecords.add(record.get());
			}
			return this.commitWork(enhancedRecords);
		}

		private OperationResult commitWork(List<EnhancedRecord> records) {
			return this.globalConfiguration.sharingExecutor.execute(this, records);
		}

		private OperationResult execute(Record record) {
			return this.execute(new List<EnhancedRecord>{ record.get() });
		}

		private OperationResult execute(Records records) {
			List<EnhancedRecord> enhancedRecords = new List<EnhancedRecord>();

			for (Record record : records.get()) {
				enhancedRecords.add(record.get());
			}
			System.debug('========> execute: ' + enhancedRecords);
			return this.execute(enhancedRecords);
		}

		private OperationResult execute(List<EnhancedRecord> records) {
			List<SObject> recordsToProcess = this.getRecordsToProcess(records);

			OperationSummary operationSummary = new OperationSummary(this.objectType, this.getOperationType()).setRecords(recordsToProcess);

			DmlMock dmlMock = dmlIdentifierToMock.get(this.globalConfiguration.dmlIdentifier);

			if (dmlMock != null && dmlMock.shouldBeMocked(this.getOperationType(), this.objectType)) {
				return operationSummary.setRecordResults(dmlMock.getMockedRecordResults(this, recordsToProcess));
			}

			return operationSummary.setRecordResults(this.getAdapter().get(this.executeDml(recordsToProcess), recordsToProcess));
		}
		
		private List<SObject> getRecordsToProcess(List<EnhancedRecord> records) {
			List<SObject> recordsToProcess = new List<SObject>();

			for (EnhancedRecord enhancedRecord : records) {
				enhancedRecord.resolveRecordRelationships();
				recordsToProcess.add(enhancedRecord.getRecord());
			}

			return recordsToProcess;
		}

		protected abstract OperationType getOperationType();
		protected abstract DmlResultAdapter getAdapter();
		protected abstract List<Object> executeDml(List<SObject> recordsToProcess);
		protected abstract RecordSummary executeMockedDml(SObject record);

		protected virtual void validate(EnhancedRecord enhancedRecord) {
			return;
		}

		protected virtual String hashCode() {
			return this.getOperationType().name() + '_' + (this.getObjectType()?.toString() ?? 'EMPTY');
		}
	}

	// Commands

	private inherited sharing class InsertCommand extends DmlStrategy {
		public InsertCommand(SObjectType objectType, Configuration configuration) {
			super(objectType, configuration);
		}

		protected override OperationType getOperationType() {
			return OperationType.INSERT_DML;
		}

		public override DmlResultAdapter getAdapter() {
			return new SaveResultAdapter();
		}

		protected override void validate(EnhancedRecord enhancedRecord) {
			if (enhancedRecord.hasId()) {
				throw new DmlException('Only new records can be registered as new.');
			}
		}

		protected override List<Object> executeDml(List<SObject> recordsToProcess) {
			return Database.insert(recordsToProcess, this.globalConfiguration.options, this.globalConfiguration.accessMode);
		}

		protected override RecordSummary executeMockedDml(SObject record) {
			record.put('Id', randomIdGenerator.get(record.getSObjectType()));
			return new RecordSummary().isSuccess(true).recordId(record.Id);
		}
	}

	private inherited sharing class UpsertCommand extends DmlStrategy {
		private SObjectField externalIdField;

		public UpsertCommand(SObjectType objectType, Configuration configuration) {
			super(objectType, configuration);
		}

		private UpsertCommand withExternalIdField(SObjectField externalIdField) {
			this.externalIdField = externalIdField;
			return this;
		}

		protected override String hashCode() {
			String externalId = this.externalIdField == null ? 'Id' : this.externalIdField.toString();
			return super.hashCode() + '_' + externalId;
		}

		protected override OperationType getOperationType() {
			return OperationType.UPSERT_DML;
		}

		protected override DmlResultAdapter getAdapter() {
			return new UpsertResultAdapter();
		}

		protected override List<Object> executeDml(List<SObject> recordsToProcess) {
			if (this.externalIdField == null) {
				return Database.upsert(recordsToProcess, this.globalConfiguration.allOrNone, this.globalConfiguration.accessMode);
			}

			return Database.upsert(recordsToProcess, this.externalIdField, this.globalConfiguration.allOrNone, this.globalConfiguration.accessMode);
		}

		protected override RecordSummary executeMockedDml(SObject record) {
			if (record.Id == null) {
				record.put('Id', randomIdGenerator.get(record.getSObjectType()));
			}
			return new RecordSummary().isSuccess(true).recordId(record.Id);
		}
	}

	private inherited sharing class UpdateCommand extends DmlStrategy {
		public UpdateCommand(SObjectType objectType, Configuration configuration) {
			super(objectType, configuration);
		}

		protected override OperationType getOperationType() {
			return OperationType.UPDATE_DML;
		}

		protected override DmlResultAdapter getAdapter() {
			return new SaveResultAdapter();
		}

		protected override void validate(EnhancedRecord enhancedRecord) {
			if (!enhancedRecord.hasId()) {
				throw new DmlException('Only existing records can be updated.');
			}
		}

		protected override List<Object> executeDml(List<SObject> recordsToProcess) {
			return Database.update(recordsToProcess, this.globalConfiguration.options, this.globalConfiguration.accessMode);
		}

		protected override RecordSummary executeMockedDml(SObject record) {
			return new RecordSummary().isSuccess(true).recordId(record.Id);
		}
	}

	private inherited sharing class MergeCommand extends DmlStrategy {
		private EnhancedRecord mergeToRecord;

		public MergeCommand(SObjectType objectType, Configuration configuration, Record mergeToRecord) {
			super(objectType, configuration);
			this.mergeToRecord = mergeToRecord.get();
		}

		protected override String hashCode() {
			return super.hashCode() + '_' + this.mergeToRecord.getRecordId();
		}

		protected override OperationType getOperationType() {
			return OperationType.MERGE_DML;
		}

		protected override DmlResultAdapter getAdapter() {
			return new MergeResultAdapter();
		}

		protected override void validate(EnhancedRecord enhancedRecord) {
			if (!mergeToRecord.hasId()) {
				throw new DmlException('Only existing records can be merged.');
			}
		}

		protected override List<Object> executeDml(List<SObject> recordsToProcess) {
			return Database.merge(this.mergeToRecord.getRecord(), recordsToProcess, this.globalConfiguration.allOrNone, this.globalConfiguration.accessMode);
		}

		protected override RecordSummary executeMockedDml(SObject record) {
			// if (this.duplicateRecords.isEmpty()) {
			// 	throw new DmlException('A single merge request must contain at least one record to merge, got none.');
			// }
			return new RecordSummary().isSuccess(true).recordId(record.Id);
		}
	}

	private inherited sharing class DeleteCommand extends DmlStrategy {
		private Boolean makeHardDelete = false;

		public DeleteCommand(SObjectType objectType, Configuration configuration) {
			super(objectType, configuration);
		}

		private DeleteCommand withHardDelete() {
			this.makeHardDelete = true;
			return this;
		}
		
		protected override String hashCode() {
			return super.hashCode() + '_' + this.makeHardDelete;
		}

		protected override OperationType getOperationType() {
			return OperationType.DELETE_DML;
		}

		protected override DmlResultAdapter getAdapter() {
			return new DeleteResultAdapter();
		}

		protected override void validate(EnhancedRecord enhancedRecord) {
			if (!enhancedRecord.hasId()) {
				throw new DmlException('Only existing records can be registered as deleted.');
			}
		}

		protected override List<Object> executeDml(List<SObject> recordsToProcess) {
			List<Object> dmlResults = Database.delete(recordsToProcess, this.globalConfiguration.allOrNone, this.globalConfiguration.accessMode);

			if (this.makeHardDelete) {
				System.Database.emptyRecycleBin(recordsToProcess);
			}

			return dmlResults;
		}

		protected override RecordSummary executeMockedDml(SObject record) {
			return new RecordSummary().isSuccess(true).recordId(record.Id);
		}
	}

	private inherited sharing class UndeleteCommand extends DmlStrategy {
		public UndeleteCommand(SObjectType objectType, Configuration configuration) {
			super(objectType, configuration);
		}

		protected override OperationType getOperationType() {
			return OperationType.UNDELETE_DML;
		}

		protected override DmlResultAdapter getAdapter() {
			return new UndeleteResultAdapter();
		}

		protected override void validate(EnhancedRecord enhancedRecord) {
			if (!enhancedRecord.hasId()) {
				throw new DmlException('Only deleted records can be undeleted.');
			}
		}

		protected override List<Object> executeDml(List<SObject> recordsToProcess) {
			return Database.undelete(recordsToProcess, this.globalConfiguration.allOrNone, this.globalConfiguration.accessMode);
		}

		protected override RecordSummary executeMockedDml(SObject record) {
			return new RecordSummary().isSuccess(true).recordId(record.Id);
		}
	}

	private inherited sharing class PlatformEventCommand extends DmlStrategy { 
		public PlatformEventCommand(SObjectType objectType, Configuration configuration) {
			super(objectType, configuration);
		}

		protected override OperationType getOperationType() {
			return OperationType.PUBLISH_DML;
		}

		protected override DmlResultAdapter getAdapter() {
			return new SaveResultAdapter();
		}

		protected override List<Object> executeDml(List<SObject> recordsToProcess) {
			return EventBus.publish(recordsToProcess);
		}

		protected override RecordSummary executeMockedDml(SObject record) {
			return new RecordSummary().isSuccess(true).recordId(randomIdGenerator.get(record.getSObjectType()));
		}
	}

	// Issuers

	private interface DmlSharing {
		OperationResult execute(DmlStrategy command, List<EnhancedRecord> records);
	}

	private inherited sharing class InheritedSharing implements DmlSharing {
		public OperationResult execute(DmlStrategy command, List<EnhancedRecord> records) {
			return command.execute(records);
		}
	}

	private without sharing class WithoutSharing implements DmlSharing {
		public OperationResult execute(DmlStrategy command, List<EnhancedRecord> records) {
			return command.execute(records);
		}
	}

	private with sharing class WithSharing implements DmlSharing {
		public OperationResult execute(DmlStrategy command, List<EnhancedRecord> records) {
			return command.execute(records);
		}
	}

	// Result Adapters

	private abstract class DmlResultAdapter {
		public List<RecordResult> get(List<Object> dmlResults, List<SObject> processedRecords) {
			List<RecordResult> recordResults = new List<RecordResult>();

			for (Integer i = 0; i < dmlResults.size(); i++) {
				recordResults.add(this.transform(dmlResults[i]).record(processedRecords[i]));
			}

			return recordResults;
		}
		
		protected abstract RecordSummary transform(Object result);
	}

	private class SaveResultAdapter extends DmlResultAdapter {
		public override RecordSummary transform(Object result) {
			Database.SaveResult saveResult = (Database.SaveResult) result;

			return new RecordSummary()
				.isSuccess(saveResult.isSuccess())
				.recordId(saveResult.getId())
				.errors(saveResult.getErrors());
		}
	}

	private class UpsertResultAdapter extends DmlResultAdapter {
		public override RecordSummary transform(Object result) {
			Database.UpsertResult upsertResult = (Database.UpsertResult) result;

			return new RecordSummary()
				.isSuccess(upsertResult.isSuccess())
				.recordId(upsertResult.getId())
				.errors(upsertResult.getErrors());
		}
	}

	private class MergeResultAdapter extends DmlResultAdapter {
		public override RecordSummary transform(Object result) {
			Database.MergeResult mergeResult = (Database.MergeResult) result;

			return new RecordSummary()
				.isSuccess(mergeResult.isSuccess())
				.recordId(mergeResult.getId())
				.errors(mergeResult.getErrors());
		}
	}

	private class DeleteResultAdapter extends DmlResultAdapter {
		public override RecordSummary transform(Object result) {
			Database.DeleteResult deleteResult = (Database.DeleteResult) result;

			return new RecordSummary()
				.isSuccess(deleteResult.isSuccess())
				.recordId(deleteResult.getId())
				.errors(deleteResult.getErrors());
		}
	}

	private class UndeleteResultAdapter extends DmlResultAdapter {
		public override RecordSummary transform(Object result) {
			Database.UndeleteResult undeleteResult = (Database.UndeleteResult) result;
			
			return new RecordSummary()
				.isSuccess(undeleteResult.isSuccess())
				.recordId(undeleteResult.getId())
				.errors(undeleteResult.getErrors());
		}
	}
	
	private interface DuplicateCombineStrategy {
		// void combine(DmlStrategy mergeToCommand, DmlStrategy duplicateCommand);
		void combine(EnhancedRecord mergeToRecord, EnhancedRecord duplicateRecord);
	}

	private class ThrownExceptionDuplicateStrategy implements DuplicateCombineStrategy {
		public void combine(EnhancedRecord mergeToRecord, EnhancedRecord duplicateRecord) {
			throw new DmlException('Duplicate records found during registration. Fix the code or use the combineOnDuplicate() method.');
		}
	}

	private class MergeDuplicateStrategy implements DuplicateCombineStrategy {
		public void combine(EnhancedRecord mergeToRecord, EnhancedRecord duplicateRecord) {
			SObject existingRecord = mergeToRecord.getRecord();
			SObject newRecord = duplicateRecord.getRecord();

			for (String field : newRecord.getPopulatedFieldsAsMap().keySet()) {
				existingRecord.put(field, newRecord.get(field));
			}
		}
	}

	private class OperationSummary implements OperationResult {
		private OperationType type;
		private SObjectType objectType;
		private List<RecordResult> recordResults = new List<RecordResult>();
		private List<SObject> records = new List<SObject>();

		private List<SObject> cachedSuccesses = new List<SObject>();
		private List<SObject> cachedFailures = new List<SObject>();
		private List<Error> cachedErrors = new List<Error>();

		private OperationSummary(SObjectType objectType, OperationType type) {
			this.objectType = objectType;
			this.type = type;
		}

		private OperationSummary setRecords(List<SObject> records) {
			this.records = records;
			return this;
		}

		private OperationSummary setRecordResults(List<RecordResult> recordResults) {
			this.recordResults = recordResults;
			this.flatResults();
			return this;
		}

		private void flatResults() {
			for (RecordResult recordResult : this.recordResults) {
				if (recordResult.isSuccess()) {
					this.cachedSuccesses.add(recordResult.record());
				} else {
					this.cachedErrors.addAll(recordResult.errors());
					this.cachedFailures.add(recordResult.record());
				}
			}
		}

		public SObjectType objectType() {
			return this.objectType;
		}

		public OperationType operationType() {
			return this.type;
		}

		public Boolean hasFailures() {
			return !this.failures().isEmpty();
		}

		public List<Error> errors() {
			return this.cachedErrors;
		}

		public List<SObject> records() {
			return this.records;
		}

		public List<SObject> successes() {
			return this.cachedSuccesses;
		}

		public List<SObject> failures() {
			return this.cachedFailures;
		}

		public List<RecordResult> recordResults() {
			return this.recordResults;
		}
	}

	private class RecordSummary implements RecordResult {
		private Id recordId;
		private SObject record;
		private Boolean isSuccess = false;
		private List<Error> errors = new List<Error>();

		public Id id() {
			return this.recordId;
		}

		public SObject record() {
			return this.record;
		}

		public Boolean isSuccess() {
			return this.isSuccess;
		}

		public List<Error> errors() {
			return this.errors;
		}

		private RecordSummary recordId(Id recordId) {
			this.recordId = recordId;
			return this;
		}

		private RecordSummary record(SObject record) {
			this.record = record;
			return this;
		}

		@SuppressWarnings('PMD.AvoidBooleanMethodParameters')
		private RecordSummary isSuccess(Boolean isSuccess) {
			this.isSuccess = isSuccess;
			return this;
		}

		private RecordSummary error(Error error) {
			this.errors.add(error);
			return this;
		}

		private RecordSummary errors(List<Database.Error> errors) {
			for (Database.Error error : errors ?? new List<Database.Error>()) {
				this.errors.add(new RecordProcessingError(error));
			}
			return this;
		}
	}

	private class RecordProcessingError implements Error {
		private String message;
		private System.StatusCode statusCode;
		private List<String> fields;

		private RecordProcessingError() {}

		private RecordProcessingError(Database.Error error) {
			this.message = error.getMessage();
			this.statusCode = error.getStatusCode();
			this.fields = error.getFields();
		}

		private RecordProcessingError setMessage(String message) {
			this.message = message;
			return this;
		}

		private RecordProcessingError setStatusCode(System.StatusCode statusCode) {
			this.statusCode = statusCode;
			return this;
		}

		private RecordProcessingError setFields(List<String> fields) {
			this.fields = fields;
			return this;
		}

		public String message() {
			return this.message;
		}

		public System.StatusCode statusCode() {
			return this.statusCode;
		}

		public List<String> fields() {
			return this.fields;
		}
	}

	private class DmlMock implements Mockable {
		private Set<OperationType> mockedDmlTypes = new Set<OperationType>();
		private Set<OperationType> thrownExceptionDmlTypes = new Set<OperationType>();

		private Map<OperationType, Set<SObjectType>> mockedObjectTypesByDmlType = new Map<OperationType, Set<SObjectType>>();
		private Map<OperationType, Set<SObjectType>> thrownExceptionDmlTypesByObjectTypes = new Map<OperationType, Set<SObjectType>>();

		public Mockable allDmls() {
			this.mockedDmlTypes.addAll(OperationType.values());
			return this;
		} 
		
		public Mockable allInserts() {
			return this.thenMockDml(OperationType.INSERT_DML);
		}

		public Mockable allUpdates() {
			return this.thenMockDml(OperationType.UPDATE_DML);
		}

		public Mockable allUpserts() {
			return this.thenMockDml(OperationType.UPSERT_DML);
		}

		public Mockable allDeletes() {
			return this.thenMockDml(OperationType.DELETE_DML);
		}

		public Mockable allUndeletes() {
			return this.thenMockDml(OperationType.UNDELETE_DML);
		}

		public Mockable allMerges() {
			return this.thenMockDml(OperationType.MERGE_DML);
		}

		public Mockable allPublishes() {
			return this.thenMockDml(OperationType.PUBLISH_DML);
		}

		public Mockable thenMockDml(OperationType dmlType) {
			this.mockedDmlTypes.add(dmlType);
			return this;
		}

		public Mockable insertsFor(SObjectType objectType) {
			return this.thenMockDmlFor(OperationType.INSERT_DML, objectType);
		}

		public Mockable updatesFor(SObjectType objectType) {
			return this.thenMockDmlFor(OperationType.UPDATE_DML, objectType);
		}

		public Mockable upsertsFor(SObjectType objectType) {
			return this.thenMockDmlFor(OperationType.UPSERT_DML, objectType);
		}

		public Mockable deletesFor(SObjectType objectType) {
			return this.thenMockDmlFor(OperationType.DELETE_DML, objectType);
		}

		public Mockable undeletesFor(SObjectType objectType) {
			return this.thenMockDmlFor(OperationType.UNDELETE_DML, objectType);
		}

		public Mockable mergesFor(SObjectType objectType) {
			return this.thenMockDmlFor(OperationType.MERGE_DML, objectType);
		}

		public Mockable publishesFor(SObjectType objectType) {
			return this.thenMockDmlFor(OperationType.PUBLISH_DML, objectType);
		}

		private Mockable thenMockDmlFor(OperationType dmlType, SObjectType objectType) {
			if (!this.mockedObjectTypesByDmlType.containsKey(dmlType)) {
				this.mockedObjectTypesByDmlType.put(dmlType, new Set<SObjectType>());
			}
			this.mockedObjectTypesByDmlType.get(dmlType).add(objectType);
			return this;
		}

		public Mockable exceptionOnInserts() {
			return this.thenExceptionOn(OperationType.INSERT_DML);
		}

		public Mockable exceptionOnUpdates() {
			return this.thenExceptionOn(OperationType.UPDATE_DML);
		}

		public Mockable exceptionOnUpserts() {
			return this.thenExceptionOn(OperationType.UPSERT_DML);
		}

		public Mockable exceptionOnDeletes() {
			return this.thenExceptionOn(OperationType.DELETE_DML);
		}

		public Mockable exceptionOnUndeletes() {
			return this.thenExceptionOn(OperationType.UNDELETE_DML);
		}

		public Mockable exceptionOnMerges() {
			return this.thenExceptionOn(OperationType.MERGE_DML);
		}

		public Mockable exceptionOnPublishes() {
			return this.thenExceptionOn(OperationType.PUBLISH_DML);
		}

		private Mockable thenExceptionOn(OperationType dmlType) {
			this.thrownExceptionDmlTypes.add(dmlType);
			return this;
		}

		public Mockable exceptionOnInsertsFor(SObjectType objectType) {
			return this.thenExceptionOnFor(OperationType.INSERT_DML, objectType);
		}

		public Mockable exceptionOnUpdatesFor(SObjectType objectType) {
			return this.thenExceptionOnFor(OperationType.UPDATE_DML, objectType);
		}

		public Mockable exceptionOnUpsertsFor(SObjectType objectType) {
			return this.thenExceptionOnFor(OperationType.UPSERT_DML, objectType);
		}

		public Mockable exceptionOnDeletesFor(SObjectType objectType) {
			return this.thenExceptionOnFor(OperationType.DELETE_DML, objectType);
		}

		public Mockable exceptionOnUndeletesFor(SObjectType objectType) {
			return this.thenExceptionOnFor(OperationType.UNDELETE_DML, objectType);
		}

		public Mockable exceptionOnMergesFor(SObjectType objectType) {
			return this.thenExceptionOnFor(OperationType.MERGE_DML, objectType);
		}

		public Mockable exceptionOnPublishesFor(SObjectType objectType) {
			return this.thenExceptionOnFor(OperationType.PUBLISH_DML, objectType);
		}

		private Mockable thenExceptionOnFor(OperationType dmlType, SObjectType objectType) {
			if (!this.thrownExceptionDmlTypesByObjectTypes.containsKey(dmlType)) {
				this.thrownExceptionDmlTypesByObjectTypes.put(dmlType, new Set<SObjectType>());
			}
			this.thrownExceptionDmlTypesByObjectTypes.get(dmlType).add(objectType);
			return this;
		}

		private Boolean shouldBeMocked(OperationType dmlType, SObjectType objectType) {
			return this.mockedDmlTypes.contains(dmlType) || (this.mockedObjectTypesByDmlType.get(dmlType) ?? new Set<SObjectType>()).contains(objectType) || this.shouldThrowException(dmlType, objectType);
		}

		private List<RecordResult> getMockedRecordResults(DmlStrategy command, List<SObject> recordsToProcess) {
			if (this.shouldThrowException(command.getOperationType(), command.getObjectType())) {
				if (command.globalConfiguration.allOrNone) {
					throw new DmlException('Exception thrown for ' + command.getOperationType() + ' operation.');
				}

				// all or none is false, so we need to return a list of record results with errors
				return this.getMockedRecordErrors(command, recordsToProcess);
			}

			return this.getMockedRecordSuccesses(command, recordsToProcess);
		}

		private List<RecordResult> getMockedRecordErrors(DmlStrategy command, List<SObject> recordsToProcess) {
			List<RecordResult> recordResults = new List<RecordResult>();
			String errorMessage = 'Exception thrown for ' + command.getOperationType() + ' operation.';

			for (SObject record : recordsToProcess) {
				RecordSummary recordSummary = new RecordSummary()
					.isSuccess(false)
					.error(
						new RecordProcessingError()
							.setMessage(errorMessage)
							.setStatusCode(System.StatusCode.ALREADY_IN_PROCESS)
							.setFields(new List<String> { 'Id' })
					);

				recordResults.add(recordSummary);
			}

			return recordResults;
		}

		private List<RecordResult> getMockedRecordSuccesses(DmlStrategy command, List<SObject> recordsToProcess) {
			List<RecordResult> recordResults = new List<RecordResult>();

			for (SObject record : recordsToProcess) {
				recordResults.add(command.executeMockedDml(record));
			}

			return recordResults;
		}

		private Boolean shouldThrowException(OperationType dmlType, SObjectType objectType) {
			return this.thrownExceptionDmlTypes.contains(dmlType) || (this.thrownExceptionDmlTypesByObjectTypes.get(dmlType) ?? new Set<SObjectType>()).contains(objectType);
		}
	}


	private class DmlRecords implements Records {
		// private List<SObject> recordsToProcess = new List<SObject>();
		// private List<EnhancedRecord> enhancedRecords = new List<EnhancedRecord>();
		private List<Record> records = new List<Record>();
		private SObjectType objectType;

		private Map<SObjectField, Object> valueByFieldApiName = new Map<SObjectField, Object>();
		private List<ParentRelationship> parentRelationships = new List<ParentRelationship>();
		private List<ExternalRelationship> externalRelationships = new List<ExternalRelationship>();

		private DmlRecords(List<SObject> records) {
			this.objectType = records.getSObjectType();
			for (SObject record : records) {
				this.records.add(new DmlRecord(record));
			}
		}

		private DmlRecords(Iterable<Id> recordIds) {
			Iterator<Id> it = recordIds.iterator();
			if (it.hasNext()) {
				this.objectType = it.next().getSObjectType();
			}
			for (Id recordId : recordIds) {
				this.records.add(new DmlRecord(recordId));
			}
		}

		public DmlRecords with(SObjectField field, Object value) {
			this.valueByFieldApiName.put(field, value);
			return this;
		}

		public DmlRecords withRelationship(SObjectField relationshipField, SObject relatedToRecord) {
			// this.parentRelationships.add(new ParentRelationship(relationshipField, relatedToRecord));
			this.parentRelationships.add(new ParentRelationship(relationshipField, new EnhancedRecord(relatedToRecord)));
			return this;
		}

		public DmlRecords withRelationship(SObjectField relationshipField, SObjectField externalIdField, Object externalId) {
			this.externalRelationships.add(new ExternalRelationship(relationshipField, externalIdField, externalId));
			return this;
		}

		public List<Record> get() {
			for (Record record : this.records) {
				EnhancedRecord enhancedRecord = record.get();

				this.populateFieldsValues(enhancedRecord);
				this.populateParentRelationships(enhancedRecord);
				this.populateExternalRelationships(enhancedRecord);
			}

			return this.records;
		}

		public SObjectType getSObjectType() {
			return this.objectType;
		}

		private void populateFieldsValues(EnhancedRecord enhancedRecord) {
			for (SObjectField field : this.valueByFieldApiName.keySet()) {
				enhancedRecord.with(field, this.valueByFieldApiName.get(field));
			}
		}

		private void populateParentRelationships(EnhancedRecord enhancedRecord) {
			for (ParentRelationship parentRelationship : this.parentRelationships) {
				enhancedRecord.withRelationship(parentRelationship);
			}
		}

		private void populateExternalRelationships(EnhancedRecord enhancedRecord) {
			for (ExternalRelationship externalRelationship : this.externalRelationships) {
				enhancedRecord.withRelationship(externalRelationship);
			}
		}
	}

	private class DmlRecord implements Record {
		private EnhancedRecord enhancedRecord;

		private DmlRecord(SObject record) {
			this.enhancedRecord = new EnhancedRecord(record);
		}

		private DmlRecord(Id recordId) {
			this.enhancedRecord = new EnhancedRecord(recordId);
		}

		public DmlRecord with(SObjectField field, Object value) {
			this.enhancedRecord.with(field, value);
			return this;
		}

		public DmlRecord withRelationship(SObjectField relationshipField, SObject relatedToRecord) {
			// this.enhancedRecord.withRelationship(new ParentRelationship(relationshipField, relatedToRecord));
			this.withRelationship(relationshipField, new EnhancedRecord(relatedToRecord));
			return this;
		}
		
		public DmlRecord withRelationship(SObjectField relationshipField, EnhancedRecord enhancedRelatedToRecord) {
			this.enhancedRecord.withRelationship(new ParentRelationship(relationshipField, enhancedRelatedToRecord));
			return this;
		}

		public DmlRecord withRelationship(SObjectField relationshipField, SObjectField externalIdField, Object externalId) {
			this.enhancedRecord.withRelationship(new ExternalRelationship(relationshipField, externalIdField, externalId));
			return this;
		}

		public EnhancedRecord get() {
			return this.enhancedRecord;
		}

		public SObjectType getSObjectType() {
			return this.enhancedRecord.getSObjectType();
		}
	}


	global class EnhancedRecord {
		private SObject currentRecord;
		private DmlStrategy command;
		// private Id operationId;
		private Boolean hasTemporaryId = false;

		private List<ParentRelationship> parentRelationships = new List<ParentRelationship>();
		private List<ExternalRelationship> externalRelationships = new List<ExternalRelationship>();

		private EnhancedRecord(SObject currentRecord) {
			this.currentRecord = currentRecord;
			// this.operationId = currentRecord.Id;
		}

		private EnhancedRecord(Id currentRecordId) {
			this(currentRecordId?.getSObjectType()?.newSObject(currentRecordId));
		}

		private void with(SObjectField field, Object value) {
			this.currentRecord.put(field, value);
		}

		private void withRelationship(ParentRelationship parentRelationship) {
			this.parentRelationships.add(parentRelationship);
		}

		private void withRelationship(ExternalRelationship externalRelationship) {
			this.externalRelationships.add(externalRelationship);
		}

		private void associateRecordWithCommand(DmlStrategy command) {
			this.command = command;
		}

		private void addToDependencyGraph(OrderDependencyGraph orderDependencyGraph) {
			if (orderDependencyGraph == null) {
				return;
			}

			orderDependencyGraph.ensureRecordIsTracked(this);

			for (ParentRelationship parentRelationship : this.parentRelationships) {
				orderDependencyGraph.addDependency(parentRelationship.getRelatedToEnhancedRecord(), this);
			}
		}

		private void resolveRecordRelationships() {
			for (ParentRelationship parentRelationship : this.parentRelationships) {
				parentRelationship.resolve(this.currentRecord);
			}

			for (ExternalRelationship externalRelationship : this.externalRelationships) {
				externalRelationship.resolve(this.currentRecord);
			}
		}

		private void setTemporaryId() {
			this.hasTemporaryId = true;
			this.currentRecord.Id = randomIdGenerator.get(this.getSObjectType());
		}

		private SObjectType getSObjectType() {
			return this.currentRecord?.getSObjectType();
		}

		private SObject getRecord() {
			if (this.hasTemporaryId) {
				this.currentRecord.Id = null;
			}
			return this.currentRecord;
		}

		private Boolean hasId() { //TODO Refactor
			if (this.hasTemporaryId) {
				return false;
			}
			return this.currentRecord?.Id != null;
		}

		private Id getRecordId() {
			return this.currentRecord?.Id;
		}

		private Integer hashCode() {
			return this.getRecordId()?.hashCode();
		}

		private Boolean equals(Object other) {
			return this.getRecordId() == ((EnhancedRecord) other)?.getRecordId();
		}
	}

	private class ParentRelationship {
		private SObjectField relationshipField;
		private EnhancedRecord relatedToRecordEnhancedRecord;

		private ParentRelationship(SObjectField relationshipField, EnhancedRecord relatedToRecord) {
			this.validateRelationshipField(relationshipField);

			this.relationshipField = relationshipField;
			this.relatedToRecordEnhancedRecord = relatedToRecord;
		}

		private EnhancedRecord getRelatedToEnhancedRecord() {
			return this.relatedToRecordEnhancedRecord;
		}

		private void resolve(SObject currentRecord) {
			currentRecord.put(this.relationshipField, this.relatedToRecordEnhancedRecord.getRecordId());
		}

		private void validateRelationshipField(SObjectField relationshipField) {            
			if (String.isBlank(relationshipField.getDescribe().getRelationshipName())) {
				throw new DmlException('Invalid argument: ' + relationshipField.toString() + '. Field supplied is not a relationship field.');
			}
		}
	}

	private class ExternalRelationship { 
		private SObjectField relationshipField;
		private SObjectField externalIdField;
		private SObjectType relatedToType;
		private Object relatedRecordExternalId;

		private ExternalRelationship(SObjectField relationshipField, SObjectField relatedObjectExternalIdField, Object relatedRecordExternalId) {
			this.validateRelatedToField(relationshipField);
			this.validateExternalIdField(relationshipField, relatedObjectExternalIdField);

			this.relationshipField = relationshipField;
			this.relatedToType = relationshipField.getDescribe().getReferenceTo()[0];
			this.externalIdField = relatedObjectExternalIdField;
			this.relatedRecordExternalId = relatedRecordExternalId;
		}  

		private void resolve(SObject currentRecord) {
			SObject relationshipObject = this.relatedToType.newSObject();
			relationshipObject.put(this.externalIdField.getDescribe().getName(), this.relatedRecordExternalId);

			currentRecord.putSObject(this.relationshipField.getDescribe().getRelationshipName(), relationshipObject);
		}

		private void validateRelatedToField(SObjectField relationshipField) {
			if (String.isBlank(relationshipField.getDescribe().getRelationshipName())) {
				throw new DmlException('Invalid argument: relationshipField. Field supplied is not a relationship field.');
			}
		}

		private void validateExternalIdField(SObjectField relationshipField, SObjectField externalIdField) {
			if (!externalIdField.getDescribe().isExternalId()) {
				throw new DmlException('Invalid argument: externalIdField. Field supplied is not marked as an External Identifier.');
			}
	
			SObjectType relatedObjectType = relationshipField.getDescribe().getReferenceTo()[0];
			String externalIdFieldName = externalIdField.getDescribe().getName();
	
			Boolean relatedHasExternalIdField = relatedObjectType.getDescribe().fields.getMap().keySet().contains(externalIdFieldName.toLowerCase());
	
			if (!relatedHasExternalIdField) {
				throw new DmlException('Invalid argument: externalIdField. Field supplied is not a known field on the target sObject.');
			}
		}
	}

	private class Wave {
		private DmlStrategy command; 
		private List<SObject> recordsToProcess = new List<SObject>();
	}

	// Kahn's algorithm for topological sorting of records based on their dependencies
	private class OrderDependencyGraph {
		private Map<Id, Set<Id>> dependentRecordsById = new Map<Id, Set<Id>>();
		private Map<Id, Integer> prerequisiteCountById = new Map<Id, Integer>();

		private void ensureRecordIsTracked(EnhancedRecord enhancedRecord) {
			Id recordId = enhancedRecord.getRecordId();

			if (!this.dependentRecordsById.containsKey(recordId)) {
				this.dependentRecordsById.put(recordId, new Set<Id>());
			}

			if (!this.prerequisiteCountById.containsKey(recordId)) {
				this.prerequisiteCountById.put(recordId, 0);
			}
		}

		private void addDependency(EnhancedRecord prerequisite, EnhancedRecord dependent) {
			if (prerequisite == dependent) {
				throw new DmlException('Self-dependency detected for record: ' + prerequisite.getRecordId());
			}

			this.ensureRecordIsTracked(prerequisite);
			this.ensureRecordIsTracked(dependent);

			Id prerequisiteId = prerequisite.getRecordId();
			Id dependentId = dependent.getRecordId();

			this.dependentRecordsById.get(prerequisiteId).add(dependentId);
			this.prerequisiteCountById.put(dependentId, this.prerequisiteCountById.get(dependentId) + 1);
		}

		private List<List<Id>> computeExecutionWaves() {
			if (this.prerequisiteCountById.isEmpty()) {
				return new List<List<Id>>();
			}

			Integer processedCount = 0;
			List<Id> readyToProcessIds = this.findRecordsReadyToProcess();

			List<List<Id>> executionWaves = new List<List<Id>>();

			while (!readyToProcessIds.isEmpty()) {
				List<Id> currentWave = readyToProcessIds;
				executionWaves.add(currentWave);

				List<Id> nextWave = new List<Id>();

				for (Id processedId : currentWave) {
					processedCount++;
					
					for (Id dependentId : (this.dependentRecordsById.get(processedId) ?? new Set<Id>())) {
						Integer remainingPrerequisites = this.prerequisiteCountById.get(dependentId) - 1;
						this.prerequisiteCountById.put(dependentId, remainingPrerequisites);

						if (remainingPrerequisites == 0) {
							nextWave.add(dependentId);
						}
					}
				}

				readyToProcessIds = nextWave;
			}

			if (processedCount != this.prerequisiteCountById.size()) {
				throw new DmlException('Cyclic dependencies detected among records.');
			}

			return executionWaves;
		}

		private List<Id> findRecordsReadyToProcess() {
			List<Id> readyToProcess = new List<Id>();

			for (Id recordId : this.prerequisiteCountById.keySet()) {
				if (this.prerequisiteCountById.get(recordId) == 0) {
					readyToProcess.add(recordId);
				}
			}

			return readyToProcess;
		}
	}

	@TestVisible
	private class RandomIdGenerator {
		private Integer counter = 0;
		private Map<SObjectType, String> prefixBySObject = new Map<SObjectType, String>();

		public Id get(SObjectType objectType) {
			return this.get(this.getPrefix(objectType));
		}

		private Id get(String prefix) {
			this.counter++;
			return Id.valueOf(prefix + '0'.repeat(15 - prefix.length() - String.valueOf(this.counter).length()) + String.valueOf(this.counter));
		}

		private String getPrefix(SObjectType objectType) {
			String prefix = this.prefixBySObject?.get(objectType);
			
			if (prefix == null) {
				prefix = objectType.getDescribe().getKeyPrefix();
				this.prefixBySObject.put(objectType, prefix);
			}	

			return prefix;
		}
	}
}