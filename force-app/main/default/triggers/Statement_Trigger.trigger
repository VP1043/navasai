trigger Statement_Trigger on Statement__c (After Insert, After Update, Before Delete, Before Insert, Before Update) {

    if(Trigger.isAfter && Trigger.isInsert || Trigger.isUpdate){
        Rollup_Methods.rollupStatementsToRentalAgreement(trigger.new);
    }
    
    if(Trigger.isBefore && Trigger.isDelete){
        Rollup_Methods.rollupStatementsToRentalAgreement(trigger.old);
    }

    if(Trigger.isBefore && Trigger.isInsert || Trigger.isUpdate){
        //Rollup_Methods.updateBalance(trigger.new);
    }
}