global interface Record {
    Record with(SObjectField field, Object value);
    Record withRelationship(SObjectField targetField, SObject relatedRecord);
    Record withRelationship(SObjectField targetField, SObjectField relatedObjectExternalIdField, Object relatedRecordExternalId);

    // for internal use only
    DML.EnhancedRecord get();
    SObjectType getSObjectType();
}