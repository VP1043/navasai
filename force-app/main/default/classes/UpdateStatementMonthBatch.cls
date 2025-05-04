public class UpdateStatementMonthBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext context) {
        String query = 'SELECT Id, Month__c FROM Statement__c';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext context, List<sObject> scope) {
        List<Statement__c> recordsToUpdate = new List<Statement__c>();

        for (sObject record : scope) {
            Statement__c objRecord = (Statement__c)record;
            if(objRecord.Month__c=='Jun'){
                objRecord.StatementMonth__c='June';
            }else{
                objRecord.StatementMonth__c = objRecord.Month__c;

            }
            recordsToUpdate.add(objRecord);
        }

        update recordsToUpdate;
    }

    public void finish(Database.BatchableContext context) {
        // Execute any post-processing logic here
    }
}