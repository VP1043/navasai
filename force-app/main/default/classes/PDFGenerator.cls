public class PDFGenerator {
    public List<Statement__c> statementList { get; set; }
    public String month { get; set; }
    public String year { get; set; }

    public PDFGenerator() {
        statementList = new List<Statement__c>();
        getStatements();
    }

    public void getStatements() {
        month = ApexPages.currentPage().getParameters().get('month');
        year = ApexPages.currentPage().getParameters().get('year');

        statementList = [SELECT Id, Name, Additional_Fees__c, Total_Amount__c, Rental_Agreement__c, Statement_Date__c, Amount_Paid__c,
                        Due_Date__c, Status__c, Light_Bill__c, Water_Bill__c, Amount__c, Rental_Agreement__r.Balance__c,Rental_Agreement__r.Rental_Unit__r.Name, Month__c, Year__c, Balance__c,
                        Rental_Agreement__r.Renter__r.Name
                        FROM Statement__c
                        WHERE Month__c =: month AND Year__c =: year];
    }
}