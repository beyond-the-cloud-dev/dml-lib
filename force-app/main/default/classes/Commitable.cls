global interface Commitable {
    // Insert
    Commitable toInsert(SObject record);
    Commitable toInsert(Record record);
    Commitable toInsert(List<SObject> records);
    Commitable toInsert(Records records);
    // Update
    Commitable toUpdate(SObject record);
    Commitable toUpdate(Record record);
    Commitable toUpdate(List<SObject> records);
    Commitable toUpdate(Records records);
    // Upsert
    Commitable toUpsert(SObject record);
    Commitable toUpsert(SObject record, SObjectField externalIdField);
    Commitable toUpsert(Record record);
    Commitable toUpsert(List<SObject> records);
    Commitable toUpsert(List<SObject> records, SObjectField externalIdField);
    Commitable toUpsert(Records records);
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
    OperationResult insertImmediately(Record record);
    OperationResult insertImmediately(List<SObject> records);
    OperationResult insertImmediately(Records records);
    // Immediate Update
    OperationResult updateImmediately(SObject record);
    OperationResult updateImmediately(Record record);
    OperationResult updateImmediately(List<SObject> records);
    OperationResult updateImmediately(Records records);
    // Immediate Upsert
    OperationResult upsertImmediately(SObject record);
    OperationResult upsertImmediately(Record record);
    OperationResult upsertImmediately(List<SObject> records);
    OperationResult upsertImmediately(Records records);
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
    Commitable commitHook(Hook callback);
    Commitable combineOnDuplicate();
    // Save
    Result dryRun();
    Result commitWork();
    Result commitTransaction(); // make a savepoint and rollback on exception
}