public with sharing class ElectricityBillCalculator {
    @AuraEnabled(cacheable=true)
    public static String getPreviousReading(String ruId){
        try {
            List<Rental_Unit__c> unitList = [SELECT Id, Name, Unit__c FROM Rental_Unit__c WHERE Id =: ruId];
            String previousReading;

            
                List<Energy_Bill__c> energyList = [SELECT Id, Name, Current_Reading__c, Previous_Reading__c, 
                                        Unit_Rate__c, Energy_Bill_Amount__c, Month__c, Statement__c,
                                        Rental_Unit__c, CreatedDate FROM Energy_Bill__c 
                                        WHERE Rental_Unit__c IN: unitList
                                        //AND Statement__c != null
                                        AND Current_Reading__c != Null
                                        ORDER BY Current_Reading__c DESC];
            if(energyList.size()>0){
                previousReading = String.valueof(energyList[0].Current_Reading__c) != null ? String.valueof(energyList[0].Current_Reading__c):'';
            }
            return previousReading;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String saveRentalEntries(String ruId, Integer prevReading, Integer curReading, String month, String year, Integer waterbill) {
        String renMsg;
        try{
            System.debug('ruId'+ruId);
            System.debug('prevReading'+prevReading);
            System.debug('curReading'+curReading);
            System.debug('month'+month);
            System.debug('year'+year);
            String rentalUnitId = ruId != null ? ruId : ''; 
            String raId;
            Decimal due;
            String sampName = month+'-'+year;
            List<Rental_Unit__c> unitList = [SELECT Id, Name, Unit__c FROM Rental_Unit__c WHERE Id =: ruId];
            if(unitList.size()>0){
                sampName = unitList[0].Name+'-'+month+'-'+year;
            }
            
            List<Energy_Bill__c> energyList = [SELECT Id, Name, Current_Reading__c, Previous_Reading__c, 
                                    Unit_Rate__c, Energy_Bill_Amount__c, Month__c, Statement__c,
                                    Rental_Unit__c, CreatedDate FROM Energy_Bill__c 
                                    WHERE Rental_Unit__c IN: unitList
                                    AND Current_Reading__c != Null
                                    AND Month__c =: month
                                    AND Year__c =: year
                                    ORDER BY CreatedDate DESC];

            List<Energy_Bill__c> newebList = new List<Energy_Bill__c>();
            if(ruId != '' && prevReading != null && curReading != null && month != null && year != null){
                
                    if(energyList.size()>0){
                        System.debug('Duplicate');
                    }else{
                        Energy_Bill__c newEb = new Energy_Bill__c();
                        newEb.Name = sampName;
                        newEb.Current_Reading__c= curReading;
                        newEb.Previous_Reading__c=prevReading;
                        newEb.Month__c=month;
                        newEb.Year__c=year;
                        newEb.Rental_Unit__c=ruId;
                        newebList.add(newEb);
                    }
                                   
            }
 
            System.debug('newebList'+newebList);
            if(newebList.size()>0){
                insert newebList;
            }

            if(ruId != ''){
                List<Rental_Agreement__c> rentalAgreList = [SELECT Id, Name, Rental_Unit__c,CreatedDate,Renter__r.Name,Balance__c FROM Rental_Agreement__c 
                                                            WHERE Rental_Unit__c =: ruId
                                                            AND Active__c=true
                                                            ORDER BY CreatedDate DESC];
                raId = rentalAgreList[0].Id;
                due = rentalAgreList[0].Balance__c !=null ? rentalAgreList[0].Balance__c : 0;
                sampName = rentalAgreList[0].Renter__r.Name+' '+month+'-'+year;
            }

            List<Statement__c> StatmentList = [SELECT Id, Name, Additional_Fees__c, Total_Amount__c, Rental_Agreement__c, Statement_Date__c, 
                                                 Due_Date__c, Status__c, Light_Bill__c, Water_Bill__c, Amount__c 
                                                 FROM Statement__c WHERE Name =: sampName];
                                                 
            List<Energy_Bill__c> enList = [SELECT Id, Name, Current_Reading__c, Previous_Reading__c, 
                                                Unit_Rate__c, Energy_Bill_Amount__c, Month__c, Statement__c,
                                                Rental_Unit__c, CreatedDate FROM Energy_Bill__c 
                                                WHERE Rental_Unit__c IN: unitList
                                                AND Month__c =: month
                                                AND Year__c =: year
                                                ORDER BY CreatedDate DESC];
            System.debug('sampName'+sampName);
            List<Statement__c> newStatmentList = new List<Statement__c>();
            if(raId != ''){
                Statement__c newStmnt = new Statement__c();
                newStmnt.Name = sampName;
                newStmnt.Rental_Agreement__c = raId;
                if(!enList.isEmpty()){
                    newStmnt.Light_Bill__c = enList[0].Energy_Bill_Amount__c;
                }else{
                    newStmnt.Light_Bill__c = 0;
                }
                newStmnt.Water_Bill__c = waterbill;
                newStmnt.Month__c=month;
                newStmnt.Year__c=year;
                newStmnt.Balance__c=due;
                newStatmentList.add(newStmnt);
            }

            if(newStatmentList.size()>0){
                insert newStatmentList;
               renMsg='Success';
            }

            if(enList.size()>0){
                enList[0].Statement__c=newStatmentList[0].Id;
                update enList;
            }


        } catch (Exception e) {
            //throw new AuraHandledException(e.getMessage());
            System.debug('Exceptions in saveRentalEntries: '+e.getLineNumber()+'-'+e.getMessage());
             renMsg=e.getMessage();
        }
        return renMsg;
    }

    @AuraEnabled
    public static String saveNewAgreement(String ruId, String agreeName, Integer deposit, Integer mRent, String renter){
        String retMsg ='';
        try {
            List<Rental_Agreement__c> raList = [SELECT Id, Name, Rental_Unit__c, Renter__c, Deposit__c, Rental_Amount__c 
                                                FROM Rental_Agreement__c
                                                WHERE Rental_Unit__c =: ruId];
                                                
            List<Rental_Agreement__c> newRaList = new List<Rental_Agreement__c>();
            if(raList.isEmpty()){
                Rental_Agreement__c ra = new Rental_Agreement__c();
                ra.Name = agreeName;
                ra.Deposit__c = deposit;
                ra.Renter__c = renter;
                ra.Rental_Amount__c = mRent;
                ra.Rental_Unit__c = ruId;
                newRaList.add(ra);
            }

            if(newRaList.size()>0){
                insert newRaList; 
            }
            retMsg = 'Success';
            
        } catch (Exception e) {
            //throw new AuraHandledException(e.getMessage());
            System.debug('Exceptions in saveRentalEntries: '+e.getLineNumber()+'-'+e.getMessage());
            retMsg = e.getMessage();
        }
        return retMsg;
    }

    @AuraEnabled
    public static Statement__c getStatement(String ruId){
        Statement__c pmntList;
        if(ruId != null || ruId != ''){
        pmntList = [SELECT Id, Name, Additional_Fees__c, Total_Amount__c, Rental_Agreement__c, Statement_Date__c, 
                                    Due_Date__c, Status__c, Light_Bill__c, Water_Bill__c, Amount__c, Rental_Agreement__r.Balance__c
                                    FROM Statement__c
                                    WHERE Id =: ruId];
        }
        return pmntList;

    }
    @AuraEnabled
    public static String savePayment(String ruId, Integer amount){
        String retMsg;
        List<Statement__c> pmntList;
        List<Payment__c> newPaymentList = new List<Payment__c>();

        
        if(ruId != null || ruId != ''){
        pmntList = [SELECT Id, Name, Additional_Fees__c, Total_Amount__c, Rental_Agreement__c, Statement_Date__c, 
                                    Due_Date__c, Status__c, Light_Bill__c, Water_Bill__c, Amount__c 
                                    FROM Statement__c
                                    WHERE Id =: ruId];
        }
        if(pmntList.size()>0){
            Payment__c newPayment = new Payment__c();
            newPayment.Name=pmntList[0].Name;
            newPayment.Amount__c=amount;
            newPayment.Status__c='Paid';
            newPayment.Statement__c=pmntList[0].Id;
            newPaymentList.add(newPayment);
        }
        if(newPaymentList.size()>0){
            Database.insert(newPaymentList);
            retMsg='Success';
        }
        System.debug(newPaymentList);
        System.debug(amount);
        return retMsg;
    }
}