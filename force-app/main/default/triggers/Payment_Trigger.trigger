trigger Payment_Trigger on Payment__c (after insert, after update, before delete) {
    if(Trigger.isAfter && Trigger.isInsert || Trigger.isUpdate){
        Rollup_Methods.rollupPaymentsToRentalAgreement(Trigger.newMap);
    }
    if(Trigger.isBefore && Trigger.isDelete){
        Rollup_Methods.rollupPaymentsToRentalAgreement(Trigger.oldMap);
    }

}