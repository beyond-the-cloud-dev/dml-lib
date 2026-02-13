global interface OperationResult {
    // Metadata
    DML.OperationType operationType();
    SObjectType objectType();
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