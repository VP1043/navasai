/**
* @File Name : DatatableController.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : August 30, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | August 30, 2024 |   | Initial Version
**/

public class DatatableController {
	public class DataWrapper {
		@AuraEnabled
		public String name { get; set; }
		@AuraEnabled
		public Decimal rentalAmount { get; set; }
		@AuraEnabled
		public Decimal energyBill { get; set; }
		@AuraEnabled
		public Decimal waterBill { get; set; }
		@AuraEnabled
		public Decimal total { get; set; }
		@AuraEnabled
		public Decimal energyBillPrvRead { get; set; }
		@AuraEnabled
		public Decimal energyBillCurrRead { get; set; }
		@AuraEnabled
		public Decimal energyBillUnitRate { get; set; }
		@AuraEnabled
		public String statementId { get; set; }
		@AuraEnabled
		public String energyBillId { get; set; }
	}

	//public with sharing class DataController {
    @AuraEnabled(cacheable=true)
    public static List<DataWrapper> getData(String month, String year) {
        List<DataWrapper> results = new List<DataWrapper>();

        // Query rental units, water bills, energy bills, and total
        List<Statement__c> statements = [SELECT Id,Rental_Agreement__r.Rental_Unit__r.Name,Amount__c,Month__c,Year__c,Light_Bill__c,Water_Bill__c,Total_Amount__c,Rental_Agreement__r.Renter__r.Name  FROM Statement__c WHERE Month__c = :month AND Year__c = :year];
        List<Energy_Bill__c> energyBills = [select Id,Current_Reading__c,Previous_Reading__c,Rental_Unit__c,Statement__c,Unit_Rate__c,Year__c,Month__c,Energy_Bill_Amount__c from Energy_Bill__c  WHERE Statement__c IN:statements];
		System.debug('energyBills'+energyBills);

        Map<String, DataWrapper> nameToData = new Map<String, DataWrapper>();
        Map<String, Energy_Bill__c> statementToLight = new Map<String, Energy_Bill__c>();

		for (Energy_Bill__c energyBill : energyBills) {
            if (energyBill.Statement__c != null) {
				// DataWrapper data = new DataWrapper();
                // data.energyBillPrvRead = energyBill.Previous_Reading__c;
                // data.energyBillCurrRead = energyBill.Current_Reading__c;
                // data.energyBillUnitRate = energyBill.Unit_Rate__c;
			    statementToLight.put(energyBill.Statement__c, energyBill);
            }
        }
		System.debug('statementToLight'+statementToLight);


        for (Statement__c statement : statements) {
            DataWrapper data = new DataWrapper();
			data.name = statement.Rental_Agreement__r.Renter__r.Name+' ('+statement.Rental_Agreement__r.Rental_Unit__r.Name+' )';
			data.total = statement.Total_Amount__c;
			data.waterBill = statement.Water_Bill__c;
			data.energyBill = statement.Light_Bill__c;
			data.rentalAmount = statement.Amount__c;
			data.statementId = statement.Id;
			if(statementToLight.containsKey(statement.Id)){
				data.energyBillPrvRead = statementToLight.get(statement.Id).Previous_Reading__c;
				data.energyBillCurrRead = statementToLight.get(statement.Id).Current_Reading__c;
				data.energyBillUnitRate = statementToLight.get(statement.Id).Unit_Rate__c;
				data.energyBillId = statementToLight.get(statement.Id).Id;
			}else{
				data.energyBillPrvRead = 0;
				data.energyBillCurrRead = 0;
				data.energyBillUnitRate = 0;
			}
            nameToData.put(statement.Id, data);
        }

        

        results.addAll(nameToData.values());
		System.debug('results'+results);

        return results;
    }

	 @AuraEnabled
    public static void saveData(List<DataWrapper> data) {
        List<Statement__c> statementsToUpdate = new List<Statement__c>();
        List<Energy_Bill__c> energyBillsToUpdate = new List<Energy_Bill__c>();

        for (DataWrapper dw : data) {
            Statement__c statement = new Statement__c(Id = dw.statementId,  
                                                      Water_Bill__c = dw.waterBill);
            statementsToUpdate.add(statement);

            if (dw.energyBillPrvRead != null || dw.energyBillCurrRead != null) {
                Energy_Bill__c energyBill = new Energy_Bill__c(Id = dw.energyBillId, 
                                                               Previous_Reading__c = dw.energyBillPrvRead, 
                                                               Current_Reading__c = dw.energyBillCurrRead, 
                                                               Unit_Rate__c = dw.energyBillUnitRate);
                energyBillsToUpdate.add(energyBill);
            }
        }
				System.debug('energyBillsToUpdate'+energyBillsToUpdate);
				System.debug('statementsToUpdate'+statementsToUpdate);



        try {
            if (!statementsToUpdate.isEmpty()) {
                update statementsToUpdate;
            }
            if (!energyBillsToUpdate.isEmpty()) {
                update energyBillsToUpdate;
            }
        } catch (Exception e) {
            // Handle exceptions
            throw new AuraHandledException('Error saving data: ' + e.getMessage());
        }
    }

	@AuraEnabled
    public static void saveEnergyBillAmountToCustomSetting(Decimal energyBillAmount) {
        // Assuming EnergyBillSetting__c is your custom setting
        EnergyBillSetting__c setting = EnergyBillSetting__c.getOrgDefaults();
        setting.EnergyBillAmount__c = energyBillAmount;
        upsert setting;
    }
//}



	//SELECT Id,Rental_Agreement__r.Rental_Unit__r.Name,Amount__c,Month__c,Year__c,Light_Bill__c,Water_Bill__c,Total_Amount__c FROM Statement__c WHERE Month__c ='January' AND Year__c ='2023'
}