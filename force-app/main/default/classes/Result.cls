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
    OperationResult insertsOf(SObjectType objectType);
    OperationResult updatesOf(SObjectType objectType);
    OperationResult upsertsOf(SObjectType objectType);
    OperationResult deletesOf(SObjectType objectType);
    OperationResult undeletesOf(SObjectType objectType);
    OperationResult mergesOf(SObjectType objectType);
    OperationResult eventsOf(SObjectType objectType);
}
