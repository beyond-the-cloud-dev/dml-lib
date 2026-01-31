// DML Work

DML db = new DML();

Opportunity newOpportunity = new Opportunity(
    Name = 'UoW Test Name ',
    StageName = 'Open',
    CloseDate = System.today()
);

db.toInsert(newOpportunity);

for(Integer j = 0 ; j < 10 ; j++) {
    Product2 newProduct = new Product2(
        Name = newOpportunity.Name + ' : Product : ' + j
    );

    db.toInsert(newProduct);

    PricebookEntry newPricebookEntry = new PricebookEntry(
        UnitPrice = 10,
        IsActive = true,
        UseStandardPrice = false
    );  

    db.toInsert(
        DML.Record(newPricebookEntry).withRelationship(PricebookEntry.Product2Id, newProduct)
    );

    OpportunityLineItem newOpportunityLineItem = new OpportunityLineItem(
        Quantity = 1,
        TotalPrice = 10
    );

    db.toInsert(
        DML.Record(newOpportunityLineItem)
            .withRelationship(OpportunityLineItem.OpportunityId, newOpportunity)
            .withRelationship(OpportunityLineItem.PricebookEntryId, newPricebookEntry)
    );
}

db.commitWork();


DML uow = new DML();

Opportunity newOpportunity = new Opportunity(
    Name = 'UoW Test Name ',
    StageName = 'Open',
    CloseDate = System.today()
);

uow.toInsert(DML.Record(newOpportunity));

// DML.Record record = DML.Record(newOpportunity);

// System.debug(record.get());

uow.preview();


