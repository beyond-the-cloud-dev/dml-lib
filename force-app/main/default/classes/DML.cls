/**
 * Copyright (c) 2026 Beyond The Cloud Sp. z o.o. (BeyondTheCloud.Dev)
 * Licensed under the MIT License (https://github.com/beyond-the-cloud-dev/dml-lib/blob/main/LICENSE)
 *
 * v3.2.0
 *
 * PMD False Positives:
 * - MethodNamingConventions: Some methods are uppercase to indicate that they are "constructors" of other internal classes
 * - ApexDoc - ApexDoc is not needed, code is self-explanatory
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
 * - FieldNamingConventions: Some fields have non-standard naming conventions on purpose
 * - AvoidGlobalModifier - DML has package version
 **/
@SuppressWarnings(
    'PMD.MethodNamingConventions,PMD.ApexDoc,PMD.CyclomaticComplexity,PMD.CognitiveComplexity,PMD.ExcessivePublicCount,PMD.FieldDeclarationsShouldBeAtStart,PMD.AvoidDebugStatements,PMD.OperationWithLimitsInLoop,PMD.ApexCRUDViolation,PMD.ExcessiveClassLength,PMD.NcssTypeCount,PMD.PropertyNamingConventions,PMD.FieldNamingConventions,PMD.AvoidGlobalModifier'
)
@NamespaceAccessible
public inherited sharing class DML implements Commitable {
    @NamespaceAccessible
    public static Commitable Shared {
        get {
            if (Shared == null) {
                Shared = new DML();
            }
            return Shared;
        }
        private set;
    }

    @NamespaceAccessible
    public static Record Record(SObject record) {
        return new DmlRecord(record);
    }

    @NamespaceAccessible
    public static Record Record(Id recordId) {
        return new DmlRecord(recordId);
    }

    @NamespaceAccessible
    public static Records Records(List<SObject> records) {
        return new DmlRecords(records);
    }

    @NamespaceAccessible
    public static Records Records(Iterable<Id> recordIds) {
        return new DmlRecords(recordIds);
    }

    @NamespaceAccessible
    public interface Commitable {
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
        Commitable accessMode(System.AccessLevel accessMode);
        // Sharing Mode
        Commitable withSharing();
        Commitable withoutSharing();
        // Other configs
        Commitable allowPartialSuccess();
        Commitable skipDuplicateRules();
        Commitable includeOperationIdInErrorMessage();
        Commitable options(Database.DmlOptions options);
        Commitable discardWork();
        Commitable commitHook(DML.Hook callback);
        Commitable combineOnDuplicate();
        // Save
        Result dryRun();
        Result commitWork();
        Result commitTransaction(); // make a savepoint and rollback on exception
    }

    @NamespaceAccessible
    public interface Record {
        Record with(SObjectField field, Object value);
        Record withRelationship(SObjectField targetField, SObject relatedRecord);
        Record withRelationship(SObjectField targetField, SObjectField relatedObjectExternalIdField, Object relatedRecordExternalId);

        // for internal use only
        EnhancedRecord get();
        SObjectType getSObjectType();
    }

    @NamespaceAccessible
    public interface Records {
        Records with(SObjectField field, Object value);
        Records withRelationship(SObjectField targetField, SObject relatedRecord);
        Records withRelationship(SObjectField targetField, SObjectField relatedObjectExternalIdField, Object relatedRecordExternalId);

        // for internal use only
        List<Record> get();
        SObjectType getSObjectType();
    }

    @NamespaceAccessible
    public interface Result {
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
        OperationResult insertsOf(SObjectType objectType);
        OperationResult updatesOf(SObjectType objectType);
        OperationResult upsertsOf(SObjectType objectType);
        OperationResult deletesOf(SObjectType objectType);
        OperationResult undeletesOf(SObjectType objectType);
        OperationResult mergesOf(SObjectType objectType);
        OperationResult eventsOf(SObjectType objectType);
    }

    @NamespaceAccessible
    public interface OperationResult {
        // Metadata
        DML.OperationType operationType();
        SObjectType objectType();
        String operationId();
        Boolean hasFailures();
        // Errors
        List<Error> errors();
        Exception exception(); // null unless the whole operation threw
        // Records
        List<SObject> records();
        List<SObject> successes();
        List<SObject> failures();
        // Details
        List<RecordResult> recordResults();
    }

    @NamespaceAccessible
    public interface RecordResult {
        Id id();
        SObject record();
        Boolean isSuccess();
        List<Error> errors();
    }

    @NamespaceAccessible
    public interface Error {
        String message();
        System.StatusCode statusCode();
        List<String> fields();
    }

    // Mocking

    @NamespaceAccessible
    public static DML.Mockable mock(String dmlIdentifier) {
        if (!mockByDmlIdentifier.containsKey(dmlIdentifier)) {
            mockByDmlIdentifier.put(dmlIdentifier, new DmlMock());
        }
        return mockByDmlIdentifier.get(dmlIdentifier);
    }

    @NamespaceAccessible
    public static DML.Result retrieveResultFor(String dmlIdentifier) {
        if (!resultByDmlIdentifier.containsKey(dmlIdentifier)) {
            return new DmlResult();
        }
        return resultByDmlIdentifier.get(dmlIdentifier);
    }

    @NamespaceAccessible
    public interface Mockable {
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

    @NamespaceAccessible
    public interface Hook {
        void before();
        void after(Result result);
    }

    // Logger

    @NamespaceAccessible
    public interface Logger {
        void log(OperationResult result);
    }

    // Implementation

    @NamespaceAccessible
    public enum OperationType {
        INSERT_DML,
        UPSERT_DML,
        UPDATE_DML,
        MERGE_DML,
        DELETE_DML,
        UNDELETE_DML,
        PUBLISH_DML
    }

    private Configuration configuration;
    private OperationsStorage operationsStorage;

    private Orchestrator orchestrator;

    private Hook hook;

    private static Boolean isLoggerInitialized = false;

    @TestVisible
    private static final RandomIdGenerator randomIdGenerator = new RandomIdGenerator();
    private static final Map<String, Result> resultByDmlIdentifier = new Map<String, Result>();
    private static final Map<String, DmlMock> mockByDmlIdentifier = new Map<String, DmlMock>();

    @TestVisible
    private static Logger dmlLogger {
        get {
            if (!isLoggerInitialized) {
                String className = DML.class.getName(); // 'DML' or 'btcdev.DML' when namespaced
                String namespacePrefix = className.contains('.') ? className.substringBefore('.') : null;

                List<ApexTypeImplementor> implementors = [
                    SELECT ClassName, ClassNamespacePrefix
                    FROM ApexTypeImplementor
                    WHERE InterfaceName = 'DML.Logger' AND InterfaceNamespacePrefix = :namespacePrefix AND IsConcrete = TRUE
                    WITH SYSTEM_MODE
                    LIMIT 1
                ];

                if (!implementors.isEmpty()) {
                    Object loggerInstance = Type.forName(implementors[0].ClassNamespacePrefix, implementors[0].ClassName)?.newInstance();
                    dmlLogger = loggerInstance instanceof Logger ? (Logger) loggerInstance : null;
                }

                isLoggerInitialized = true;
            }

            return dmlLogger;
        }
        private set;
    }

    @NamespaceAccessible
    public DML() {
        this.configuration = new Configuration();
        this.operationsStorage = new OperationsStorage();
        this.orchestrator = new DefaultOrchestrator(this.configuration);
    }

    @NamespaceAccessible
    public DML(List<DML.OperationType> operationOrder) {
        this.configuration = new Configuration();
        this.configuration.customOperationOrder(operationOrder);
        this.operationsStorage = new OperationsStorage();
        this.orchestrator = new CustomOrderOrchestrator(this.configuration);
    }

    // Insert

    @NamespaceAccessible
    public Commitable toInsert(SObject record) {
        return this.toInsert(Record(record));
    }

    @NamespaceAccessible
    public Commitable toInsert(Record record) {
        return this.register(this.getInsertOperation(record.getSObjectType()), record);
    }

    @NamespaceAccessible
    public Commitable toInsert(List<SObject> records) {
        return this.toInsert(Records(records));
    }

    @NamespaceAccessible
    public Commitable toInsert(Records records) {
        return this.register(this.getInsertOperation(records.getSObjectType()), records);
    }

    @NamespaceAccessible
    public OperationResult insertImmediately(SObject record) {
        return this.insertImmediately(Record(record));
    }

    @NamespaceAccessible
    public OperationResult insertImmediately(Record record) {
        return this.executeImmediately(this.getInsertOperation(record.getSObjectType()), record);
    }

    @NamespaceAccessible
    public OperationResult insertImmediately(List<SObject> records) {
        return this.insertImmediately(Records(records));
    }

    @NamespaceAccessible
    public OperationResult insertImmediately(Records records) {
        return this.executeImmediately(this.getInsertOperation(records.getSObjectType()), records);
    }

    private InsertOperation getInsertOperation(SObjectType objectType) {
        return new InsertOperation(objectType, this.configuration);
    }

    // Update

    @NamespaceAccessible
    public Commitable toUpdate(SObject record) {
        return this.toUpdate(Record(record));
    }

    @NamespaceAccessible
    public Commitable toUpdate(Record record) {
        return this.register(this.getUpdateOperation(record.getSObjectType()), record);
    }

    @NamespaceAccessible
    public Commitable toUpdate(List<SObject> records) {
        return this.toUpdate(Records(records));
    }

    @NamespaceAccessible
    public Commitable toUpdate(Records records) {
        return this.register(this.getUpdateOperation(records.getSObjectType()), records);
    }

    @NamespaceAccessible
    public OperationResult updateImmediately(SObject record) {
        return this.updateImmediately(Record(record));
    }

    @NamespaceAccessible
    public OperationResult updateImmediately(Record record) {
        return this.executeImmediately(this.getUpdateOperation(record.getSObjectType()), record);
    }

    @NamespaceAccessible
    public OperationResult updateImmediately(List<SObject> records) {
        return this.updateImmediately(Records(records));
    }

    @NamespaceAccessible
    public OperationResult updateImmediately(Records records) {
        return this.executeImmediately(this.getUpdateOperation(records.getSObjectType()), records);
    }

    private UpdateOperation getUpdateOperation(SObjectType objectType) {
        return new UpdateOperation(objectType, this.configuration);
    }

    // Upsert

    @NamespaceAccessible
    public Commitable toUpsert(SObject record) {
        return this.toUpsert(Record(record));
    }

    @NamespaceAccessible
    public Commitable toUpsert(SObject record, SObjectField externalIdField) {
        return this.register(this.getUpsertOperation(record.getSObjectType()).withExternalIdField(externalIdField), Record(record));
    }

    @NamespaceAccessible
    public Commitable toUpsert(Record record) {
        return this.register(this.getUpsertOperation(record.getSObjectType()), record);
    }

    @NamespaceAccessible
    public Commitable toUpsert(List<SObject> records) {
        return this.toUpsert(Records(records));
    }

    @NamespaceAccessible
    public Commitable toUpsert(List<SObject> records, SObjectField externalIdField) {
        Records dmlRecords = Records(records);
        return this.register(this.getUpsertOperation(dmlRecords.getSObjectType()).withExternalIdField(externalIdField), dmlRecords);
    }

    @NamespaceAccessible
    public Commitable toUpsert(Records records) {
        return this.register(this.getUpsertOperation(records.getSObjectType()), records);
    }

    @NamespaceAccessible
    public OperationResult upsertImmediately(SObject record) {
        return this.upsertImmediately(Record(record));
    }

    @NamespaceAccessible
    public OperationResult upsertImmediately(Record record) {
        return this.executeImmediately(this.getUpsertOperation(record.getSObjectType()), record);
    }

    @NamespaceAccessible
    public OperationResult upsertImmediately(List<SObject> records) {
        return this.upsertImmediately(Records(records));
    }

    @NamespaceAccessible
    public OperationResult upsertImmediately(Records records) {
        return this.executeImmediately(this.getUpsertOperation(records.getSObjectType()), records);
    }

    private UpsertOperation getUpsertOperation(SObjectType objectType) {
        return new UpsertOperation(objectType, this.configuration);
    }

    // Delete

    @NamespaceAccessible
    public Commitable toDelete(Id recordId) {
        return this.toDelete(Record(recordId));
    }

    @NamespaceAccessible
    public Commitable toDelete(SObject record) {
        return this.toDelete(Record(record));
    }

    private Commitable toDelete(Record record) {
        return this.register(this.getDeleteOperation(record.getSObjectType()), record);
    }

    @NamespaceAccessible
    public Commitable toDelete(Iterable<Id> recordIds) {
        return this.toDelete(Records(recordIds));
    }

    @NamespaceAccessible
    public Commitable toDelete(List<SObject> records) {
        return this.toDelete(Records(records));
    }

    private Commitable toDelete(Records records) {
        return this.register(this.getDeleteOperation(records.getSObjectType()), records);
    }

    @NamespaceAccessible
    public OperationResult deleteImmediately(Id recordId) {
        return this.deleteImmediately(Record(recordId));
    }

    @NamespaceAccessible
    public OperationResult deleteImmediately(SObject record) {
        return this.deleteImmediately(Record(record));
    }

    private OperationResult deleteImmediately(Record record) {
        return this.executeImmediately(this.getDeleteOperation(record.getSObjectType()), record);
    }

    @NamespaceAccessible
    public OperationResult deleteImmediately(Iterable<Id> recordIds) {
        return this.deleteImmediately(Records(recordIds));
    }

    @NamespaceAccessible
    public OperationResult deleteImmediately(List<SObject> records) {
        return this.deleteImmediately(Records(records));
    }

    private OperationResult deleteImmediately(Records records) {
        return this.executeImmediately(this.getDeleteOperation(records.getSObjectType()), records);
    }

    private DeleteOperation getDeleteOperation(SObjectType objectType) {
        return new DeleteOperation(objectType, this.configuration);
    }

    // Hard Delete

    @NamespaceAccessible
    public Commitable toHardDelete(Id recordId) {
        Record dmlRecord = Record(recordId);
        return this.register(this.getDeleteOperation(dmlRecord.getSObjectType()).withHardDelete(), dmlRecord);
    }

    @NamespaceAccessible
    public Commitable toHardDelete(SObject record) {
        Record dmlRecord = Record(record);
        return this.register(this.getDeleteOperation(dmlRecord.getSObjectType()).withHardDelete(), dmlRecord);
    }

    @NamespaceAccessible
    public Commitable toHardDelete(Iterable<Id> recordIds) {
        Records dmlRecords = Records(recordIds);
        return this.register(this.getDeleteOperation(dmlRecords.getSObjectType()).withHardDelete(), dmlRecords);
    }

    @NamespaceAccessible
    public Commitable toHardDelete(List<SObject> records) {
        Records dmlRecords = Records(records);
        return this.register(this.getDeleteOperation(dmlRecords.getSObjectType()).withHardDelete(), dmlRecords);
    }

    // Undelete

    @NamespaceAccessible
    public Commitable toUndelete(Id recordId) {
        return this.toUndelete(Record(recordId));
    }

    @NamespaceAccessible
    public Commitable toUndelete(SObject record) {
        return this.toUndelete(Record(record));
    }

    private Commitable toUndelete(Record record) {
        return this.register(this.getUndeleteOperation(record.getSObjectType()), record);
    }

    @NamespaceAccessible
    public Commitable toUndelete(Iterable<Id> recordIds) {
        return this.toUndelete(Records(recordIds));
    }

    @NamespaceAccessible
    public Commitable toUndelete(List<SObject> records) {
        return this.toUndelete(Records(records));
    }

    private Commitable toUndelete(Records records) {
        return this.register(this.getUndeleteOperation(records.getSObjectType()), records);
    }

    @NamespaceAccessible
    public OperationResult undeleteImmediately(Id recordId) {
        return this.undeleteImmediately(Record(recordId));
    }

    @NamespaceAccessible
    public OperationResult undeleteImmediately(SObject record) {
        return this.undeleteImmediately(Record(record));
    }

    private OperationResult undeleteImmediately(Record record) {
        return this.executeImmediately(this.getUndeleteOperation(record.getSObjectType()), record);
    }

    @NamespaceAccessible
    public OperationResult undeleteImmediately(Iterable<Id> recordIds) {
        return this.undeleteImmediately(Records(recordIds));
    }

    @NamespaceAccessible
    public OperationResult undeleteImmediately(List<SObject> records) {
        return this.undeleteImmediately(Records(records));
    }

    private OperationResult undeleteImmediately(Records records) {
        return this.executeImmediately(this.getUndeleteOperation(records.getSObjectType()), records);
    }

    private UndeleteOperation getUndeleteOperation(SObjectType objectType) {
        return new UndeleteOperation(objectType, this.configuration);
    }

    // Merge

    @NamespaceAccessible
    public Commitable toMerge(SObject mergeToRecord, SObject duplicatedRecord) {
        Record dmlMergeToRecord = Record(mergeToRecord);
        return this.toMerge(this.getMergeOperation(dmlMergeToRecord.getSObjectType(), dmlMergeToRecord), Record(duplicatedRecord));
    }

    @NamespaceAccessible
    public Commitable toMerge(SObject mergeToRecord, Id duplicatedRecordId) {
        Record dmlMergeToRecord = Record(mergeToRecord);
        return this.toMerge(this.getMergeOperation(dmlMergeToRecord.getSObjectType(), dmlMergeToRecord), Record(duplicatedRecordId));
    }

    private Commitable toMerge(MergeOperation mergeOperation, Record duplicatedRecord) {
        return this.register(mergeOperation, duplicatedRecord);
    }

    @NamespaceAccessible
    public Commitable toMerge(SObject mergeToRecord, List<SObject> duplicateRecords) {
        Record dmlMergeToRecord = Record(mergeToRecord);
        return this.toMerge(this.getMergeOperation(dmlMergeToRecord.getSObjectType(), dmlMergeToRecord), Records(duplicateRecords));
    }

    @NamespaceAccessible
    public Commitable toMerge(SObject mergeToRecord, Iterable<Id> duplicatedRecordIds) {
        Record dmlMergeToRecord = Record(mergeToRecord);
        return this.toMerge(this.getMergeOperation(dmlMergeToRecord.getSObjectType(), dmlMergeToRecord), Records(duplicatedRecordIds));
    }

    private Commitable toMerge(MergeOperation mergeOperation, Records duplicateRecords) {
        return this.register(mergeOperation, duplicateRecords);
    }

    private MergeOperation getMergeOperation(SObjectType objectType, Record mergeToRecord) {
        return new MergeOperation(objectType, this.configuration, mergeToRecord);
    }

    // Platform Event

    @NamespaceAccessible
    public Commitable toPublish(SObject record) {
        Record dmlRecord = Record(record);
        return this.register(this.getPlatformEventOperation(dmlRecord.getSObjectType()), dmlRecord);
    }

    @NamespaceAccessible
    public Commitable toPublish(List<SObject> records) {
        Records dmlRecords = Records(records);
        return this.register(this.getPlatformEventOperation(dmlRecords.getSObjectType()), dmlRecords);
    }

    @NamespaceAccessible
    public OperationResult publishImmediately(SObject record) {
        Record dmlRecord = Record(record);
        return this.executeImmediately(this.getPlatformEventOperation(dmlRecord.getSObjectType()), dmlRecord);
    }

    @NamespaceAccessible
    public OperationResult publishImmediately(List<SObject> records) {
        Records dmlRecords = Records(records);
        return this.executeImmediately(this.getPlatformEventOperation(dmlRecords.getSObjectType()), dmlRecords);
    }

    private PlatformEventOperation getPlatformEventOperation(SObjectType objectType) {
        return new PlatformEventOperation(objectType, this.configuration);
    }

    // Helpers

    private OperationResult executeImmediately(DmlOperation operation, Record record) {
        DmlOperation existing = this.operationsStorage.getOrRegister(operation);
        OperationResult result = existing.execute(new List<EnhancedRecord>{ record.get() });
        this.storeResult(result);
        return result;
    }

    private OperationResult executeImmediately(DmlOperation operation, Records records) {
        DmlOperation existing = this.operationsStorage.getOrRegister(operation);
        OperationResult result = existing.execute(records);
        this.storeResult(result);
        return result;
    }

    private Commitable register(DmlOperation operation, Record record) {
        this.orchestrator.register(this.operationsStorage.getOrRegister(operation), record);
        return this;
    }

    private Commitable register(DmlOperation operation, Records records) {
        this.orchestrator.register(this.operationsStorage.getOrRegister(operation), records);
        return this;
    }

    // Identifier

    @NamespaceAccessible
    public Commitable identifier(String dmlIdentifier) {
        this.configuration.identifier(dmlIdentifier);
        return this;
    }

    // Debug

    @NamespaceAccessible
    public void preview() {
        this.configuration.preview();
    }

    // Field Level Security

    @NamespaceAccessible
    public Commitable userMode() {
        return this.accessMode(System.AccessLevel.USER_MODE);
    }

    @NamespaceAccessible
    public Commitable systemMode() {
        return this.accessMode(System.AccessLevel.SYSTEM_MODE);
    }

    @NamespaceAccessible
    public Commitable accessMode(System.AccessLevel accessMode) {
        this.configuration.accessMode(accessMode);
        return this;
    }

    // Sharing Mode

    @NamespaceAccessible
    public Commitable withSharing() {
        this.configuration.withSharing();
        return this;
    }

    @NamespaceAccessible
    public Commitable withoutSharing() {
        this.configuration.withoutSharing();
        return this;
    }

    // Other configs

    @NamespaceAccessible
    public Commitable allowPartialSuccess() {
        this.configuration.allowPartialSuccess();
        return this;
    }

    @NamespaceAccessible
    public Commitable skipDuplicateRules() {
        this.configuration.skipDuplicateRules();
        return this;
    }

    @NamespaceAccessible
    public Commitable includeOperationIdInErrorMessage() {
        this.configuration.includeOperationIdInErrorMessage();
        return this;
    }

    @NamespaceAccessible
    public Commitable combineOnDuplicate() {
        this.configuration.combineOnDuplicate();
        return this;
    }

    @NamespaceAccessible
    public Commitable options(Database.DmlOptions options) {
        this.configuration.options(options);
        return this;
    }

    @NamespaceAccessible
    public Commitable discardWork() {
        this.reset();
        return this;
    }

    // Hooks

    @NamespaceAccessible
    public Commitable commitHook(Hook callback) {
        this.hook = callback;
        return this;
    }

    @NamespaceAccessible
    public Result dryRun() {
        Savepoint savePoint = Database.setSavepoint();

        try {
            DmlResult result = new DmlResult();

            this.hook?.before();

            this.orchestrator.execute(result);

            this.hook?.after(result);

            return result;
        } finally {
            Database.rollback(savePoint);
            Database.releaseSavepoint(savePoint);
        }
    }

    @NamespaceAccessible
    public Result commitWork() {
        DmlResult result = new DmlResult();

        try {
            this.hook?.before();

            this.orchestrator.execute(result);

            this.storeResult(result);

            this.hook?.after(result);
        } finally {
            this.reset();
        }

        return result;
    }

    private void storeResult(DmlResult result) {
        if (String.isBlank(this.configuration.dmlIdentifier)) {
            return;
        }

        for (OperationResult operationResult : result.all()) {
            this.storeResult(operationResult);
        }
    }

    private void storeResult(OperationResult operationResult) {
        if (String.isBlank(this.configuration.dmlIdentifier)) {
            return;
        }

        DmlResult result = (DmlResult) resultByDmlIdentifier.get(this.configuration.dmlIdentifier);

        if (result == null) {
            result = new DmlResult();
        }

        result.add(operationResult);

        resultByDmlIdentifier.put(this.configuration.dmlIdentifier, result);
    }

    @NamespaceAccessible
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

    private void reset() {
        if (this.configuration.customOperationOrder == null) {
            this.orchestrator = new DefaultOrchestrator(this.configuration);
            return;
        }

        this.orchestrator = new CustomOrderOrchestrator(this.configuration);
    }

    private class OperationsStorage {
        private Map<String, DmlOperation> operationByBucketKey = new Map<String, DmlOperation>();

        private DmlOperation getOrRegister(DmlOperation candidate) {
            String bucketKey = candidate.bucketKey();

            DmlOperation existing = this.operationByBucketKey.get(bucketKey);

            if (existing == null) {
                this.operationByBucketKey.put(bucketKey, candidate);
                return candidate;
            }

            return existing;
        }
    }

    public interface Orchestrator {
        void register(DmlOperation operation, Records records);
        void register(DmlOperation operation, Record record);
        void execute(DmlResult result);
    }

    private class DefaultOrchestrator implements Orchestrator {
        private LinearOrchestrator linearOrchestrator;
        private Orchestrator dependencyOrchestrator;

        private DefaultOrchestrator(Configuration configuration) {
            this.linearOrchestrator = new LinearOrchestrator(configuration);
            this.dependencyOrchestrator = new DependencyOrchestrator();
        }

        public void register(DmlOperation operation, Records records) {
            this.route(operation).register(operation, records);
        }

        public void register(DmlOperation operation, Record record) {
            this.route(operation).register(operation, record);
        }

        private Orchestrator route(DmlOperation operation) {
            final List<OperationType> dependencyOperations = new List<OperationType>{ OperationType.INSERT_DML, OperationType.UPSERT_DML };
            return dependencyOperations.contains(operation.getOperationType()) ? this.dependencyOrchestrator : this.linearOrchestrator;
        }

        public void execute(DmlResult result) {
            this.dependencyOrchestrator.execute(result);
            this.linearOrchestrator.execute(result);
        }
    }

    private class DependencyOrchestrator implements Orchestrator {
        private Map<Id, EnhancedRecord> enhancedRecordsById = new Map<Id, EnhancedRecord>();
        private List<EnhancedRecord> enhancedRecords = new List<EnhancedRecord>();

        private OrderDependencyGraph orderDependencyGraph = new OrderDependencyGraph();

        public void register(DmlOperation operation, Records records) {
            for (Record record : records.get()) {
                this.register(operation, record);
            }
        }

        public void register(DmlOperation operation, Record record) {
            EnhancedRecord enhancedRecord = record.get();

            enhancedRecord.setOperation(operation);

            this.enhancedRecords.add(enhancedRecord);
        }

        public void execute(DmlResult result) {
            this.addTemporaryIdsToBuildDependencyGraph();

            List<List<Id>> executionWaves = this.orderDependencyGraph.computeExecutionWaves();

            for (List<Id> waveRecordIds : executionWaves) {
                for (OperationBucket operationBucket : this.groupRecordsByOperation(waveRecordIds)) {
                    result.add(operationBucket.operation.commitWork(operationBucket.records));
                }
            }
        }

        private void addTemporaryIdsToBuildDependencyGraph() {
            for (EnhancedRecord enhancedRecord : this.enhancedRecords) {
                enhancedRecord.setTemporaryId();

                if (this.enhancedRecordsById.containsKey(enhancedRecord.getRecordId())) {
                    throw new DmlException('Duplicate records found during registration. Fix the code.');
                }

                this.enhancedRecordsById.put(enhancedRecord.getRecordId(), enhancedRecord);
            }

            for (EnhancedRecord enhancedRecord : this.enhancedRecords) {
                enhancedRecord.addToDependencyGraph(this.orderDependencyGraph);
            }
        }

        private List<OperationBucket> groupRecordsByOperation(List<Id> enhancedRecordIds) {
            Map<String, OperationBucket> bucketsByKey = new Map<String, OperationBucket>();

            for (Id enhancedRecordId : enhancedRecordIds) {
                EnhancedRecord enhancedRecord = this.enhancedRecordsById.get(enhancedRecordId);

                if (enhancedRecord == null) {
                    // record was committed without unit of work, or executeImmediately was used
                    // so it was not registered in the dependency graph
                    continue;
                }

                enhancedRecord.clearTemporaryId();

                String bucketKey = enhancedRecord.operation.bucketKey();

                if (!bucketsByKey.containsKey(bucketKey)) {
                    bucketsByKey.put(bucketKey, new OperationBucket(enhancedRecord.operation));
                }

                bucketsByKey.get(bucketKey).add(enhancedRecord);
            }

            return bucketsByKey.values();
        }
    }

    private class LinearOrchestrator implements Orchestrator {
        private Map<String, OperationBucket> bucketByKey = new Map<String, OperationBucket>();
        private Map<OperationType, List<OperationBucket>> bucketsByOperationType = new Map<OperationType, List<OperationBucket>>{
            OperationType.UPDATE_DML => new List<OperationBucket>(),
            OperationType.MERGE_DML => new List<OperationBucket>(),
            OperationType.DELETE_DML => new List<OperationBucket>(),
            OperationType.UNDELETE_DML => new List<OperationBucket>(),
            OperationType.PUBLISH_DML => new List<OperationBucket>()
        };

        private Configuration configuration;

        private LinearOrchestrator(Configuration configuration) {
            this.configuration = configuration;
        }

        public void register(DmlOperation operation, Records records) {
            for (Record record : records.get()) {
                this.register(operation, record);
            }
        }

        public void register(DmlOperation operation, Record record) {
            EnhancedRecord enhancedRecord = record.get();

            this.assignRecordToBucket(operation, enhancedRecord);
        }

        private void assignRecordToBucket(DmlOperation operation, EnhancedRecord enhancedRecord) {
            OperationBucket operationBucket = this.bucketByKey.get(operation.bucketKey());

            if (operationBucket == null) {
                operationBucket = new OperationBucket(operation, this.configuration);

                this.bucketByKey.put(operation.bucketKey(), operationBucket);
                this.bucketsByOperationType.get(operation.getOperationType()).add(operationBucket);
            }

            if (operationBucket.hasDuplicate(enhancedRecord)) {
                operationBucket.executeDuplicateStrategy(enhancedRecord);
                return;
            }

            operationBucket.add(enhancedRecord);
        }

        public void execute(DmlResult result) {
            for (OperationType operationType : this.bucketsByOperationType.keySet()) {
                for (OperationBucket operationBucket : this.bucketsByOperationType.get(operationType)) {
                    result.add(operationBucket.operation.commitWork(operationBucket.records));
                }
            }
        }
    }

    private class CustomOrderOrchestrator implements Orchestrator {
        private Map<String, OperationBucket> bucketByKey = new Map<String, OperationBucket>();
        private Map<OperationType, List<OperationBucket>> bucketsByOperationType = new Map<OperationType, List<OperationBucket>>();

        private Configuration configuration;

        private CustomOrderOrchestrator(Configuration configuration) {
            this.configuration = configuration;
            this.initializeBuckets();
        }

        private void initializeBuckets() {
            for (DML.OperationType operationType : this.configuration.customOperationOrder) {
                if (!this.bucketsByOperationType.containsKey(operationType)) {
                    this.bucketsByOperationType.put(operationType, new List<OperationBucket>());
                }
            }
        }

        public void register(DmlOperation operation, Records records) {
            for (Record record : records.get()) {
                this.register(operation, record);
            }
        }

        public void register(DmlOperation operation, Record record) {
            EnhancedRecord enhancedRecord = record.get();

            if (!this.bucketsByOperationType.containsKey(operation.getOperationType())) {
                throw new DmlException(operation.getOperationType() + ' operation is not listed in the custom operation order.');
            }

            this.assignRecordToBucket(operation, enhancedRecord);
        }

        private void assignRecordToBucket(DmlOperation operation, EnhancedRecord enhancedRecord) {
            OperationBucket operationBucket = this.bucketByKey.get(operation.bucketKey());

            if (operationBucket == null) {
                operationBucket = new OperationBucket(operation, this.configuration);

                this.bucketByKey.put(operation.bucketKey(), operationBucket);
                this.bucketsByOperationType.get(operation.getOperationType()).add(operationBucket);
            }

            if (operationBucket.hasDuplicate(enhancedRecord)) {
                operationBucket.executeDuplicateStrategy(enhancedRecord);
                return;
            }

            operationBucket.add(enhancedRecord);
        }

        public void execute(DmlResult result) {
            for (OperationType operationType : this.bucketsByOperationType.keySet()) {
                for (OperationBucket operationBucket : this.bucketsByOperationType.get(operationType)) {
                    result.add(operationBucket.operation.commitWork(operationBucket.records));
                }
            }
        }
    }

    private class OperationBucket {
        private DmlOperation operation;
        private Configuration configuration;

        private Map<Id, EnhancedRecord> recordsById = new Map<Id, EnhancedRecord>();
        private List<EnhancedRecord> records = new List<EnhancedRecord>();

        private OperationBucket(DmlOperation operation) {
            this.operation = operation;
        }

        private OperationBucket(DmlOperation operation, Configuration configuration) {
            this(operation);
            this.configuration = configuration;
        }

        private Boolean hasDuplicate(EnhancedRecord newRecord) {
            return newRecord.hasId() && this.recordsById.containsKey(newRecord.getRecordId());
        }

        private void executeDuplicateStrategy(EnhancedRecord newRecord) {
            EnhancedRecord existingRecord = this.recordsById.get(newRecord.getRecordId());

            this.configuration.duplicateCombineStrategy.combine(existingRecord, newRecord);
        }

        private void add(EnhancedRecord newRecord) {
            this.records.add(newRecord);

            if (newRecord.hasId()) {
                this.recordsById.put(newRecord.getRecordId(), newRecord);
            }
        }
    }

    private class DmlResult implements Result {
        private Map<OperationType, Map<SObjectType, SObjectAggregatedResult>> operationResultsByObjectType = new Map<OperationType, Map<SObjectType, SObjectAggregatedResult>>();

        private DmlResult() {
            for (OperationType operationType : OperationType.values()) {
                this.operationResultsByObjectType.put(operationType, new Map<SObjectType, SObjectAggregatedResult>());
            }
        }

        private DmlResult add(OperationResult result) {
            OperationType operationType = result.operationType();
            SObjectType objectType = result.objectType();

            SObjectAggregatedResult aggregatedResult = this.operationResultsByObjectType.get(operationType).get(objectType);

            if (aggregatedResult == null) {
                aggregatedResult = new SObjectAggregatedResult(operationType, objectType);
                this.operationResultsByObjectType.get(operationType).put(objectType, aggregatedResult);
            }

            aggregatedResult.add(result);

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
            return this.operationResultsByObjectType.get(operationType).get(objectType) ?? new SObjectAggregatedResult(operationType, objectType);
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
        private System.AccessLevel accessMode = System.AccessLevel.USER_MODE;
        private Database.DmlOptions options = new Database.DmlOptions();
        private DmlSharing sharingExecutor = new InheritedSharing();
        private DuplicateCombineStrategy duplicateCombineStrategy = new ThrownExceptionDuplicateStrategy();
        private Boolean allOrNone = true;
        private Boolean includeOperationIdInErrorMessage = false;
        private String dmlIdentifier = null;
        private List<DML.OperationType> customOperationOrder = null;

        private Configuration() {
            this.options.optAllOrNone = true;
        }

        private void accessMode(System.AccessLevel accessMode) {
            this.accessMode = accessMode;
        }

        private void withSharing() {
            this.sharingExecutor = new WithSharing();
        }

        private void withoutSharing() {
            this.sharingExecutor = new WithoutSharing();
        }

        private void identifier(String dmlIdentifier) {
            this.dmlIdentifier = dmlIdentifier;
        }

        private void customOperationOrder(List<DML.OperationType> operationOrder) {
            this.customOperationOrder = operationOrder;
        }

        private void allowPartialSuccess() {
            this.allOrNone = false;
            this.options.optAllOrNone = false;
        }

        private void combineOnDuplicate() {
            this.duplicateCombineStrategy = new MergeDuplicateStrategy();
        }

        private void options(Database.DmlOptions options) {
            this.options = options;
            this.options.optAllOrNone = this.options.optAllOrNone ?? this.allOrNone ?? true;
            this.allOrNone = this.options.optAllOrNone;
        }

        private void preview() {
            System.debug(
                LoggingLevel.ERROR,
                '\n\n============ DML Configuration ============' +
                    '\nOptions: ' +
                    JSON.serializePretty(this.options) +
                    '\nSharing Executor: ' +
                    String.valueOf(this.sharingExecutor).split(':')[0] +
                    '\nAll Or None: ' +
                    this.allOrNone +
                    '\nDML Identifier: ' +
                    this.dmlIdentifier +
                    '\n=======================================\n'
            );
        }

        private void includeOperationIdInErrorMessage() {
            this.includeOperationIdInErrorMessage = true;
        }

        private void skipDuplicateRules() {
            this.options.duplicateRuleHeader.allowSave = true;
        }
    }

    private abstract class DmlOperation {
        private SObjectType objectType;
        private Configuration globalConfiguration;
        private final String operationId = UUID.randomUUID().toString();

        protected DmlOperation(SObjectType objectType, Configuration configuration) {
            this.objectType = objectType;
            this.globalConfiguration = configuration;
        }

        private SObjectType getObjectType() {
            return this.objectType;
        }

        private OperationResult commitWork(List<EnhancedRecord> records) {
            return this.globalConfiguration.sharingExecutor.execute(this, records);
        }

        private OperationResult execute(Records records) {
            List<EnhancedRecord> enhancedRecords = new List<EnhancedRecord>();

            for (Record record : records.get()) {
                enhancedRecords.add(record.get());
            }

            return this.execute(enhancedRecords);
        }

        private OperationResult execute(List<EnhancedRecord> records) {
            this.validate(records);

            List<SObject> recordsToProcess = this.getRecordsToProcess(records);

            ExecutionResult result = new ExecutionResult(this.getOperationType(), this.objectType, this.operationId).setRecords(recordsToProcess);

            DmlMock dmlMock = mockByDmlIdentifier.get(this.globalConfiguration.dmlIdentifier);

            if (dmlMock != null && dmlMock.shouldBeMocked(this.getOperationType(), this.objectType)) {
                return result.setRecordResults(dmlMock.getMockedRecordResults(this, recordsToProcess));
            }

            try {
                result.setRecordResults(this.getResultAdapter().get(this.executeDml(recordsToProcess), recordsToProcess));
            } catch (Exception e) {
                this.log(result.setException(e).setRecordResults(this.getFailedRecordResults(recordsToProcess, e)));

                if (this.globalConfiguration.includeOperationIdInErrorMessage) {
                    e.setMessage(e.getMessage() + ' | Contact your administrator with Error ID: ' + this.operationId);
                }

                throw e;
            }

            if (result.hasFailures()) {
                this.log(result);
            }

            return result;
        }

        private void log(OperationResult result) {
            dmlLogger?.log(result);
        }

        private List<RecordResult> getFailedRecordResults(List<SObject> recordsToProcess, Exception e) {
            Map<Integer, List<RecordProcessingError>> errorsByRowIndex = this.getRowErrors(e);
            List<RecordResult> failedRecordResults = new List<RecordResult>();

            for (Integer i = 0; i < recordsToProcess.size(); i++) {
                SObject record = recordsToProcess[i];
                DmlRecordResult failedRecord = new DmlRecordResult().isSuccess(false).recordId(record.Id).record(record);

                for (RecordProcessingError rowError : errorsByRowIndex.get(i) ?? new List<RecordProcessingError>()) {
                    failedRecord.error(rowError);
                }

                failedRecordResults.add(failedRecord);
            }

            return failedRecordResults;
        }

        private Map<Integer, List<RecordProcessingError>> getRowErrors(Exception e) {
            Map<Integer, List<RecordProcessingError>> errorsByRowIndex = new Map<Integer, List<RecordProcessingError>>();

            if (!(e instanceof DmlException)) {
                return errorsByRowIndex;
            }

            DmlException dmlException = (DmlException) e;

            for (Integer i = 0; i < dmlException.getNumDml(); i++) {
                Integer rowIndex = dmlException.getDmlIndex(i);

                if (!errorsByRowIndex.containsKey(rowIndex)) {
                    errorsByRowIndex.put(rowIndex, new List<RecordProcessingError>());
                }

                errorsByRowIndex.get(rowIndex)
                    .add(
                        new RecordProcessingError().setMessage(dmlException.getDmlMessage(i)).setStatusCode(dmlException.getDmlType(i)).setFields(dmlException.getDmlFieldNames(i))
                    );
            }

            return errorsByRowIndex;
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
        protected abstract DmlResultAdapter getResultAdapter();
        protected abstract List<Object> executeDml(List<SObject> recordsToProcess);
        protected abstract DmlRecordResult executeMockedDml(SObject record);

        private void validate(List<EnhancedRecord> records) {
            for (EnhancedRecord enhancedRecord : records) {
                this.validate(enhancedRecord);
            }
        }

        protected virtual void validate(EnhancedRecord enhancedRecord) {
            return;
        }

        protected virtual String bucketKey() {
            return this.getOperationType().name() + '_' + (this.getObjectType()?.toString() ?? 'EMPTY');
        }
    }

    // Operations

    private inherited sharing class InsertOperation extends DmlOperation {
        private InsertOperation(SObjectType objectType, Configuration configuration) {
            super(objectType, configuration);
        }

        protected override OperationType getOperationType() {
            return OperationType.INSERT_DML;
        }

        protected override DmlResultAdapter getResultAdapter() {
            return new SaveResultAdapter();
        }

        protected override void validate(EnhancedRecord enhancedRecord) {
            if (enhancedRecord.hasId()) {
                throw new DmlException('Only records without an Id can be registered as new.');
            }
        }

        protected override List<Object> executeDml(List<SObject> recordsToProcess) {
            return Database.insert(recordsToProcess, this.globalConfiguration.options, this.globalConfiguration.accessMode);
        }

        protected override DmlRecordResult executeMockedDml(SObject record) {
            record.put('Id', randomIdGenerator.get(record.getSObjectType()));
            return new DmlRecordResult().isSuccess(true).recordId(record.Id).record(record);
        }
    }

    private inherited sharing class UpsertOperation extends DmlOperation {
        private SObjectField externalIdField;

        private UpsertOperation(SObjectType objectType, Configuration configuration) {
            super(objectType, configuration);
        }

        private UpsertOperation withExternalIdField(SObjectField externalIdField) {
            this.externalIdField = externalIdField;
            return this;
        }

        protected override String bucketKey() {
            String externalId = this.externalIdField == null ? 'Id' : this.externalIdField.toString();
            return super.bucketKey() + '_' + externalId;
        }

        protected override OperationType getOperationType() {
            return OperationType.UPSERT_DML;
        }

        protected override DmlResultAdapter getResultAdapter() {
            return new UpsertResultAdapter();
        }

        protected override List<Object> executeDml(List<SObject> recordsToProcess) {
            if (this.externalIdField == null) {
                return Database.upsert(recordsToProcess, this.globalConfiguration.allOrNone, this.globalConfiguration.accessMode);
            }

            return Database.upsert(recordsToProcess, this.externalIdField, this.globalConfiguration.allOrNone, this.globalConfiguration.accessMode);
        }

        protected override DmlRecordResult executeMockedDml(SObject record) {
            if (record.Id == null) {
                record.put('Id', randomIdGenerator.get(record.getSObjectType()));
            }
            return new DmlRecordResult().isSuccess(true).recordId(record.Id).record(record);
        }
    }

    private inherited sharing class UpdateOperation extends DmlOperation {
        private UpdateOperation(SObjectType objectType, Configuration configuration) {
            super(objectType, configuration);
        }

        protected override OperationType getOperationType() {
            return OperationType.UPDATE_DML;
        }

        protected override DmlResultAdapter getResultAdapter() {
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

        protected override DmlRecordResult executeMockedDml(SObject record) {
            return new DmlRecordResult().isSuccess(true).recordId(record.Id).record(record);
        }
    }

    private inherited sharing class MergeOperation extends DmlOperation {
        private EnhancedRecord mergeToRecord;

        private MergeOperation(SObjectType objectType, Configuration configuration, Record mergeToRecord) {
            super(objectType, configuration);
            this.validate(mergeToRecord.get());
            this.mergeToRecord = mergeToRecord.get();
        }

        protected override String bucketKey() {
            return super.bucketKey() + '_' + this.mergeToRecord.getRecordId();
        }

        protected override OperationType getOperationType() {
            return OperationType.MERGE_DML;
        }

        protected override DmlResultAdapter getResultAdapter() {
            return new MergeResultAdapter();
        }

        protected override void validate(EnhancedRecord enhancedRecord) {
            if (!enhancedRecord.hasId()) {
                throw new DmlException('Only existing records can be merged.');
            }
        }

        protected override List<Object> executeDml(List<SObject> recordsToProcess) {
            return Database.merge(this.mergeToRecord.getRecord(), recordsToProcess, this.globalConfiguration.allOrNone, this.globalConfiguration.accessMode);
        }

        protected override DmlRecordResult executeMockedDml(SObject record) {
            return new DmlRecordResult().isSuccess(true).recordId(record.Id).record(record);
        }
    }

    private inherited sharing class DeleteOperation extends DmlOperation {
        private Boolean isHardDelete = false;

        private DeleteOperation(SObjectType objectType, Configuration configuration) {
            super(objectType, configuration);
        }

        private DeleteOperation withHardDelete() {
            this.isHardDelete = true;
            return this;
        }

        protected override String bucketKey() {
            return super.bucketKey() + '_' + this.isHardDelete;
        }

        protected override OperationType getOperationType() {
            return OperationType.DELETE_DML;
        }

        protected override DmlResultAdapter getResultAdapter() {
            return new DeleteResultAdapter();
        }

        protected override void validate(EnhancedRecord enhancedRecord) {
            if (!enhancedRecord.hasId()) {
                throw new DmlException('Only existing records can be registered as deleted.');
            }
        }

        protected override List<Object> executeDml(List<SObject> recordsToProcess) {
            List<Object> dmlResults = Database.delete(recordsToProcess, this.globalConfiguration.allOrNone, this.globalConfiguration.accessMode);

            if (this.isHardDelete) {
                Database.emptyRecycleBin(recordsToProcess);
            }

            return dmlResults;
        }

        protected override DmlRecordResult executeMockedDml(SObject record) {
            return new DmlRecordResult().isSuccess(true).recordId(record.Id).record(record);
        }
    }

    private inherited sharing class UndeleteOperation extends DmlOperation {
        private UndeleteOperation(SObjectType objectType, Configuration configuration) {
            super(objectType, configuration);
        }

        protected override OperationType getOperationType() {
            return OperationType.UNDELETE_DML;
        }

        protected override DmlResultAdapter getResultAdapter() {
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

        protected override DmlRecordResult executeMockedDml(SObject record) {
            return new DmlRecordResult().isSuccess(true).recordId(record.Id).record(record);
        }
    }

    private inherited sharing class PlatformEventOperation extends DmlOperation {
        private PlatformEventOperation(SObjectType objectType, Configuration configuration) {
            super(objectType, configuration);
        }

        protected override OperationType getOperationType() {
            return OperationType.PUBLISH_DML;
        }

        protected override DmlResultAdapter getResultAdapter() {
            return new SaveResultAdapter();
        }

        protected override List<Object> executeDml(List<SObject> recordsToProcess) {
            return EventBus.publish(recordsToProcess);
        }

        protected override DmlRecordResult executeMockedDml(SObject record) {
            return new DmlRecordResult().isSuccess(true).recordId(randomIdGenerator.get(record.getSObjectType())).record(record);
        }
    }

    // Sharing Executors

    private interface DmlSharing {
        OperationResult execute(DmlOperation operation, List<EnhancedRecord> records);
    }

    private inherited sharing class InheritedSharing implements DmlSharing {
        public OperationResult execute(DmlOperation operation, List<EnhancedRecord> records) {
            return operation.execute(records);
        }
    }

    private without sharing class WithoutSharing implements DmlSharing {
        public OperationResult execute(DmlOperation operation, List<EnhancedRecord> records) {
            return operation.execute(records);
        }
    }

    private with sharing class WithSharing implements DmlSharing {
        public OperationResult execute(DmlOperation operation, List<EnhancedRecord> records) {
            return operation.execute(records);
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

        protected abstract DmlRecordResult transform(Object result);
    }

    private class SaveResultAdapter extends DmlResultAdapter {
        public override DmlRecordResult transform(Object result) {
            Database.SaveResult saveResult = (Database.SaveResult) result;

            return new DmlRecordResult().isSuccess(saveResult.isSuccess()).recordId(saveResult.getId()).errors(saveResult.getErrors());
        }
    }

    private class UpsertResultAdapter extends DmlResultAdapter {
        public override DmlRecordResult transform(Object result) {
            Database.UpsertResult upsertResult = (Database.UpsertResult) result;

            return new DmlRecordResult().isSuccess(upsertResult.isSuccess()).recordId(upsertResult.getId()).errors(upsertResult.getErrors());
        }
    }

    private class MergeResultAdapter extends DmlResultAdapter {
        public override DmlRecordResult transform(Object result) {
            Database.MergeResult mergeResult = (Database.MergeResult) result;

            return new DmlRecordResult().isSuccess(mergeResult.isSuccess()).recordId(mergeResult.getId()).errors(mergeResult.getErrors());
        }
    }

    private class DeleteResultAdapter extends DmlResultAdapter {
        public override DmlRecordResult transform(Object result) {
            Database.DeleteResult deleteResult = (Database.DeleteResult) result;

            return new DmlRecordResult().isSuccess(deleteResult.isSuccess()).recordId(deleteResult.getId()).errors(deleteResult.getErrors());
        }
    }

    private class UndeleteResultAdapter extends DmlResultAdapter {
        public override DmlRecordResult transform(Object result) {
            Database.UndeleteResult undeleteResult = (Database.UndeleteResult) result;

            return new DmlRecordResult().isSuccess(undeleteResult.isSuccess()).recordId(undeleteResult.getId()).errors(undeleteResult.getErrors());
        }
    }

    private interface DuplicateCombineStrategy {
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
            Map<String, SObjectField> fieldByName = existingRecord.getSObjectType().getDescribe().fields.getMap();

            for (String field : newRecord.getPopulatedFieldsAsMap().keySet()) {
                if (!fieldByName.containsKey(field.toLowerCase())) {
                    continue;
                }

                existingRecord.put(field, newRecord.get(field));
            }

            for (ParentRelationship parentRelationship : duplicateRecord.parentRelationships) {
                mergeToRecord.withRelationship(parentRelationship);
            }

            for (ExternalRelationship externalRelationship : duplicateRecord.externalRelationships) {
                mergeToRecord.withRelationship(externalRelationship);
            }
        }
    }

    private abstract class DmlOperationResult implements OperationResult {
        private OperationType type;
        private SObjectType objectType;
        private List<RecordResult> recordResults = new List<RecordResult>();
        private List<SObject> records = new List<SObject>();
        private Exception dmlException;
        private String operationId;

        private Boolean isResultsCached = false;
        private List<SObject> cachedSuccesses = new List<SObject>();
        private List<SObject> cachedFailures = new List<SObject>();
        private List<Error> cachedErrors = new List<Error>();

        private DmlOperationResult(OperationType type, SObjectType objectType) {
            this.type = type;
            this.objectType = objectType;
        }

        public SObjectType objectType() {
            return this.objectType;
        }

        public String operationId() {
            return this.operationId;
        }

        public OperationType operationType() {
            return this.type;
        }

        public Boolean hasFailures() {
            return !this.failures().isEmpty();
        }

        public Exception exception() {
            return this.dmlException;
        }

        public List<Error> errors() {
            this.cacheResults();
            return this.cachedErrors;
        }

        public List<SObject> records() {
            return this.records;
        }

        public List<SObject> successes() {
            this.cacheResults();
            return this.cachedSuccesses;
        }

        public List<SObject> failures() {
            this.cacheResults();
            return this.cachedFailures;
        }

        public List<RecordResult> recordResults() {
            return this.recordResults;
        }

        private void cacheResults() {
            if (this.isResultsCached) {
                return;
            }

            for (RecordResult recordResult : this.recordResults) {
                if (recordResult.isSuccess()) {
                    this.cachedSuccesses.add(recordResult.record());
                    continue;
                }

                this.cachedErrors.addAll(recordResult.errors());
                this.cachedFailures.add(recordResult.record());
            }

            this.isResultsCached = true;
        }
    }

    private class ExecutionResult extends DmlOperationResult {
        private ExecutionResult(OperationType type, SObjectType objectType, String operationId) {
            super(type, objectType);
            this.operationId = operationId;
        }

        private ExecutionResult setRecords(List<SObject> records) {
            this.records = records;
            return this;
        }

        private ExecutionResult setRecordResults(List<RecordResult> recordResults) {
            this.recordResults = recordResults;
            return this;
        }

        private ExecutionResult setException(Exception dmlException) {
            this.dmlException = dmlException;
            return this;
        }
    }

    private class SObjectAggregatedResult extends DmlOperationResult {
        private SObjectAggregatedResult(OperationType type, SObjectType objectType) {
            super(type, objectType);
        }

        private SObjectAggregatedResult add(OperationResult recordResult) {
            this.recordResults.addAll(recordResult.recordResults());
            this.records.addAll(recordResult.records());
            this.operationId = this.operationId ?? recordResult.operationId();
            return this;
        }
    }

    private class DmlRecordResult implements RecordResult {
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

        private DmlRecordResult recordId(Id recordId) {
            this.recordId = recordId;
            return this;
        }

        private DmlRecordResult record(SObject record) {
            this.record = record;
            return this;
        }

        @SuppressWarnings('PMD.AvoidBooleanMethodParameters')
        private DmlRecordResult isSuccess(Boolean isSuccess) {
            this.isSuccess = isSuccess;
            return this;
        }

        private DmlRecordResult error(Error error) {
            this.errors.add(error);
            return this;
        }

        private DmlRecordResult errors(List<Database.Error> errors) {
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

        private RecordProcessingError() {
            // Default constructor for builder pattern
        }

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
        private Set<OperationType> mockedOperationTypes = new Set<OperationType>();
        private Set<OperationType> exceptionOperationTypes = new Set<OperationType>();

        private Map<OperationType, Set<SObjectType>> mockedObjectTypesByOperationType = new Map<OperationType, Set<SObjectType>>();
        private Map<OperationType, Set<SObjectType>> exceptionObjectTypesByOperationType = new Map<OperationType, Set<SObjectType>>();

        public Mockable allDmls() {
            this.mockedOperationTypes.addAll(OperationType.values());
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

        private Mockable thenMockDml(OperationType dmlType) {
            this.mockedOperationTypes.add(dmlType);
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
            if (!this.mockedObjectTypesByOperationType.containsKey(dmlType)) {
                this.mockedObjectTypesByOperationType.put(dmlType, new Set<SObjectType>());
            }
            this.mockedObjectTypesByOperationType.get(dmlType).add(objectType);
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
            this.exceptionOperationTypes.add(dmlType);
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
            if (!this.exceptionObjectTypesByOperationType.containsKey(dmlType)) {
                this.exceptionObjectTypesByOperationType.put(dmlType, new Set<SObjectType>());
            }
            this.exceptionObjectTypesByOperationType.get(dmlType).add(objectType);
            return this;
        }

        private Boolean shouldBeMocked(OperationType dmlType, SObjectType objectType) {
            return this.mockedOperationTypes.contains(dmlType) ||
                (this.mockedObjectTypesByOperationType.get(dmlType) ?? new Set<SObjectType>()).contains(objectType) ||
                this.shouldThrowException(dmlType, objectType);
        }

        private List<RecordResult> getMockedRecordResults(DmlOperation operation, List<SObject> recordsToProcess) {
            if (this.shouldThrowException(operation.getOperationType(), operation.getObjectType())) {
                if (operation.globalConfiguration.allOrNone) {
                    throw new DmlException('Exception thrown for ' + operation.getOperationType() + ' operation.');
                }

                // all or none is false, so we need to return a list of record results with errors
                return this.getMockedRecordErrors(operation, recordsToProcess);
            }

            return this.getMockedRecordSuccesses(operation, recordsToProcess);
        }

        private List<RecordResult> getMockedRecordErrors(DmlOperation operation, List<SObject> recordsToProcess) {
            List<RecordResult> recordResults = new List<RecordResult>();
            String errorMessage = 'Exception thrown for ' + operation.getOperationType() + ' operation.';

            for (SObject record : recordsToProcess) {
                DmlRecordResult recordResult = new DmlRecordResult()
                    .isSuccess(false)
                    .error(new RecordProcessingError().setMessage(errorMessage).setStatusCode(System.StatusCode.ALREADY_IN_PROCESS).setFields(new List<String>{ 'Id' }))
                    .record(record);

                recordResults.add(recordResult);
            }

            return recordResults;
        }

        private List<RecordResult> getMockedRecordSuccesses(DmlOperation operation, List<SObject> recordsToProcess) {
            List<RecordResult> recordResults = new List<RecordResult>();

            for (SObject record : recordsToProcess) {
                recordResults.add(operation.executeMockedDml(record));
            }

            return recordResults;
        }

        private Boolean shouldThrowException(OperationType dmlType, SObjectType objectType) {
            return this.exceptionOperationTypes.contains(dmlType) || (this.exceptionObjectTypesByOperationType.get(dmlType) ?? new Set<SObjectType>()).contains(objectType);
        }
    }

    private class DmlRecords implements Records {
        private List<Record> records = new List<Record>();
        private SObjectType objectType;

        private Map<SObjectField, Object> valueByField = new Map<SObjectField, Object>();
        private List<ParentRelationship> parentRelationships = new List<ParentRelationship>();
        private List<ExternalRelationship> externalRelationships = new List<ExternalRelationship>();

        private DmlRecords(List<SObject> records) {
            if (records == null) {
                throw new DmlException('Invalid argument: records. Records cannot be null.');
            }

            this.objectType = this.resolveObjectType(records);

            for (SObject record : records) {
                this.records.add(new DmlRecord(record));
            }
        }

        private SObjectType resolveObjectType(List<SObject> records) {
            if (records == null) {
                return null;
            }

            SObjectType resolvedType = null;

            for (SObject record : records) {
                if (record == null) {
                    continue;
                }

                SObjectType currentType = record.getSObjectType();
                if (resolvedType == null) {
                    resolvedType = currentType;
                    continue;
                }

                if (resolvedType != currentType) {
                    throw new DmlException('Mixed SObject types in a single List<SObject> operation are not supported.');
                }
            }

            return resolvedType;
        }

        private DmlRecords(Iterable<Id> recordIds) {
            this.setObjectTypeBasedOnIds(recordIds);

            for (Id recordId : recordIds) {
                this.records.add(new DmlRecord(recordId));
            }
        }

        private void setObjectTypeBasedOnIds(Iterable<Id> recordIds) {
            Iterator<Id> it = recordIds.iterator();
            if (it.hasNext()) {
                this.objectType = it.next().getSObjectType();
            }
        }

        public DmlRecords with(SObjectField field, Object value) {
            this.valueByField.put(field, value);
            return this;
        }

        public DmlRecords withRelationship(SObjectField relationshipField, SObject relatedToRecord) {
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
            for (SObjectField field : this.valueByField.keySet()) {
                enhancedRecord.with(field, this.valueByField.get(field));
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
            if (recordId == null) {
                throw new DmlException('Invalid argument: recordId. Record ID cannot be null.');
            }

            this.enhancedRecord = new EnhancedRecord(recordId);
        }

        public DmlRecord with(SObjectField field, Object value) {
            this.enhancedRecord.with(field, value);
            return this;
        }

        public DmlRecord withRelationship(SObjectField relationshipField, SObject relatedToRecord) {
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

    @NamespaceAccessible
    public class EnhancedRecord {
        private SObject currentRecord;
        private DmlOperation operation;
        private Boolean hasTemporaryId = false;

        private List<ParentRelationship> parentRelationships = new List<ParentRelationship>();
        private List<ExternalRelationship> externalRelationships = new List<ExternalRelationship>();

        private EnhancedRecord(SObject currentRecord) {
            this.currentRecord = currentRecord;
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

        private void setOperation(DmlOperation operation) {
            this.operation = operation;
        }

        private void addToDependencyGraph(OrderDependencyGraph orderDependencyGraph) {
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
            if (this.hasId()) {
                return;
            }

            this.hasTemporaryId = true;
            this.currentRecord.Id = randomIdGenerator.get(this.getSObjectType());
        }

        private void clearTemporaryId() {
            if (!this.hasTemporaryId) {
                return;
            }

            this.hasTemporaryId = false;
            this.currentRecord.Id = null;
        }

        private SObjectType getSObjectType() {
            return this.currentRecord?.getSObjectType();
        }

        private SObject getRecord() {
            return this.currentRecord;
        }

        private Boolean hasId() {
            return String.isNotBlank(this.getRecordId());
        }

        private Id getRecordId() {
            return this.currentRecord?.Id;
        }
    }

    private class ParentRelationship {
        private SObjectField relationshipField;
        private EnhancedRecord relatedToEnhancedRecord;

        private ParentRelationship(SObjectField relationshipField, EnhancedRecord relatedToRecord) {
            this.validateRelationshipField(relationshipField);

            this.relationshipField = relationshipField;
            this.relatedToEnhancedRecord = relatedToRecord;
        }

        private EnhancedRecord getRelatedToEnhancedRecord() {
            return this.relatedToEnhancedRecord;
        }

        private void resolve(SObject currentRecord) {
            if (this.relatedToEnhancedRecord.getRecordId() == null) {
                return;
            }

            currentRecord.put(this.relationshipField, this.relatedToEnhancedRecord.getRecordId());
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
            if (prerequisite.getRecordId() == dependent.getRecordId()) {
                throw new DmlException('Self-dependency detected for record: ' + prerequisite.getRecordId());
            }

            if (prerequisite.getRecordId() == null) {
                throw new DmlException('Related record has no Id and is not registered in the unit of work.');
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
        private Map<SObjectType, String> prefixBySObjectType = new Map<SObjectType, String>();

        public Id get(SObjectType objectType) {
            return this.get(this.getPrefix(objectType));
        }

        private Id get(String prefix) {
            this.counter++;
            return Id.valueOf(prefix + '0'.repeat(15 - prefix.length() - String.valueOf(this.counter).length()) + String.valueOf(this.counter));
        }

        private String getPrefix(SObjectType objectType) {
            String prefix = this.prefixBySObjectType.get(objectType);

            if (prefix == null) {
                prefix = objectType.getDescribe().getKeyPrefix();
                this.prefixBySObjectType.put(objectType, prefix);
            }

            return prefix;
        }
    }
}
