trigger UnitRate on Energy_Bill__c (before insert, before update) {
    if(Trigger.isbefore && Trigger.isInsert || Trigger.isUpdate){
        List<Energy_Bill__c > ebList = new List<Energy_Bill__c>();
        for(Energy_Bill__c eb : trigger.new){
            eb.Unit_Rate__c = Decimal.valueof(System.label.Unit_Rate);
            //ebList.add(eb);
        }
        //update ebList;
    }
}