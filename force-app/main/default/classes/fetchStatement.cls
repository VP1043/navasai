public with sharing class fetchStatement {
    @AuraEnabled
    public static Statement__c getStatement(String ruId, String month, String year){
        try {
            List<Statement__c> stamList = [SELECT Id, Name, Additional_Fees__c, Total_Amount__c, Rental_Agreement__c, Rental_Agreement__r.Rental_Unit__r.Name,
                                            Statement_Date__c, Due_Date__c, Status__c, Light_Bill__c, Water_Bill__c, Amount__c, 
                                            Month__c, Year__c, Rental_Agreement__r.Balance__c, Rental_Agreement__r.Renter__r.Name
                                            FROM Statement__c
                                            WHERE Rental_Agreement__r.Rental_Unit__c=:ruId
                                            AND Month__c =: month
                                            AND Year__c=:year];

            return stamList[0];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Statement__c> getStatementByDate(String month, String year){
        try {
            List<Statement__c> stamList = [SELECT Id, Name, Additional_Fees__c, Total_Amount__c, Rental_Agreement__c, Rental_Agreement__r.Rental_Unit__r.Name,
                                            Statement_Date__c, Due_Date__c, Status__c, Light_Bill__c, Water_Bill__c, Amount__c, Balance__c,Amount_Paid__c,
                                            Month__c, Year__c, Rental_Agreement__r.Balance__c, Rental_Agreement__r.Active__c, Rental_Agreement__r.Renter__r.Name 
                                            FROM Statement__c
                                            WHERE Rental_Agreement__r.Active__c = true
                                            AND Month__c =: month
                                            AND Year__c=:year];
            System.debug('stamList'+stamList);
            return stamList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}