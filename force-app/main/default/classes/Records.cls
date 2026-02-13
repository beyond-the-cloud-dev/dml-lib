global interface Records {
    Records with(SObjectField field, Object value);
    Records withRelationship(SObjectField targetField, SObject relatedRecord);
    Records withRelationship(SObjectField targetField, SObjectField relatedObjectExternalIdField, Object relatedRecordExternalId);

    // for internal use only
    List<Record> get();
    SObjectType getSObjectType();
}
