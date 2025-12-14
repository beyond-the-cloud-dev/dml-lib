/**
 * Copyright (c) 2025 Beyond The Cloud Sp. z o.o. (BeyondTheCloud.Dev)
 * Licensed under the MIT License (https://github.com/beyond-the-cloud-dev/dml-lib/blob/main/LICENSE)
 *
 * v2.0.0
 *
 * PMD False Positives:
 * - MethodNamingConventions - Some methods are uppercase to indicate that they are "constructors" of othere internal classes
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
		Commitable toUpsert(DML.Record record);
		Commitable toUpsert(List<SObject> records);
		Commitable toUpsert(DML.Records records);
		// Delete
		Commitable toDelete(Id recordId);
		Commitable toDelete(SObject record);
		Commitable toDelete(Iterable<Id> recordIds);
		Commitable toDelete(List<SObject> records);
		// Undelete
		Commitable toUndelete(Id recordId);
		Commitable toUndelete(SObject record);
		Commitable toUndelete(Iterable<Id> recordIds);
		Commitable toUndelete(List<SObject> records);
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
	}

	global interface Records {
		Records with(SObjectField field, Object value); 
		Records withRelationship(SObjectField targetField, SObject relatedRecord);
		Records withRelationship(SObjectField targetField, SObjectField relatedObjectExternalIdField, Object relatedRecordExternalId);
		
		// for internal use only
		List<Record> get();
	}

	global interface Result {
		List<OperationResult> all();
		// Per Operation
		List<OperationResult> inserts();
		List<OperationResult> updates();
		List<OperationResult> upserts();
		List<OperationResult> deletes();
		List<OperationResult> undeletes();
		List<OperationResult> events();
		// Per Object OperationType
		OperationResult insertsOf(Schema.SObjectType objectType);
		OperationResult updatesOf(Schema.SObjectType objectType);
		OperationResult upsertsOf(Schema.SObjectType objectType);
		OperationResult deletesOf(Schema.SObjectType objectType);
		OperationResult undeletesOf(Schema.SObjectType objectType);
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
		Mockable allPublishes();
		// Per Object OperationType
		Mockable insertsFor(SObjectType objectType);
		Mockable updatesFor(SObjectType objectType);
		Mockable upsertsFor(SObjectType objectType);
		Mockable deletesFor(SObjectType objectType);
		Mockable undeletesFor(SObjectType objectType);
		Mockable publishesFor(SObjectType objectType);
		// Errors
		Mockable exceptionOnInserts();
		Mockable exceptionOnUpdates();
		Mockable exceptionOnUpserts();
		Mockable exceptionOnDeletes();
		Mockable exceptionOnUndeletes();
		Mockable exceptionOnPublishes();
		// Per Operation Type Per Object Type
		Mockable exceptionOnInsertsFor(SObjectType objectType);
		Mockable exceptionOnUpdatesFor(SObjectType objectType);
		Mockable exceptionOnUpsertsFor(SObjectType objectType);
		Mockable exceptionOnDeletesFor(SObjectType objectType);
		Mockable exceptionOnUndeletesFor(SObjectType objectType);
		Mockable exceptionOnPublishesFor(SObjectType objectType);
	}

	// Hooks

	global interface Hook {
		void before();
		void after(Result result);
	}

	// Implementation

	private Configuration configuration = new Configuration();
	private OrderDependencyGraph orderDependencyGraph = new OrderDependencyGraph(); //TODO Clear after commitWork()
	private Orchestrator orchestrator = new Orchestrator();

	global enum OperationType { INSERT_DML, UPDATE_DML, UPSERT_DML, DELETE_DML, UNDELETE_DML, PUBLISH_DML }

	private Map<OperationType, DmlOperation> operationsByType = new Map<OperationType, DmlOperation>();

	private Hook hook = null;

	@TestVisible
	private static final RandomIdGenerator randomIdGenerator = new RandomIdGenerator();
	private static final Map<String, Result> dmlIdentifierToResult = new Map<String, Result>();
	private static final Map<String, DmlMock> dmlIdentifierToMock = new Map<String, DmlMock>();

	global DML() {
		this.initializeOperations();
	}

	global DML(List<SObjectType> customExecutionOrder) {
		this();
		this.configuration.executionOrder(customExecutionOrder);
	}

	private void initializeOperations() {
		this.operationsByType.put(OperationType.INSERT_DML, new InsertOperation(this.configuration));
		this.operationsByType.put(OperationType.UPSERT_DML, new UpsertOperation(this.configuration));
		this.operationsByType.put(OperationType.UPDATE_DML, new UpdateOperation(this.configuration));
		this.operationsByType.put(OperationType.DELETE_DML, new DeleteOperation(this.configuration));
		this.operationsByType.put(OperationType.UNDELETE_DML, new UndeleteOperation(this.configuration));
		this.operationsByType.put(OperationType.PUBLISH_DML, new PlatformEventOperation(this.configuration));
	}
	
	// Insert

	public Commitable toInsert(SObject record) {
		return this.toInsert(Record(record));
	}

	public Commitable toInsert(Record record) {
		return this.registerOperation(new InsertCommand(record));
	}

	public Commitable toInsert(List<SObject> records) {
		return this.toInsert(Records(records));
	}
	
	public Commitable toInsert(Records records) {
		return this.registerOperation(new InsertCommand(records));
	}

	private Commitable registerOperation(DmlCommand command) {
		this.orchestrator.register(
			command
				.setGlobalConfiguration(this.configuration)
				.setDependencyGraph(this.orderDependencyGraph)
		);
		return this;
	}

	public OperationResult insertImmediately(SObject record) {
		return this.insertImmediately(Record(record));
	}

	public OperationResult insertImmediately(Record record) {
		return this.executeImmediately(new InsertOperation(this.configuration), record);
	}

	public OperationResult insertImmediately(List<SObject> records) {
		return this.insertImmediately(Records(records));
	}

	public OperationResult insertImmediately(Records records) {
		return this.executeImmediately(new InsertOperation(this.configuration), records);
	}

	// Update
	
	public Commitable toUpdate(SObject record) {
		return this.toUpdate(Record(record));
	}

	public Commitable toUpdate(Record record) {
		return this.registerOperation(OperationType.UPDATE_DML, record);
	}

	public Commitable toUpdate(List<SObject> records) {
		return this.toUpdate(Records(records));
	}

	public Commitable toUpdate(Records records) {
		return this.registerOperation(OperationType.UPDATE_DML, records);
	}

	public OperationResult updateImmediately(SObject record) {
		return this.updateImmediately(Record(record));
	}

	public OperationResult updateImmediately(Record record) {
		return this.executeImmediately(new UpdateOperation(this.configuration), record);
	}

	public OperationResult updateImmediately(List<SObject> records) {
		return this.updateImmediately(Records(records));
	}

	public OperationResult updateImmediately(Records records) {
		return this.executeImmediately(new UpdateOperation(this.configuration), records);
	}

	// Upsert

	public Commitable toUpsert(SObject record) {
		return this.toUpsert(Record(record));
	}

	public Commitable toUpsert(Record record) {
		return this.registerOperation(OperationType.UPSERT_DML, record);
	}

	public Commitable toUpsert(List<SObject> records) {
		return this.toUpsert(Records(records));
	}

	public Commitable toUpsert(Records records) {
		return this.registerOperation(OperationType.UPSERT_DML, records);
	}

	public OperationResult upsertImmediately(SObject record) {
		return this.upsertImmediately(Record(record));
	}

	public OperationResult upsertImmediately(Record record) {
		return this.executeImmediately(new UpsertOperation(this.configuration), record);
	}

	public OperationResult upsertImmediately(List<SObject> records) {
		return this.upsertImmediately(Records(records));
	}

	public OperationResult upsertImmediately(Records records) {
		return this.executeImmediately(new UpsertOperation(this.configuration), records);
	}

	// Delete

	public Commitable toDelete(Id recordId) {
		return this.registerOperation(OperationType.DELETE_DML, Record(recordId));
	}

	public Commitable toDelete(SObject record) {
		return this.toDelete(record.Id);
	}

	public Commitable toDelete(Iterable<Id> recordIds) {
		return this.registerOperation(OperationType.DELETE_DML, Records(recordIds));
	}

	public Commitable toDelete(List<SObject> records) {
		return this.registerOperation(OperationType.DELETE_DML, Records(records));
	}

	public OperationResult deleteImmediately(Id recordId) {
		return this.executeImmediately(new DeleteOperation(this.configuration), Record(recordId));
	}

	public OperationResult deleteImmediately(SObject record) {
		return this.executeImmediately(new DeleteOperation(this.configuration), Record(record));
	}

	public OperationResult deleteImmediately(Iterable<Id> recordIds) {
		return this.executeImmediately(new DeleteOperation(this.configuration), Records(recordIds));
	}

	public OperationResult deleteImmediately(List<SObject> records) {
		return this.executeImmediately(new DeleteOperation(this.configuration), Records(records));
	}

	// Undelete

	public Commitable toUndelete(Id recordId) {
		return this.registerOperation(OperationType.UNDELETE_DML, Record(recordId));
	}

	public Commitable toUndelete(SObject record) {
		return this.toUndelete(record.Id);
	}

	public Commitable toUndelete(Iterable<Id> recordIds) {
		return this.registerOperation(OperationType.UNDELETE_DML, Records(recordIds));
	}

	public Commitable toUndelete(List<SObject> records) {
		return this.registerOperation(OperationType.UNDELETE_DML, Records(records));
	}

	public OperationResult undeleteImmediately(Id recordId) {
		return this.executeImmediately(new UndeleteOperation(this.configuration), Record(recordId));
	}

	public OperationResult undeleteImmediately(SObject record) {
		return this.executeImmediately(new UndeleteOperation(this.configuration), Record(record));
	}

	public OperationResult undeleteImmediately(Iterable<Id> recordIds) {
		return this.executeImmediately(new UndeleteOperation(this.configuration), Records(recordIds));
	}

	public OperationResult undeleteImmediately(List<SObject> records) {
		return this.executeImmediately(new UndeleteOperation(this.configuration), Records(records));
	}

	// Merge

	public Commitable toMerge(SObject mergeToRecord, List<SObject> duplicateRecords) {
		return this;// this.registerOperation(OperationType.MERGE_DML, Record(mergeToRecord), Records(duplicateRecords));
	}

	// Platform Event

	public Commitable toPublish(SObject record) {
		return this.registerOperation(OperationType.PUBLISH_DML, Record(record));
	}

	public Commitable toPublish(List<SObject> records) {
		return this.registerOperation(OperationType.PUBLISH_DML, Records(records));
	}

	public OperationResult publishImmediately(SObject record) {
		return this.executeImmediately(new PlatformEventOperation(this.configuration), Record(record));
	}

	public OperationResult publishImmediately(List<SObject> records) {
		return this.executeImmediately(new PlatformEventOperation(this.configuration), Records(records));
	}

	private Commitable registerOperation(OperationType type, Record record) {
		this.operationsByType.get(type).register(record);
		return this;
	}
	
	private Commitable registerOperation(OperationType type, Records records) {
		this.operationsByType.get(type).register(records);
		return this;
	}

	private OperationResult executeImmediately(DmlOperation operation, Record record) {
		return operation.register(record).commitWork().get(0);
	}

	private OperationResult executeImmediately(DmlOperation operation, Records records) {
		return operation.register(records).commitWork().get(0);
	}

	// Identifier

	public Commitable identifier(String dmlIdentifier) {
		this.configuration.identifier(dmlIdentifier);
		return this;
	}

	// Debug

	public void preview() {
		this.configuration.preview();

		for (OperationType operationType : this.operationsByType.keySet()) {
			this.operationsByType.get(operationType).preview();
		}
	}

	// Field Level Security

	public Commitable userMode() {
		return this.setAccessMode(System.AccessLevel.USER_MODE);
	}

	public Commitable systemMode() {
		return this.setAccessMode(System.AccessLevel.SYSTEM_MODE);
	}

	private Commitable setAccessMode(System.AccessLevel accessMode) {
		this.configuration.accessMode(accessMode);
		return this;
	}

	// Sharing Mode

	public Commitable withSharing() {
		this.configuration.withSharing();
		return this;
	}

	public Commitable withoutSharing() {
		this.configuration.withoutSharing();
		return this;
	}

	// Other configs

	public Commitable allowPartialSuccess() {
		this.configuration.allowPartialSuccess();
		return this;
	}

	public Commitable skipDuplicateRules() {
		this.configuration.skipDuplicateRules();
		return this;
	}

	public Commitable options(Database.DmlOptions options) {
		this.configuration.options(options);
		return this;
	}

	public Commitable discardWork() {
		this.reset();
		return this;
	}

	// Hooks

	public Commitable commitHook(Hook callback) {
		this.hook = callback;
		return this;
	}

	public Result dryRun() {
		Savepoint savePoint = Database.setSavepoint();

		try {
			this.hook?.before();

			DMLResult result = this.executeOperations();

			this.hook?.after(result);

			return result;
		} finally {
			Database.rollback(savePoint);
			Database.releaseSavepoint(savePoint);
		}
	}

	public Result commitWork() {
		DMLResult result = new DmlResult();

		try {
			this.hook?.before();

			result = this.executeOperations();

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

	public Result commitTransaction() {
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

	private DMLResult executeOperations() {
		DMLResult result = new DmlResult();

		for (OperationType operationType : this.operationsByType.keySet()) {
			result.add(operationType, this.operationsByType.get(operationType).commitWork());
		}

		return result;
	}

	private void reset() {
		this.operationsByType.clear();
		this.initializeOperations();
	}

	private class Orchestrator {
		private Map<String, DmlCommand> commandsByHashCode = new Map<String, DmlCommand>();

		private void register(DmlCommand command) {
			DmlCommand existingCommand = this.commandsByHashCode.get(command.hashCode());

			if (existingCommand == null) {
				this.commandsByHashCode.put(command.hashCode(), command);
				return;
			} 

			existingCommand.combine(command);
		}

		private List<OperationResult> execute() {
			List<OperationResult> operationResults = new List<OperationResult>();

			for (DmlCommand command : this.getOrderedCommands()) {
				operationResults.add(command.commitWork());
			}

			return operationResults;
		}

		private List<DmlCommand> getOrderedCommands() {
			List<DmlCommand> orderedCommands = new List<DmlCommand>(this.commandsByHashCode.values());

			orderedCommands.sort(new DmlCommandComperator());

			return orderedCommands;
		}
	}

	private class DmlResult implements Result {
		private Map<OperationType, Map<SObjectType, OperationResult>> operationResultsByObjectType = new Map<OperationType, Map<SObjectType, OperationResult>>{
			OperationType.INSERT_DML => new Map<SObjectType, OperationResult>(),
			OperationType.UPDATE_DML => new Map<SObjectType, OperationResult>(),
			OperationType.UPSERT_DML => new Map<SObjectType, OperationResult>(),
			OperationType.DELETE_DML => new Map<SObjectType, OperationResult>(),
			OperationType.UNDELETE_DML => new Map<SObjectType, OperationResult>(),
			OperationType.PUBLISH_DML => new Map<SObjectType, OperationResult>()
		};

		public DmlResult add(OperationType operationType, List<OperationResult> results) {
			for (OperationResult result : results) {
				this.operationResultsByObjectType.get(operationType).put(result.objectType(), result);
			}

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

	private abstract class DmlOperation {
		protected Map<SObjectType, RecordsContainer> recordsProcessContainerByType = new Map<SObjectType, RecordsContainer>();
		protected Configuration globalConfiguration;
		protected OrderDependencyGraph orderDependencyGraph = new OrderDependencyGraph();

		public DmlOperation(Configuration configuration) {
			this.globalConfiguration = configuration;
		}

		private DmlOperation register(Records records) {
			for (Record record : records.get()) {
				this.register(record);
			}

			return this;
		}

		private DmlOperation register(Record record) {
			EnhancedRecord enhancedRecord = record.get();
			SObjectType typeName = enhancedRecord.getSObjectType();

			this.validate(record);
			this.validateCustomExecutionOrder(typeName);

			this.addNewRecordToProcess(typeName, enhancedRecord);
			
			enhancedRecord.addToDependencyGraph(this.orderDependencyGraph);

			return this;
		}

		private void validateCustomExecutionOrder(SObjectType typeName) {
			if (!this.globalConfiguration.customExecutionOrder.isEmpty() && !this.globalConfiguration.customExecutionOrder.contains(typeName)) {
				throw new DmlException('Only the following types can be registered: ' + this.globalConfiguration.customExecutionOrder);
			}
		}

		private void addNewRecordToProcess(SObjectType typeName, EnhancedRecord enhancedRecord) {
			if (!this.recordsProcessContainerByType.containsKey(typeName)) {
				this.recordsProcessContainerByType.put(typeName, new RecordsContainer());
			}

			this.recordsProcessContainerByType.get(typeName).addNewRecordToProcess(enhancedRecord);
		}

		private void preview() {
			System.debug(LoggingLevel.ERROR,
				'\n\n============ ' + this.getType() + ' Preview ============'
				+ '\nRecords Process Container: ' + JSON.serializePretty(this.recordsProcessContainerByType)
				+ '\n=======================================\n'
			);
		}

		private List<OperationResult> commitWork() {
			return this.globalConfiguration.sharingExecutor.execute(this);
		}

		private List<OperationResult> execute() {
			if (!this.globalConfiguration.customExecutionOrder.isEmpty()) {
				return this.process(this.globalConfiguration.customExecutionOrder);
			} 

			return this.process(this.orderDependencyGraph.getTopologicalOrder());
		}

		private List<OperationResult> process(Iterable<SObjectType> objectTypesOrder) {
			List<OperationResult> operationResults = new List<OperationResult>();

			DmlResultAdapter operationResultAdapter = this.getAdapter();

			for (SObjectType objectTypeName : objectTypesOrder) {
				if (!this.recordsProcessContainerByType.containsKey(objectTypeName)) {
					continue;
				}

				List<SObject> recordsToProcess = this.recordsProcessContainerByType.get(objectTypeName).getRecordsToProcess();

				List<RecordResult> recordResults;

				DmlMock dmlMock = dmlIdentifierToMock.get(this.globalConfiguration.dmlIdentifier);

				if (dmlMock != null && dmlMock.shouldBeMocked(this.getType(), objectTypeName)) {
					recordResults = dmlMock.getMockedRecordResults(this, objectTypeName, recordsToProcess);
				} else {
					recordResults = operationResultAdapter.get(this.executeDml(recordsToProcess), recordsToProcess);
				}	

				operationResults.add(
					new OperationSummary(objectTypeName, this.getType())
						.setRecords(recordsToProcess)
						.setRecordResults(recordResults)
				);
			}

			return operationResults;
		}

		protected abstract OperationType getType();
		protected abstract List<Object> executeDml(List<SObject> recordsToProcess);
		protected abstract RecordSummary prepareMockedDml(SObject record);
		protected abstract DmlResultAdapter getAdapter(); 

		protected virtual void validate(Record record) {
			return;
		}
	}

	private class DmlCommandComperator implements System.Comparator<DmlCommand> {
		// private final List<DML.OperationType> opOrder;
		// private final Map<DML.OperationType, List<SObjectType>> typeOrderByOp;
	
		// public DmlCommandComparator(
		// 	List<DML.OperationType> opOrder,
		// 	Map<DML.OperationType, List<SObjectType>> typeOrderByOp
		// ) {
		// 	this.opOrder = opOrder;
		// 	this.typeOrderByOp = typeOrderByOp;
		// }
	
		public Integer compare(DmlCommand a, DmlCommand b) {
			// 1) porównaj po kolejności operacji
			// Integer diff = opOrder.indexOf(a.operationType()) - opOrder.indexOf(b.operationType());
			// if (diff != 0) return diff;
	
			// // 2) w obrębie tej samej operacji porównaj po kolejności typów
			// List<SObjectType> typeOrder = typeOrderByOp.get(a.operationType());
			// return typeOrder.indexOf(a.objectType()) - typeOrder.indexOf(b.objectType());
			return 2;
		}
	}

	private abstract class DmlCommand {
		// private OperationType operationType;
		private SObjectType objectType;
		private Configuration globalConfiguration;
		private RecordsContainer recordsContainer = new RecordsContainer();
		private OrderDependencyGraph orderDependencyGraph;

		private List<SObject> records = new List<SObject>();

		private DmlCommand setGlobalConfiguration(Configuration globalConfiguration) {
			this.globalConfiguration = globalConfiguration;
			return this;
		}

		private DmlCommand setDependencyGraph(OrderDependencyGraph orderDependencyGraph) {
			this.orderDependencyGraph = orderDependencyGraph;
			return this;
		}

		private DmlCommand register(Records records) {
			for (Record record : records.get()) {
				this.register(record);
			}
			return this;
		}

		private DmlCommand register(Record record) {
			EnhancedRecord enhancedRecord = record.get();
			this.objectType = enhancedRecord.getSObjectType(); //todo not needed in loop

			// this.validate(enhancedRecord);
			this.recordsContainer.addNewRecordToProcess(enhancedRecord);
			enhancedRecord.addToDependencyGraph(this.orderDependencyGraph);

			return this;
		}

		private OperationResult commitWork() {
			return this.globalConfiguration.sharingExecutor.execute(this);
		}
		
		private virtual OperationResult execute() {
			// this.getAdapter();
			OperationSummary operationSummary = new OperationSummary(this.objectType, this.getOperationType()).setRecords(this.records);
			
			DmlMock dmlMock = dmlIdentifierToMock.get(this.globalConfiguration.dmlIdentifier);

			if (dmlMock != null && dmlMock.shouldBeMocked(this.getOperationType(), this.objectType)) {
				return operationSummary;
				// recordResults = dmlMock.getMockedRecordResults(this, objectTypeName, recordsToProcess);
			} 

			return operationSummary;// this.getAdapter().get(this.executeDml(), this.records);
		}

		private virtual void combine(DmlCommand command) {
			// TODO: Avoid duplicate records if there is Id 
			this.records.addAll(command.records);
		}

		protected abstract OperationType getOperationType();
		protected abstract List<Object> executeDml();

		protected virtual void validate(SObject record) {
			return;
		}

		protected virtual String hashCode() {
			return this.getOperationType() + '_' + this.objectType;
		}
	}

	private inherited sharing class InsertCommand extends DmlCommand {
		private List<SObject> records = new List<SObject>();

		public InsertCommand(Record record) {
			this.register(record);
		}

		public InsertCommand(Records records) {
			this.register(records);
		}

		protected override OperationType getOperationType() {
			return OperationType.INSERT_DML;
		}

		public DmlResultAdapter getAdapter() {
			return new SaveResultAdapter();
		}

		protected override void validate(SObject record) {
			if (String.isNotBlank(record.Id)) {
				throw new DmlException('Only new records can be registered as new.');
			}
		}

		protected override List<Object> executeDml() {
			return Database.insert(this.records, this.globalConfiguration.options, this.globalConfiguration.accessMode);
		}
	}

	private inherited sharing class UpsertCommand extends DmlCommand {
		private SObjectField externalIdField;

		public UpsertCommand(Record record) {
			// super(record);
		}

		public UpsertCommand(Records records) {
			// super(records);
		}

		public UpsertCommand(Record record, SObjectField externalIdField) {
			// super(record);
			this.externalIdField = externalIdField;
		}

		public UpsertCommand(Records records, SObjectField externalIdField) {
			// super(records);
			this.externalIdField = externalIdField;
		}

		protected override OperationType getOperationType() {
			return OperationType.UPSERT_DML;
		}

		protected override String hashCode() {
			return super.hashCode() + '_' + this.externalIdField ?? 'Id';
		}

		protected override void validate(SObject record) {
			if (String.isBlank(record.Id)) {
				throw new DmlException('Only existing records can be updated.');
			}
		}

		protected override List<Object> executeDml() {
			if (this.externalIdField == null) {
				return Database.upsert(this.records, this.globalConfiguration.allOrNone, this.globalConfiguration.accessMode);
			}

			return Database.upsert(this.records, this.externalIdField, this.globalConfiguration.allOrNone, this.globalConfiguration.accessMode);
		}
	}

	private inherited sharing class UpdateCommand extends DmlCommand {
		public UpdateCommand(Record record) {
			// super(record);
		}

		public UpdateCommand(Records records) {
			// super(records);
		}

		protected override OperationType getOperationType() {
			return OperationType.UPDATE_DML;
		}

		protected override List<Object> executeDml() {
			return Database.update(this.records, this.globalConfiguration.options, this.globalConfiguration.accessMode);
		}
	}

	private inherited sharing class MergeCommand extends DmlCommand {
		private SObject mergeToRecord;
		private List<SObject> duplicateRecords;

		public MergeCommand(SObject mergeToRecord, List<SObject> duplicateRecords) {
			this.mergeToRecord = mergeToRecord;
			this.duplicateRecords = duplicateRecords;
		}

		protected override OperationType getOperationType() {
			return null;//OperationType.MERGE_DML;
		}

		protected override String hashCode() {
			return super.hashCode() + '_' + this.mergeToRecord.Id;
		}

		// todo merge to record should have id

		protected override List<Object> executeDml() {
			return Database.merge(this.mergeToRecord, this.duplicateRecords, this.globalConfiguration.allOrNone, this.globalConfiguration.accessMode);
		}
	}

	private inherited sharing class DeleteCommand extends DmlCommand {

		public DeleteCommand(Record record) {
			// super(record);
		}

		public DeleteCommand(Records records) {
			// super(records);
		}

		protected override OperationType getOperationType() {
			return OperationType.DELETE_DML;
		}

		protected override List<Object> executeDml() {
			return Database.delete(this.records, this.globalConfiguration.allOrNone, this.globalConfiguration.accessMode);
		}
	}

	private inherited sharing class UndeleteCommand extends DmlCommand {
		public UndeleteCommand(Record record) {
			// super(record);
		}

		public UndeleteCommand(Records records) {
			// super(records);
		}

		protected override OperationType getOperationType() {
			return OperationType.UNDELETE_DML;
		}

		protected override List<Object> executeDml() {
			return Database.undelete(this.records, this.globalConfiguration.allOrNone, this.globalConfiguration.accessMode);
		}
	}

	private inherited sharing class PlatformEventCommand extends DmlCommand {
		public PlatformEventCommand(Record record) {
			// super(record);
		}

		public PlatformEventCommand(Records records) {
			// super(records);
		}
		
		protected override OperationType getOperationType() {
			return OperationType.PUBLISH_DML;
		}

		protected override List<Object> executeDml() {
			return EventBus.publish(this.records);
		}
	}

	private class RecordsContainer {
		private List<EnhancedRecord> enhancedRecords = new List<EnhancedRecord>();

		private void addNewRecordToProcess(EnhancedRecord enhancedRecord) {
			this.enhancedRecords.add(enhancedRecord);
		}

		private List<SObject> getRecordsToProcess() { 
			List<SObject> recordsToProcess = new List<SObject>();

			for (EnhancedRecord enhancedRecord : this.enhancedRecords) {
				enhancedRecord.resolveRecordRelationships();
				recordsToProcess.add(enhancedRecord.getRecord());
			}

			return recordsToProcess;
		}
	}

	private inherited sharing class InsertOperation extends DmlOperation {
		public InsertOperation(Configuration configuration) {
			super(configuration);
		}

		protected override OperationType getType() {
			return OperationType.INSERT_DML;
		}

		protected override void validate(Record record) {
			if (record.get().doesRecordHaveIdSpecified()) {
				throw new DmlException('Only new records can be registered as new.');
			}
		}

		protected override List<Object> executeDml(List<SObject> recordsToProcess) {
			return Database.insert(recordsToProcess, this.globalConfiguration.options, this.globalConfiguration.accessMode);
		}

		protected override RecordSummary prepareMockedDml(SObject record) {
			record.put('Id', randomIdGenerator.get(record.getSObjectType()));
			return new RecordSummary().isSuccess(true).recordId(record.Id);
		}

		protected override DmlResultAdapter getAdapter() {
			return new SaveResultAdapter();
		}
	}

	private inherited sharing class UpdateOperation extends DmlOperation {
		public UpdateOperation(Configuration configuration) {
			super(configuration);
		}

		protected override OperationType getType() {
			return OperationType.UPDATE_DML;
		}

		protected override void validate(Record record) {
			if (!record.get().doesRecordHaveIdSpecified()) {
				throw new DmlException('Only existing records can be updated.');
			}
		}

		protected override List<Object> executeDml(List<SObject> recordsToProcess) {
			return Database.update(recordsToProcess, this.globalConfiguration.options, this.globalConfiguration.accessMode);
		}

		protected override RecordSummary prepareMockedDml(SObject record) {
			return new RecordSummary().isSuccess(true).recordId(record.Id);
		}

		protected override DmlResultAdapter getAdapter() {
			return new SaveResultAdapter();
		}
	}

	private inherited sharing class UpsertOperation extends DmlOperation {
		public UpsertOperation(Configuration configuration) {
			super(configuration);
		}

		protected override OperationType getType() {
			return OperationType.UPSERT_DML;
		}

		protected override List<Object> executeDml(List<SObject> recordsToProcess) {
			return Database.upsert(recordsToProcess, this.globalConfiguration.allOrNone, this.globalConfiguration.accessMode);
		}

		protected override RecordSummary prepareMockedDml(SObject record) {
			if (record.Id == null) {
				record.put('Id', randomIdGenerator.get(record.getSObjectType()));
			}
			return new RecordSummary().isSuccess(true).recordId(record.Id);
		}

		protected override DmlResultAdapter getAdapter() {
			return new UpsertResultAdapter();
		}
	}

	private inherited sharing class DeleteOperation extends DmlOperation {
		public DeleteOperation(Configuration configuration) {
			super(configuration);
		}

		protected override OperationType getType() {
			return OperationType.DELETE_DML;
		}

		protected override void validate(Record record) {
			if (!record.get().doesRecordHaveIdSpecified()) {
				throw new DmlException('Only existing records can be registered as deleted.');
			}
		}

		protected override List<Object> executeDml(List<SObject> recordsToProcess) {
			return Database.delete(recordsToProcess, this.globalConfiguration.allOrNone, this.globalConfiguration.accessMode);
		}

		protected override RecordSummary prepareMockedDml(SObject record) {
			return new RecordSummary().isSuccess(true).recordId(record.Id);
		}

		protected override DmlResultAdapter getAdapter() {
			return new DeleteResultAdapter();
		}
	}

	private inherited sharing class UndeleteOperation extends DmlOperation {
		public UndeleteOperation(Configuration configuration) {
			super(configuration);
		}

		protected override OperationType getType() {
			return OperationType.UNDELETE_DML;
		}

		protected override void validate(Record record) {
			if (!record.get().doesRecordHaveIdSpecified()) {
				throw new DmlException('Only deleted records can be undeleted.');
			}
		}

		protected override List<Object> executeDml(List<SObject> recordsToProcess) {
			return Database.undelete(recordsToProcess, this.globalConfiguration.allOrNone, this.globalConfiguration.accessMode);
		}

		protected override RecordSummary prepareMockedDml(SObject record) {
			return new RecordSummary().isSuccess(true).recordId(record.Id);
		}

		protected override DmlResultAdapter getAdapter() {
			return new UndeleteResultAdapter();
		}
	}

	private inherited sharing class MergeOperation extends DmlOperation {
		public MergeOperation(Configuration configuration) {
			super(configuration);
		}

		protected override OperationType getType() {
			return null;// OperationType.MERGE_DML;
		}

		protected override List<Object> executeDml(List<SObject> recordsToProcess) {
			return null;// Database.merge(null, recordsToProcess, this.globalConfiguration.allOrNone, this.globalConfiguration.accessMode);
		}

		protected override RecordSummary prepareMockedDml(SObject record) {
			return new RecordSummary().isSuccess(true).recordId(record.Id);
		}

		protected override DmlResultAdapter getAdapter() {
			return null;//new MergeResultAdapter();
		}
	}

	private inherited sharing class PlatformEventOperation extends DmlOperation {
		public PlatformEventOperation(Configuration configuration) {
			super(configuration);
		}

		protected override OperationType getType() {
			return OperationType.PUBLISH_DML;
		}

		protected override List<Object> executeDml(List<SObject> recordsToProcess) {
			return EventBus.publish(recordsToProcess);
		}

		protected override RecordSummary prepareMockedDml(SObject record) {
			return new RecordSummary().isSuccess(true).recordId(randomIdGenerator.get(record.getSObjectType()));
		}

		protected override DmlResultAdapter getAdapter() {
			return new SaveResultAdapter();
		}
	}
	
	private interface DmlSharing {
		List<OperationResult> execute(DmlOperation executor);
		OperationResult execute(DmlCommand command);
	}

	private inherited sharing class InheritedSharing implements DmlSharing {
		public List<OperationResult> execute(DmlOperation executor) {
			return executor.execute();
		}
		public OperationResult execute(DmlCommand command) {
			return command.execute();
		}
	}

	private without sharing class WithoutSharing implements DmlSharing {
		public List<OperationResult> execute(DmlOperation executor) {
			return executor.execute();
		}
		public OperationResult execute(DmlCommand command) {
			return command.execute();
		}
	}

	private with sharing class WithSharing implements DmlSharing {
		public List<OperationResult> execute(DmlOperation executor) {
			return executor.execute();
		}
		public OperationResult execute(DmlCommand command) {
			return command.execute();
		}
	}

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

		private List<RecordResult> getMockedRecordResults(DmlOperation executor, SObjectType objectType, List<SObject> recordsToProcess) {
			if (this.shouldThrowException(executor.getType(), objectType)) {
				if (executor.globalConfiguration.allOrNone) {
					throw new DmlException('Exception thrown for ' + executor.getType() + ' operation.');
				}

				// all or none is false, so we need to return a list of record results with errors
				return this.getMockedRecordErrors(executor, objectType, recordsToProcess);
			}

			return this.getMockedRecordSuccesses(executor, objectType, recordsToProcess);
		}

		private List<RecordResult> getMockedRecordErrors(DmlOperation executor, SObjectType objectType, List<SObject> recordsToProcess) {
			List<RecordResult> recordResults = new List<RecordResult>();

			for (SObject record : recordsToProcess) {
				RecordProcessingError error = new RecordProcessingError()
					.setMessage('Exception thrown for ' + executor.getType() + ' operation.')
					.setStatusCode(System.StatusCode.ALREADY_IN_PROCESS)
					.setFields(new List<String> { 'Id' });

				RecordSummary recordSummary = new RecordSummary()
					.isSuccess(false)
					.error(error);

				recordResults.add(recordSummary);
			}

			return recordResults;
		}

		private List<RecordResult> getMockedRecordSuccesses(DmlOperation executor, SObjectType objectType, List<SObject> recordsToProcess) {
			List<RecordResult> recordResults = new List<RecordResult>();

			for (SObject record : recordsToProcess) {
				recordResults.add(executor.prepareMockedDml(record));
			}

			return recordResults;
		}

		private Boolean shouldThrowException(OperationType dmlType, SObjectType objectType) {
			return this.thrownExceptionDmlTypes.contains(dmlType) || (this.thrownExceptionDmlTypesByObjectTypes.get(dmlType) ?? new Set<SObjectType>()).contains(objectType);
		}
	}

	private class DmlRecords implements Records {
		private List<SObject> recordsToProcess = new List<SObject>();

		private Map<SObjectField, Object> valueByFieldApiName = new Map<SObjectField, Object>();
		private List<ParentRelationship> parentRelationships = new List<ParentRelationship>();
		private List<ExternalRelationship> externalRelationships = new List<ExternalRelationship>();

		private DmlRecords(List<SObject> records) {
			this.recordsToProcess = records;
		}

		private DmlRecords(Iterable<Id> recordIds) {
			SObjectType objectType = recordIds.iterator().next()?.getSObjectType();

			for (Id recordId : recordIds) {
				this.recordsToProcess.add(objectType.newSObject(recordId));
			}       
		}

		public DmlRecords with(SObjectField field, Object value) {
			this.valueByFieldApiName.put(field, value);
			return this;
		}

		public DmlRecords withRelationship(SObjectField relationshipField, SObject relatedToRecord) {
			this.parentRelationships.add(new ParentRelationship(relationshipField, relatedToRecord));
			return this;
		}

		public DmlRecords withRelationship(SObjectField relationshipField, SObjectField externalIdField, Object externalId) {
			this.externalRelationships.add(new ExternalRelationship(relationshipField, externalIdField, externalId));
			return this;
		}

		public List<Record> get() {
			List<Record> dmlRecords = new List<Record>();

			for (SObject record : this.recordsToProcess) {
				Record dmlRecord = new DmlRecord(record);
				EnhancedRecord enhancedRecord = dmlRecord.get();

				this.populateFieldsValues(enhancedRecord);
				this.populateParentRelationships(enhancedRecord);
				this.populateExternalRelationships(enhancedRecord);

				dmlRecords.add(dmlRecord);
			}

			return dmlRecords;
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
			this.enhancedRecord.withRelationship(new ParentRelationship(relationshipField, relatedToRecord));
			return this;
		}

		public DmlRecord withRelationship(SObjectField relationshipField, SObjectField externalIdField, Object externalId) {
			this.enhancedRecord.withRelationship(new ExternalRelationship(relationshipField, externalIdField, externalId));
			return this;
		}

		public EnhancedRecord get() {
			return this.enhancedRecord;
		}
	}

	global class EnhancedRecord {
		private SObject currentRecord;

		private List<ParentRelationship> parentRelationships = new List<ParentRelationship>();
		private List<ExternalRelationship> externalRelationships = new List<ExternalRelationship>();

		private EnhancedRecord(SObject currentRecord) {
			this.currentRecord = currentRecord;
		}

		private EnhancedRecord(Id currentRecordId) {
			this.currentRecord = currentRecordId?.getSObjectType()?.newSObject(currentRecordId);
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

		private void addToDependencyGraph(OrderDependencyGraph orderDependencyGraph) {
			orderDependencyGraph.registerType(this.getSObjectType());

			for (ParentRelationship parentRelationship : this.parentRelationships) {
				orderDependencyGraph.addDependency(parentRelationship.getRelatedToType(), this.getSObjectType());
			}
		}

		private void resolveRecordRelationships() {
			this.resolveRelationships();
			this.resolveExternalRelationships();
		}

		private void resolveRelationships() {
			for (ParentRelationship parentRelationship : this.parentRelationships) {
				parentRelationship.resolve(this.currentRecord);
			}
		}

		private void resolveExternalRelationships() {
			for (ExternalRelationship externalRelationship : this.externalRelationships) {
				externalRelationship.resolve(this.currentRecord);
			}
		}

		private SObjectType getSObjectType() {
			return this.currentRecord?.getSObjectType();
		}

		private Boolean doesRecordHaveIdSpecified() {
			return String.isNotBlank(this.getRecordId());
		}

		private SObject getRecord() {
			return this.currentRecord;
		}

		private Id getRecordId() {
			return this.currentRecord?.Id;
		}
	}

	private class ParentRelationship {
		private SObject relatedToRecord;
		private SObjectField relationshipField;

		private ParentRelationship(SObjectField relationshipField, SObject relatedToRecord) {
			this.validateRelationshipField(relationshipField);

			this.relationshipField = relationshipField;
			this.relatedToRecord = relatedToRecord;
		}

		private SObjectType getRelatedToType() {
			return this.relatedToRecord.getSObjectType();
		}

		private void resolve(SObject currentRecord) {
			currentRecord.put(this.relationshipField, this.relatedToRecord.Id);
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
			Boolean externalIdFieldIsValid = externalIdField.getDescribe().isExternalId();
	
			if (!externalIdFieldIsValid) {
				throw new DmlException('Invalid argument: externalIdField. Field supplied is not a marked as an External Identifier.');
			}
	
			SObjectType relatedObjectType = relationshipField.getDescribe().getReferenceTo()[0];
			String externalIdFieldName = externalIdField.getDescribe().getName();
	
			Boolean relatedHasExternalIdField = relatedObjectType.getDescribe().fields.getMap().keySet().contains(externalIdFieldName.toLowerCase());
	
			if (!relatedHasExternalIdField) {
				throw new DmlException('Invalid argument: externalIdField. Field supplied is not a known field on the target sObject.');
			}
		}
	}

	private class OrderDependencyGraph {
		private Map<SObjectType, Set<SObjectType>> childrenByType = new Map<SObjectType, Set<SObjectType>>();
		private Map<SObjectType, Integer> parentsRemainingByType = new Map<SObjectType, Integer>();

		private void registerType(SObjectType type) {
			this.ensureTypeRegistered(type);
		}

		private void addDependency(SObjectType parentType, SObjectType childType) {
			this.ensureTypeRegistered(parentType);
			this.ensureTypeRegistered(childType);

			if (this.childrenByType.get(parentType).add(childType)) {
				this.parentsRemainingByType.put(childType, this.parentsRemainingByType.get(childType) + 1);
			}
		}

		private void ensureTypeRegistered(SObjectType type) {
			if (!this.childrenByType.containsKey(type)) {
				this.childrenByType.put(type, new Set<SObjectType>());
			}
			if (!this.parentsRemainingByType.containsKey(type)) {
				this.parentsRemainingByType.put(type, 0);
			}
		}

		// Kahn’s sort algorithm
		private List<SObjectType> getTopologicalOrder() {
			List<SObjectType> parentsTypesWithoutDependencies = this.getTypesWithNoDependencies();
			List<SObjectType> typesExecutionOrder = new List<SObjectType>();

			while (!parentsTypesWithoutDependencies.isEmpty()) {
				SObjectType currentType = parentsTypesWithoutDependencies.remove(0);
				
				typesExecutionOrder.add(currentType);

				for (SObjectType childType : this.childrenByType.get(currentType)) {
					Integer remaining = this.parentsRemainingByType.get(childType) - 1;
					this.parentsRemainingByType.put(childType, remaining);

					if (remaining == 0) {
						parentsTypesWithoutDependencies.add(childType);
					}
				}
			}

			if (typesExecutionOrder.size() < this.parentsRemainingByType.size()) {
				throw new DmlException('Cyclic type dependencies detected during registration graph.');
			}

			return typesExecutionOrder;
		}

		private List<SObjectType> getTypesWithNoDependencies() {
			List<SObjectType> typesWithNoDependencies = new List<SObjectType>();

			for (SObjectType type : this.parentsRemainingByType.keySet()) {
				if (this.parentsRemainingByType.get(type) == 0) {
					typesWithNoDependencies.add(type);
				}
			}

			return typesWithNoDependencies;
		}
	}

	@TestVisible
	private class RandomIdGenerator {
		public Id get(SObjectType objectType) {
			return get(objectType.getDescribe().getKeyPrefix());
		}

		private Id get(String prefix) {
			return Id.valueOf(prefix + '0'.repeat(12 - prefix.length()) + String.valueOf(Math.abs(Crypto.getRandomInteger())).left(3));
		}
	}
}