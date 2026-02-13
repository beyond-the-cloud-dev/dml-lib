global interface RecordResult {
    Id id();
    SObject record();
    Boolean isSuccess();
    List<Error> errors();
}