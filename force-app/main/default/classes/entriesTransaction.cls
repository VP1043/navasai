public with sharing class entriesTransaction {
    @InvocableMethod(label='myFirtInvocable' description='xxxxx')
    public static List<Integer> sendToWebService(List<String> recIds){
        List<String> st = new List<String>();
        String previousReading;
        List<Integer> previousReadingList = new List<Integer>();
            for(String recId : recIds){ 
                System.debug(recId);
                st.add(recId);
            }
            
            List<Energy_Bill__c> energyList = [SELECT Id, Name, Current_Reading__c, Previous_Reading__c, 
                                        Unit_Rate__c, Energy_Bill_Amount__c, Month__c, Statement__c,
                                        Rental_Unit__c, CreatedDate FROM Energy_Bill__c 
                                        WHERE Rental_Unit__c IN: st
                                        //AND Statement__c != null
                                        AND Current_Reading__c != Null
                                        ORDER BY Current_Reading__c DESC];

            if(energyList.size()>0){
                previousReading = String.valueof(energyList[0].Current_Reading__c) != null ? String.valueof(energyList[0].Current_Reading__c):null;
                previousReadingList.add(Integer.valueof(previousReading));
            }
        if(previousReadingList.size()>0){
            return previousReadingList;
        }else{
            return null;
        }
            
    }
}