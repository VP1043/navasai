public class lookupRentalNameClass {
    // Method to fetch lookup search result   
     @AuraEnabled(cacheable=true)
     public static list<sObject> fetchLookupData(string searchKey , string sObjectApiName, String filledFlag) {    
         System.debug('filledFlag'+filledFlag);
        List < sObject > returnList = new List < sObject > ();
         string sQuery;
         string sWildCardText = '%' + searchKey + '%';
         if(filledFlag == 'Yes'){
            sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Name Like : sWildCardText AND IsFilled__c=true order by createdDate DESC LIMIT 10';
         }
         else if(filledFlag == 'No'){
            sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Name Like : sWildCardText AND IsFilled__c=false order by createdDate DESC LIMIT 5';
         }else{
            sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Name Like : sWildCardText order by createdDate DESC LIMIT 5';
         }
         for (sObject obj: database.query(sQuery)) {
             returnList.add(obj);
         }
         return returnList;
     }
     
     // Method to fetch lookup default value 
     @AuraEnabled
     public static sObject fetchDefaultRecord(string recordId , string sObjectApiName) {
         string sRecId = recordId;    
         string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Id = : sRecId LIMIT 1';
         for (sObject obj: database.query(sQuery)) {
             return obj;
         }
         return null;
     }

     @AuraEnabled(cacheable=true)
     public static list<sObject> fetchLookupDataVacantUnit(string searchKey , string sObjectApiName) {    
         List < sObject > returnList = new List < sObject > ();
 
         string sWildCardText = '%' + searchKey + '%';
         Boolean available = false;
         string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Name Like : sWildCardText AND IsFilled__c =: available  order by createdDate DESC LIMIT 5';
         for (sObject obj: database.query(sQuery)) {
             returnList.add(obj);
         }
         return returnList;
     }
     
 }