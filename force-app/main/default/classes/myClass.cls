public class myClass {
// /*Dev
// * Class Name   :  gsfpClsProductAllocation
// * Description  :  Server Side Controller for "gsfplwcProductAllocation" Lightning web component
// * Created by   :  Cognizant -IT Team
// * Created Date :  March, 2024
// * Test Class   :  gsfpClsProductAllocationTest   
// * Note : 
// */
// public without sharing class gsfpClsProductAllocation {    
//     public static Map<Id,Products_Services_Portfolio_To_Product__c> psptpMap = new Map<Id,Products_Services_Portfolio_To_Product__c>();
//     public static Set<Id> seasonIds = new  Set<Id> ();
//     public static  Map<String,String> terrNameWithId;
//     public static Map<String,Territory2> allTerrWithParentMap;    
//     Public static Map<String,Set<String>> allTerrWithChildMap; 
//     Public static Set<Territory2> allLowerLevelTerrs; 
//     Public static Map<String,Set<Territory2>> allTerWithChildTerrMap;     
//     public static Territory2 curTerritoty;
//     public static String currentTerrType;
//     public static Set<Id> terrIds = new Set<Id> ();
//     public static Set<Id> prdIds = new Set<Id> ();
//     public static Set<String> prdGrps = new Set<String>();
//     public static Map<string,boolean> prdAllocPrdGpVsEditMap = new  Map<string,boolean>(); 
//     public static String SELL_IN = 'SellIn';
//     public static String COUNTRY_CODE = '';
// 	public static String SOH_Filter = '';
//     public static Map<String,String> sohTypeMap = new Map<String,String>();
//     public static Map<String,String> sohValMap = new Map<String,String>();
//     public static Set<String> terrTypes = new Set<String>(); 
//     public static Map<String,String> territoryCdMap = new Map<String,String>();
//     public static List<String> SOHConfig = new List<String>();
    
//    private static void constructSOHMap(){
//         sohTypeMap.put('Country','Country');
//         sohTypeMap.put('Account_Manager','Territory');
//         sohTypeMap.put('Zone','Zone');
//         sohTypeMap.put('Region','Region');
//         sohTypeMap.put('Team','Area');
//         sohTypeMap.put('Territory','Territory');
//     }
    
//    private static void constructSOHValMap(){
//         sohValMap.put('Country','Country');
//         sohValMap.put('Territory','Account_Manager');
//         sohValMap.put('Zone','Zone');
//         sohValMap.put('Region','Region');
//         sohValMap.put('Area','Team');
//     }
    
//     /*
//     * Method Name : getSOHDetails
//     * Description : Method to fetch SOH details to be displayed in the SOH Dropdown of Target Setting & Allocation->Product Allocation Tab.
//     * Params      : String terrId (Logged in user territory id selected from the header)
//     */
//     @AuraEnabled(cacheable=true)
//     public static List<String> getSOHDetails(String terrId){   
//         Set<String> updatedTerrType = new Set<String>();
//         fetchCurrentTerritory(terrId);
//         Boolean isFlag = false;
//         constructSOHMap();
//         for(SOH_Config__mdt soh:[SELECT Id, SOH_Editable__c, SOH_Types__c, Country_Code__c FROM SOH_Config__mdt WHERE Country_Code__c=:COUNTRY_CODE]){
//             terrTypes.addAll(soh.SOH_Types__c.split(','));
//         }
//         String terrType = sohTypeMap.containsKey(currentTerrType)?sohTypeMap.get(currentTerrType):'';
//         if(terrType == 'Territory'){
//             updatedTerrType.add(terrType);
//         }else{
//             for(String s:terrTypes){
//                 if(terrType == 'Country'){
//                     updatedTerrType.add(s);
//                 }
//                 if(s == terrType){                    
//                     isFlag = true;
//                     continue;
//                 }else{
//                     if(isFlag){
//                         updatedTerrType.add(s);
//                     }
//                 }
//             }
//         }
        
//         System.debug('updatedTerrType>'+updatedTerrType);
//         return new List<String>(updatedTerrType);
//     }
    
//     /*
//     * Method Name : fetchCurrentTerritory
//     * Description : Method to fetch current logged in territory details
//     * Params      : String TerritoryId (Logged in user territory id selected from the header)
//     */
//     public static Territory2 fetchCurrentTerritory(String TerritoryId){ 
//         curTerritoty = [SELECT Id,Name,Description,ParentTerritory2Id,ParentTerritory2.Name,ParentTerritory2.Description,Territory2TypeId,Territory2Type.DeveloperName,Territory2Model.Name,Territory2Type.MasterLabel,fcountry__c 
//                 FROM Territory2 WHERE Id = :TerritoryId AND Territory2Model.STATE ='Active' ORDER BY NAME];
//         COUNTRY_CODE = curTerritoty.fCountry__c;
//         currentTerrType = curTerritoty.Territory2Type.DeveloperName;
//         return curTerritoty;
//     } 

//      public static Map<String,String> fetchCurrentTerritoryList(List<String> TerritoryIdList){ 
//         Map<String,String> parentChildMap = new Map<String,String>();
      
//         List<Territory2> curTerritoty = [SELECT Id,Name,Description,ParentTerritory2Id,ParentTerritory2.Name,ParentTerritory2.Description,Territory2TypeId,Territory2Type.DeveloperName,
//                                          Territory2Model.Name,Territory2Type.MasterLabel,fcountry__c,ParentTerritory2.ParentTerritory2Id,
//                                          ParentTerritory2.ParentTerritory2.ParentTerritory2Id,
//                                          ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2Id,ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2Id
//                                             FROM Territory2 
//                                             WHERE Id 
//                                             IN:TerritoryIdList 
//                                             AND Territory2Model.STATE ='Active' ORDER BY NAME];
//         for(Territory2 terr : curTerritoty){
//             if(terr.ParentTerritory2Id != null){
//                 parentChildMap.put(terr.Id, terr.ParentTerritory2Id);
//             }
//             if(terr.ParentTerritory2.ParentTerritory2Id != null){
//                 parentChildMap.put(terr.ParentTerritory2Id, terr.ParentTerritory2.ParentTerritory2Id);
//             }
//             if(terr.ParentTerritory2.ParentTerritory2.ParentTerritory2Id != null){
//                 parentChildMap.put(terr.ParentTerritory2.ParentTerritory2Id, terr.ParentTerritory2.ParentTerritory2.ParentTerritory2Id);
//             }
//             if(terr.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2Id != null){
//                 parentChildMap.put(terr.ParentTerritory2.ParentTerritory2.ParentTerritory2Id, terr.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2Id);
//             }
//             if(terr.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2Id != null){
//                 parentChildMap.put(terr.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2Id, terr.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2Id);
//             }
//         }
//          return parentChildMap;
//      }
    
//     /*
//     * Method Name : genParentandChildMapSOH
//     * Description : Method to construct parent/child territory map based on SOH value selected  in Target Setting & Allocation->Product Allocation tab.    
//     */
//     public static void genParentandChildMapSOH(String currentTerrType){
//         terrNameWithId = new Map<String,String>();
//         allTerrWithParentMap = new Map<String,Territory2>();
//         allTerrWithChildMap = new Map<String,Set<String>>();
//         allTerWithChildTerrMap = new Map<String,Set<Territory2>>();
//         System.debug('SOH_Filter in genParentandChildMapSOH>>'+SOH_Filter);
//         List<Territory2> terrList = new List<Territory2>();
//         if(SOH_Filter=='Country'){
//             terrList = [select id,DeveloperName,ParentTerritory2Id,ParentTerritory2.Territory2Type.DeveloperName,fCountry__c,Territory2Type.DeveloperName from Territory2 where Territory2Model.State = 'Active' 
//                                and fCountry__c =: curTerritoty.fCountry__c  AND (Territory2Type.DeveloperName=:SOH_Filter OR ParentTerritory2.Territory2Type.DeveloperName=:SOH_Filter)];
//         }else if(SOH_Filter==''){
//             terrList = [select id,DeveloperName,ParentTerritory2Id,ParentTerritory2.Territory2Type.DeveloperName,fCountry__c,Territory2Type.DeveloperName from Territory2 where Territory2Model.State = 'Active' 
//                                and fCountry__c =: curTerritoty.fCountry__c AND ParentTerritory2Id!=NULL AND Territory2Type.DeveloperName=:currentTerrType];   
//         }else{
//             terrList = [select id,DeveloperName,ParentTerritory2Id,ParentTerritory2.Territory2Type.DeveloperName,fCountry__c,Territory2Type.DeveloperName from Territory2 where Territory2Model.State = 'Active' 
//                                and fCountry__c =: curTerritoty.fCountry__c AND ParentTerritory2Id!=NULL AND Territory2Type.DeveloperName=:SOH_Filter];
//         }
//         for(Territory2 terr : terrList){
//                                    string terrName = null;
//                                    if(allTerrWithChildMap.containsKey(terr.ParentTerritory2Id)){
//                                        allTerWithChildTerrMap.get(terr.ParentTerritory2Id).add(terr);  
//                                        allTerrWithChildMap.get(terr.ParentTerritory2Id).add(terr.id);
//                                    }else{
//                                        allTerrWithChildMap.put(terr.ParentTerritory2Id,new Set<String>{terr.id}); 
//                                        allTerWithChildTerrMap.put(terr.ParentTerritory2Id,new Set<Territory2>{terr});
//                                    }
//                                    allTerrWithParentMap.put(terr.id,terr);
//                                    terrName = terr.DeveloperName.contains(terr.fCountry__c+'_') ? terr.DeveloperName.substringAfter('_') : terr.DeveloperName;
//                                    if(sohTypeMap.containsKey(terr.Territory2Type.DeveloperName)){
//                                        terrTypes.add(sohTypeMap.get(terr.Territory2Type.DeveloperName)) ;
//                                    }
//                                    territoryCdMap.put(terr.DeveloperName.subStringAfter('_').toUpperCase(),terr.Id);
//                                }
//         System.debug('allTerWithChildTerrMap>>'+allTerWithChildTerrMap.size());
//     }
    
//     /*
//     * Method Name : fetchAllLowerLevelTerrWithSOH
//     * Description : Method to return all lower level territory ids based on SOH value selected  in Target Setting & Allocation->Product Allocation tab.If SOH selected is Region then this method would return all territory ids of the lower level territories like Area & Sale Reps Territories    
//     * Params      : d territoryId,Map<String,Set<String>> allTerrWithChidlMap
//     */
//     public static Set<String> fetchAllLowerLevelTerrWithSOH(Id terId,Map<String,Set<String>> allTerrWithChildMap){
//         Set<String> allLowerLevelTerrIds = new Set<String>();
//         List<String> terrIdList = new List<String>();
//         List<String> parentTerrIdList = new List<String>();
//         Map<String,String> parentChildRecMap= new Map<String,String>();
//         Map<String,String> parentChildMap = new Map<String,String>();
//         for(String key:allTerrWithChildMap.keySet()){
//             terrIdList.add(key);
//         }
//         parentChildRecMap = fetchCurrentTerritoryList(terrIdList);
//         String curTerritory;
//         parentChildMap.put(curTerritoty.Id, curTerritoty.ParentTerritory2Id);
//         parentTerrIdList.add(terId);
//          for(String terr: parentTerrIdList){
//                 if(allTerrWithChildMap.containsKey(terr)){
//                     allLowerLevelTerrIds.addAll(allTerrWithChildMap.get(terr));
//                 }else{
//                     if(allTerrWithChildMap.containsKey(parentChildMap.get(terr))){
//                         for(String key:allTerrWithChildMap.get(parentChildMap.get(terr))){
//                             String curTerr = key;
//                             if(curTerr != null && curTerr == terr){
//                                 allLowerLevelTerrIds.add(key);
//                             }
//                         }
//                     }else{
//                         // for(String key:allTerrWithChildMap.keySet()){
//                         //     allLowerLevelTerrIds.addAll(allTerrWithChildMap.get(key));
//                         // }
//                         for(String key:allTerrWithChildMap.keySet()){
//                             String currentTerr = key;
//                             curTerritory = parentChildRecMap.get(currentTerr);
//                             while(curTerritory != null){
//                                 System.debug('terr'+terr);
//                                 System.debug('curTerritory.ParentTerritory2Id'+curTerritory);
//                                 curTerritory = parentChildRecMap.get(currentTerr);
//                                 if(curTerritory != null && curTerritory == terr){
//                                     allLowerLevelTerrIds.addAll(allTerrWithChildMap.get(key));
//                                     break;
//                                 }
//                                 currentTerr=curTerritory;
//                             }
//                         }

//                     }   
//                 }
//             }
//         System.debug('allLowerLevelTerrIds in fetchAllLowerLevelTerrWithSOH >>'+allLowerLevelTerrIds.size());
//         return allLowerLevelTerrIds;
//     }
    
//     /*
//     * Method Name : genParentandChildMapSOH
//     * Description : Method to construct parent/child territory map based on logged in territory.
//     */
//     public static void genParentandChildMap(){
//         terrNameWithId = new Map<String,String>();
//         allTerrWithParentMap = new Map<String,Territory2>();
//         allTerrWithChildMap = new Map<String,Set<String>>();
//         allTerWithChildTerrMap = new Map<String,Set<Territory2>>();
//         System.debug('curTerritoty.fCountry__c>'+curTerritoty.fCountry__c);
//         for(Territory2 terr : [select id,DeveloperName,ParentTerritory2Id,ParentTerritory2.Territory2Type.DeveloperName,fCountry__c,Territory2Type.DeveloperName from Territory2 where Territory2Model.State = 'Active' 
//                                and fCountry__c =: curTerritoty.fCountry__c and ParentTerritory2Id != null]){
//                                    string terrName = null;
//                                    if(allTerrWithChildMap.containsKey(terr.ParentTerritory2Id)){
//                                        allTerWithChildTerrMap.get(terr.ParentTerritory2Id).add(terr);  
//                                        allTerrWithChildMap.get(terr.ParentTerritory2Id).add(terr.id);
//                                    }else{
//                                        allTerrWithChildMap.put(terr.ParentTerritory2Id,new Set<String>{terr.id}); 
//                                        allTerWithChildTerrMap.put(terr.ParentTerritory2Id,new Set<Territory2>{terr});
//                                    }
//                                    allTerrWithParentMap.put(terr.id,terr);
//                                    terrName = terr.DeveloperName.contains(terr.fCountry__c+'_') ? terr.DeveloperName.substringAfter('_') : terr.DeveloperName;
//                                    if(currentTerrType!='Account_Manager'){
//                                        if(sohTypeMap.containsKey(terr.Territory2Type.DeveloperName)){
//                                            terrTypes.add(sohTypeMap.get(terr.Territory2Type.DeveloperName)) ;
//                                        }
//                                    }else{
//                                        terrTypes.add(sohTypeMap.get('Account_Manager')) ;
//                                    } 
									
//                                }
//         if(currentTerrType=='Country'){
//             for(Territory2 terr : [select id,DeveloperName,ParentTerritory2Id,ParentTerritory2.Territory2Type.DeveloperName,fCountry__c,Territory2Type.DeveloperName from Territory2 where Territory2Model.State = 'Active' 
//                                    and fCountry__c =: curTerritoty.fCountry__c and ParentTerritory2Id = null]){
                                       
//                                        if(sohTypeMap.containsKey(terr.Territory2Type.DeveloperName)){
//                                            terrTypes.add(sohTypeMap.get(terr.Territory2Type.DeveloperName)) ;
//                                        }
//                                    }
//         }
//     }
//     /*
//     * Method Name : fetchAllLowerLevelTerrWithSOH
//     * Description : Method to return all lower level territory ids based on logged in user territory  in Target Setting & Allocation->Product Allocation tab.If SOH selected is Region then this method would return all territory ids of the lower level territories like Area & Sale Reps Territories    
//     * Params      : d territoryId,Map<String,Set<String>> allTerrWithChidlMap
//     */
    
//     public static Set<String> fetchAllLowerLevelTerr(Id terId,Map<String,Set<String>> allTerrWithChildMap){        
//         Set<String> allLowerLevelTerrIds = new Set<String>();
//         Set<String> parentTerrIdList = new Set<String>();
//         Set<String> tempList = new Set<String>();
//         allLowerLevelTerrs = new Set<Territory2>();
//         parentTerrIdList.add(terId);
//         allLowerLevelTerrIds.add(terId);
//         Boolean loopExecute = true; 
//         do{                   
//             for(String terr: parentTerrIdList){
//                 if(allTerrWithChildMap.containsKey(terr)){
//                     allLowerLevelTerrIds.addAll(allTerrWithChildMap.get(terr));
//                     allLowerLevelTerrs.addAll(allTerWithChildTerrMap.get(terr));
//                     tempList.addAll(allTerrWithChildMap.get(terr));
//                 }                                         
//             }
//             if(tempList.isEmpty()){ 
//                 string territoryIdval=[select id,DeveloperName,ParentTerritory2Id from Territory2 where id in :parentTerrIdList limit 1].ParentTerritory2Id;
//                 parentTerrIdList.add(territoryIdval);
//                 for(String terr: parentTerrIdList){
//                     if(allTerrWithChildMap.containsKey(terr)){
//                         allLowerLevelTerrIds.addAll(allTerrWithChildMap.get(terr));
//                         allLowerLevelTerrs.addAll(allTerWithChildTerrMap.get(terr));
//                         tempList.addAll(allTerrWithChildMap.get(terr));
//                     }                                         
//                 }
//                 loopExecute = false;
//             }
//             else{
//                 parentTerrIdList.clear();
//                 parentTerrIdList.addAll(tempList);
//                 tempList.clear();
//             }
//         } while(loopExecute);
//         return allLowerLevelTerrIds;                    
//     }    
    
//      /*
//     * Method Name : getProducts
//     * Description : Method to return the products to be displayed while country lead clicks on Add Products button in Target Setting & Allocation -> Product Allocation tab.
//     * 				Products returned is based on the granularity that is set in Manage Seasons-> Product Allocation Functionality.
//     * Params      : String seasonId, String terrId
//     */
//     @AuraEnabled(cacheable=true)
//     public static List<ProductWrapper> getProducts(String seasonId,String terrId){
//         System.debug('seasonId Demo Check>'+seasonId+'-terrId- Demo Check'+terrId);
//         Set<Id> seasonIds = new Set<Id>();
//         Set<String> selectedPrdAllocGranlSubmitted = new Set<String>();
//         Set<String> selectedPrdAllocGranularity = new Set<String>();
//         List<ProductWrapper> prdWrapperList = new List<ProductWrapper>();
//         List<String> prdIdsInPrdAlloc = new List<String>();
//         List<String> prdIdsAdded = new List<String>();
//         Set<String> hierarchyLvl = new Set<String>();
      
//         for(Season__c season:[SELECT Id,Product_Group__c,Parent_Season__c, SellOut_PA_Prd_Granularity_Submitted__c, Line_of_Business__c FROM Season__c 
//                                   WHERE Parent_Season__c =:seasonId AND SellOut_PA_Prd_Granularity_Submitted__c!=null]){
			
//             seasonIds.add(season.Id);
// 			hierarchyLvl.add(season.SellOut_PA_Prd_Granularity_Submitted__c);
//             selectedPrdAllocGranularity.add(season.SellOut_PA_Prd_Granularity_Submitted__c+'-'+season.Line_of_Business__c);
//             prdGrps.add(season.Product_Group__c);
//         }
//         fetchCurrentTerritory(terrId);
//         genParentandChildMap();
//         Set<String> allLowerLevelTerrIds = fetchAllLowerLevelTerr(terrId,allTerrWithChildMap);   
//         for(Prd_Allocation__c prdAlloc:[SELECT Id, Season__c, TerritoryId__c, ProductId__c,Hierarchy_Level_Indicator__c,ProductId__r.Line_Of_Business__c 
//                                         FROM Prd_Allocation__c WHERE Season__c IN:seasonIds AND TerritoryId__c IN:allLowerLevelTerrIds
//                                         AND Hierarchy_Level_Indicator__c IN:hierarchyLvl]){
//                                             String key = prdAlloc.Hierarchy_Level_Indicator__c+'-'+prdAlloc.ProductId__r.Line_Of_Business__c;
//                                             if(selectedPrdAllocGranularity.contains(key)){
//                                                 prdIdsInPrdAlloc.add(prdAlloc.ProductId__c);
//                                             }
//                                         }
//         System.debug('Demo check prdIdsInPrdAlloc +++' + prdIdsInPrdAlloc);
//         for(Products_Services_Portfolio_To_Product__c PSPTP : [SELECT Products_and_Services_Portfolio_SFID__c,Products_and_Services_Portfolio_SFID__r.Product_Group__c,
//                                                                Product_SFID__c,Product_SFID__r.name,Type__c,Product_SFID__r.Line_Of_Business__c, Product_SFID__r.Family,Territory_SF_Id__c,
//                                                                Parent_Products__c,Color_Indicator__c FROM Products_Services_Portfolio_To_Product__c Where 
//                                                                Territory_SF_Id__c IN:allLowerLevelTerrIds and 
//                                                                Products_and_Services_Portfolio_SFID__r.Season_SFID__c IN:seasonIds and
//                                                                Hierarchy_Level_LOB__c IN:selectedPrdAllocGranularity 
//                                                                AND Products_and_Services_Portfolio_SFID__r.Product_Group__c IN:prdGrps 
//                                                                ORDER BY Territory_SF_Id__c LIMIT 10000]){
//                                                                    if(!prdIdsInPrdAlloc.contains(PSPTP.Product_SFID__c) && (prdIdsAdded.size()==0 || !prdIdsAdded.contains(PSPTP.Product_SFID__c))){
//                                                                        ProductWrapper prdWrapper = new ProductWrapper();
//                                                                        System.debug('Demo Check inside if psp' + PSPTP.Product_SFID__c );
//                                                                        prdWrapper.prdId = PSPTP.Product_SFID__c;
//                                                                        prdIdsAdded.add(PSPTP.Product_SFID__c);
//                                                                        prdWrapper.prdName = PSPTP.Product_SFID__r.Name;
//                                                                        prdWrapper.prdGrp = PSPTP.Products_and_Services_Portfolio_SFID__r.Product_Group__c;
//                                                                        prdWrapper.prdLOB = PSPTP.Product_SFID__r.Line_Of_Business__c;
//                                                                        prdWrapper.prdColorIndicator = PSPTP.Color_Indicator__c;
//                                                                        prdWrapper.psptp = PSPTP;
//                                                                        prdWrapperList.add(prdWrapper);
//                                                                    }
//                                                                }
//         System.debug('prdWrapperList>'+prdWrapperList.size());        
//         return prdWrapperList;
//     }
//      /*
//     * Method Name : generateAllocRecs
//     * Description : Method to generate the Prd Allocation records while country lead selects the Products from Target Setting & Allocation -> Product Allocation tab -> Add Products and clicks on Save.
//     * 				Allocation records are generated for all the upper hierarchy product granularity that is been set in Manage Seasons and for all the territory levels.
//     * Params      : List<Products_Services_Portfolio_To_Product__c> psptpList,String terrId,List<Id> seasonIds
//     */
//     @AuraEnabled
//     public static List<String> generateAllocRecs(List<Products_Services_Portfolio_To_Product__c> psptpList,String terrId,List<Id> seasonIds){
        
//         List<Prd_Allocation__c> prdAllocList = new List<Prd_Allocation__c>();
//         List<String> prdTerrIds = new List<String>();
//         Boolean isEqual = false;
        
//         List<Products_Services_Portfolio_To_Product__c> psptpLst = new List<Products_Services_Portfolio_To_Product__c>();
//         Set<String> pspTerrIds = new Set<String>();
//         Map<String,List<String>>  parentProdIds = new Map<String,List<String>>();
//         String parentAllocId = null;
//         List<Prd_Allocation__c> updatedLst = new List<Prd_Allocation__c>();
//         List<String> parentPrds = new List<String>();
//         Map<String,String> prdHierarchyLvlIndMap = new Map<String,String>();
//         Map<String,Set<String>> prdWithTerrMap = new Map<String,Set<String>>(); 
//         Decimal value=0;
//         try{
//             System.debug('psptpList>>>+psptpList'+psptpList);
//             for(Products_Services_Portfolio_To_Product__c ps:psptpList){
//                 System.debug('ps.Parent_Products__c>>'+ps.Parent_Products__c);
//                 parentPrds.addAll(ps.Parent_Products__c!=null?ps.Parent_Products__c.split(','):new List<String>());
//                 parentPrds.add(ps.Product_SFID__c);
//                 prdIds.add(ps.Product_SFID__c);
//             }            
//             fetchCurrentTerritory(terrId);
//             genParentandChildMap();
//             Set<String> allLowerLevelTerrIds = fetchAllLowerLevelTerr(terrId,allTerrWithChildMap);            
//             List<Id> seasnIds = new List<Id>(seasonIds);
//             seasonIds = new List<Id>();
//             for(Season__c season:[SELECT Id,Product_Group__c,Parent_Season__c, SellOut_PA_Prd_Granularity_Submitted__c, Line_of_Business__c FROM Season__c 
//                                   WHERE Parent_Season__c IN:seasnIds AND SellOut_PA_Prd_Granularity_Submitted__c!=null]){
//                                       seasonIds.add(season.Id);
//                                   }
//             System.debug('seasonIds>'+seasonIds);
//             for(Products_Services_Portfolio_To_Product__c prdSptp : [SELECT Id,Name,Products_and_Services_Portfolio_SFID__c,Products_and_Services_Portfolio_SFID__r.Product_Group__c,
//                                                                      Product_SFID__c,Product_SFID__r.name,Type__c,Product_SFID__r.Line_Of_Business__c, Product_SFID__r.Family,Territory_SF_Id__c,
//                                                                      Hierarchy_Level_LOB__c,Parent_Products__c,Products_and_Services_Portfolio_SFID__r.Territory_SFID__c,Product_SFID__r.Hierarchy_Level_Indicator__c,
//                                                                      Products_and_Services_Portfolio_SFID__r.Season_SFID__c 
//                                                                      FROM Products_Services_Portfolio_To_Product__c Where 
//                                                                      Territory_SF_Id__c IN:allLowerLevelTerrIds and 
//                                                                      Products_and_Services_Portfolio_SFID__r.Season_SFID__c IN:seasonIds 
//                                                                      AND Products_Services_Portfolio_To_Product__c.Product_SFID__c IN:parentPrds
//                                                                      ORDER BY Territory_SF_Id__c]){
//                                                                          if(prdIds.contains(prdSptp.Product_SFID__c)){
//                                                                             prdTerrIds.add(prdSptp.Products_and_Services_Portfolio_SFID__r.Territory_SFID__c+'-'+prdSptp.Product_SFID__c) ;
//                                                                          }
//                                                                          psptpLst.add(prdSptp);
//                                                                          pspTerrIds.add(prdSptp.Products_and_Services_Portfolio_SFID__r.Territory_SFID__c);
//                                                                          parentProdIds.put(prdSptp.Product_SFID__c+'-'+prdSptp.Products_and_Services_Portfolio_SFID__r.Season_SFID__c,prdSptp.Parent_Products__c.split(','));
//                                                                          prdHierarchyLvlIndMap.put(prdSptp.Product_SFID__c,prdSptp.Product_SFID__r.Hierarchy_Level_Indicator__c);
//                                                                      }
//             Map<String,Prd_Allocation__c> existingAllocRecs = new Map<String,Prd_Allocation__c>();
//             for(Prd_Allocation__c alloc: [SELECT Id, ProductId__c,TerritoryId__c, Season__c FROM Prd_Allocation__c
//                                           WHERE TerritoryId__c IN:allLowerLevelTerrIds AND Season__c IN:seasonIds AND ProductId__c IN: parentPrds]){
//                 existingAllocRecs.put(alloc.TerritoryId__c+'-'+alloc.Season__c+'-'+alloc.ProductId__c,alloc);
//             }
//             String prdId='';
//             List<Id> allocIds = new List<Id>();
//             if(!psptpLst.isEmpty() && !pspTerrIds.isEmpty()){
//                 prdWithTerrMap = pSPProdWithAllTerr(psptpLst,pspTerrIds); 
//                 if(prdWithTerrMap!=null && prdWithTerrMap.size()>0){                    
//                     for(String key:prdWithTerrMap.KeySet()){
//                         for(String val:prdWithTerrMap.get(key)){
//                             System.debug('val--'+(val+'-'+key.substringAfter('-')+'-'+key.substringBefore('-')));
//                             if(!(existingAllocRecs.containsKey(val+'-'+key.substringAfter('-')+'-'+key.substringBefore('-')))){
//                                 System.debug('Inside If');
//                                 prdId = key.substringBefore('-');
//                                 Prd_Allocation__c prdAlloc = new Prd_Allocation__c();
//                                 prdAlloc.TerritoryId__c = val;
//                                 prdAlloc.ProductId__c = key.substringBefore('-');
//                                 prdAlloc.Season__c = key.substringAfter('-');
//                                 prdAlloc.ParentTerritoryId__c = allTerrWithParentMap.containsKey(val)?allTerrWithParentMap.get(val).ParentTerritory2Id:null;
//                                 prdAlloc.Hierarchy_Level_Indicator__c = prdHierarchyLvlIndMap.containsKey(key.substringBefore('-'))?prdHierarchyLvlIndMap.get(key.substringBefore('-')):null;
//                                 prdAllocList.add(prdAlloc);
//                             }else{    
//                                 System.debug('Inside Else');
//                                 allocIds.add(existingAllocRecs.get(val+'-'+key.substringAfter('-')+'-'+key.substringBefore('-')).id);
//                             }
//                         }
//                     }
//                 }
//             } 
//             System.debug('allocIds>>'+allocIds);
            
//             if(prdAllocList.size()>0){            
//                 Database.SaveResult[] newAllocList = Database.insert(prdAllocList,false);
//                 for (Database.SaveResult sr : newAllocList)
//                 { 
//                     if (sr.isSuccess()) {
//                         allocIds.add(sr.getId());
//                     }else{
//                         for(Database.Error objErr : sr.getErrors()) {
//                             String error ='Error in DataBaseInsert ==Product Allocation=='+objErr.getStatusCode() + '== Message ==' + objErr.getMessage()+'== fields =='+ objErr.getFields();
//                             System.debug(error);
//                         }
//                     }
//                 }
//             }
//             // Update parent allocation id.
//             System.debug('allocIds>>'+allocIds.size());
//             Map<String, String> prdAllocNewMap = new Map<String, String>();
//             List<Prd_Allocation__c> newPrdAllocList = [SELECT Id, ProductId__c,Hierarchy_Level_Indicator__c ,TerritoryId__c, Season__c,ParentAllocation__c 
//                                                     FROM Prd_Allocation__c WHERE  Id IN:allocIds];
//                                                     for(Prd_Allocation__c alloc: newPrdAllocList){
//                                                         String prId = alloc.ProductId__c;
//                                                         prdAllocNewMap.put(prId.substring(0,prId.length()-3)+'-'+alloc.TerritoryId__c,alloc.Id);
//                                                         system.debug('key3'+alloc.ProductId__c+'-'+alloc.TerritoryId__c);

//                                                     }
//             system.debug('prdAllocNewMap'+prdAllocNewMap);
//             system.debug('prdAllocNewMap'+prdAllocNewMap.size());

//             Map<String, String> prdAllocMap = new Map<String, String>();
//             for(Prd_Allocation__c alloc:[SELECT Id, ProductId__c,Hierarchy_Level_Indicator__c ,TerritoryId__c, Season__c,ParentAllocation__c 
//                                          FROM Prd_Allocation__c 
//                                          WHERE Id IN:allocIds ORDER BY Hierarchy_Level_Indicator__c,TerritoryId__c]){
//                                             String key=alloc.ProductId__c+'-'+alloc.Season__c;
//                                             List<String> pIds = null;
//                                             String parentId =null;
//                                              if(parentProdIds.containsKey(key)){
//                                                  pIds = parentProdIds.get(key);
//                                                  if(pIds.size()>0){
//                                                     parentId = pIds[0];
//                                                  }
//                                                  //system.debug('pIds'+pIds);
//                                                  system.debug('parentId'+parentId);
                                             
//                                                 if(alloc.Hierarchy_Level_Indicator__c != 'L1'){
//                                                     String key1 = parentId+'-'+alloc.TerritoryId__c;
//                                                     system.debug('key1'+key1);
//                                                                                                        alloc.ParentAllocation__c = prdAllocNewMap.get(parentId+'-'+alloc.TerritoryId__c);
//                                                     //system.debug('prdAllocMap'+prdAllocNewMap.get(parentId+'-'+alloc.TerritoryId__c));   
//                                                 }else{
//                                                     alloc.ParentAllocation__c = null;
//                                                 }
//                                                  //parentAllocId = alloc.Id;
//                                              }
                                            
//                                              updatedLst.add(alloc);
//                                          }
//             if(!updatedLst.isEmpty()){
//                 update updatedLst;
//                 System.debug('After Update');
//             }
//         }catch(Exception e){
//             System.debug('gsfpClsProductAllocation.generateAllocRecs==='+e.getMessage()+'==Line No:=='+e.getLineNumber());
//         }    
//         System.debug('prdTerrIds>>>'+prdTerrIds);
//         return prdTerrIds;
//     }
    
//     /*
//     * Method Name : deletePrdAllocRecs
//     * Description : Method to delete the Prd Allocation records while country lead selects the Products from Target Setting & Allocation -> Product Allocation tab and clicks on Delete icon.    
//     * Params      : List<String> prodIds,List<String>seasnIds
//    */
//     @AuraEnabled
//     public static void deletePrdAllocRecs(List<String> prodIds,List<String>seasnIds){
//         List<Prd_Allocation__c> deletePrdAllocRecs = new List<Prd_Allocation__c>();
//         Set<String> prdIds = new Set<String>();
//         Set<String> seasonIds = new Set<String>();
//         System.debug('deletePrdAllocRecs--'+prodIds+'seasonIds--'+seasnIds);
//         for(Season__c season:[SELECT Id,Product_Group__c,Parent_Season__c, SellOut_PA_Prd_Granularity_Submitted__c, Line_of_Business__c FROM Season__c 
//                                   WHERE Parent_Season__c IN:seasnIds AND SellOut_PA_Prd_Granularity_Submitted__c!=null]){
//                                       seasonIds.add(season.Id);
//                                   }
//         for(Prd_Allocation__c prdAlloc:[SELECT Id,ProductId__c,Season__c FROM Prd_Allocation__c WHERE ProductId__c IN:prodIds AND Season__c IN:seasonIds]){
//             deletePrdAllocRecs.add(prdAlloc);
//         }
//         System.debug('deletePrdAllocRecs--'+deletePrdAllocRecs.size());
//         if(!deletePrdAllocRecs.isEmpty()){
//             delete deletePrdAllocRecs;
//         }
//     }
    
//      /*
//     * Method Name : pSPProdWithAllTerr
//     * Description : Method to return all Product Ids and associated Territory ids based on PSPTP records and the terrids. construct maps for all higher level territories as PSPTP records are available only for lower level territories(sales reps terr)
//     * Params      : List<Products_Services_Portfolio_To_Product__c> pspLst,set<string>  pspTerrIds
//    */
//     private static Map<String,Set<String>> pSPProdWithAllTerr(List<Products_Services_Portfolio_To_Product__c> pspLst,set<string>  pspTerrIds){
//         Map<String,Set<String>> prodWithTerrMap = new Map<String,Set<String>>();
//         Map<string,set<string>> terrwithAllHigher = new  Map<string,set<string>>();
//         System.debug('pspTerrIds>>>'+pspTerrIds);
//         for(string terrId : pspTerrIds){           
//             if(allTerrWithParentMap.containsKey(terrId)){                    
//                 String childTerrId = terrId;
//                 Boolean loopContinue = true;                
//                 do{
//                     if(allTerrWithParentMap.containsKey(childTerrId)){
//                         string pterrId = allTerrWithParentMap.get(childTerrId).ParentTerritory2Id;
//                         if(terrwithAllHigher.containsKey(terrId)){
//                             terrwithAllHigher.get(terrId).add(pterrId);
//                         }else{
//                             terrwithAllHigher.put(terrId,new set<String>{pterrId});
//                         }
//                         childTerrId = pterrId;
//                     }else{
//                         loopContinue = false;
//                     }
//                 } while(loopContinue);              
//             }
//         }   
//         System.debug('terrwithAllHigher>>'+terrwithAllHigher);
//         for(Products_Services_Portfolio_To_Product__c psp2p : pspLst){
//            if(prodWithTerrMap.containsKey(psp2p.Product_SFID__c+'-'+psp2p.Products_and_Services_Portfolio_SFID__r.Season_SFID__c)){
//                 if(terrwithAllHigher.containsKey(psp2p.Products_and_Services_Portfolio_SFID__r.Territory_SFID__c)){
//                     prodWithTerrMap.get(psp2p.Product_SFID__c+'-'+psp2p.Products_and_Services_Portfolio_SFID__r.Season_SFID__c).addAll(terrwithAllHigher.get(psp2p.Products_and_Services_Portfolio_SFID__r.Territory_SFID__c));
//                 }                
//                 prodWithTerrMap.get(psp2p.Product_SFID__c+'-'+psp2p.Products_and_Services_Portfolio_SFID__r.Season_SFID__c).add(psp2p.Products_and_Services_Portfolio_SFID__r.Territory_SFID__c);
//             }else{
//                 prodWithTerrMap.put(psp2p.Product_SFID__c+'-'+psp2p.Products_and_Services_Portfolio_SFID__r.Season_SFID__c,new set<string>{psp2p.Products_and_Services_Portfolio_SFID__r.Territory_SFID__c});
//                 if(terrwithAllHigher.containsKey(psp2p.Products_and_Services_Portfolio_SFID__r.Territory_SFID__c)){
//                     prodWithTerrMap.get(psp2p.Product_SFID__c+'-'+psp2p.Products_and_Services_Portfolio_SFID__r.Season_SFID__c).addAll(terrwithAllHigher.get(psp2p.Products_and_Services_Portfolio_SFID__r.Territory_SFID__c));
//                 }                    
//             } 
//         }
//         System.debug('prodWithTerrMap>>'+prodWithTerrMap);
//         return prodWithTerrMap;
//     }
    
//      /*
//     * Method Name : getProdAllocDetails
//     * Description : Method to return all products to be displayed in the Select product dropdown.Target Setting & Allocation->Product Allocation tab-> Select Products
//     * Params      : String terrId,String lob,String SOH,String seasonId
//    */
    
//     @AuraEnabled(cacheable=true)
//     public static ProductTerrWrapper getProdAllocDetails(String terrId,String lob,String SOH,String seasonId){        
//         Set<String> productIds = new Set<String>();
//         Set<String> terrIds = new Set<String>();
//         Set<String> parentTerrIds = new Set<String>();
//          Set<String> allLowerLevelTerrIds = new Set<String>();
//         Set<String> selectedPrdAllocGranularity = new Set<String>();
//         Set<String> seasonIds = new Set<String>();
//         List<String> lobList = new List<String>();
//         Map<String,String> prdMap = new Map<String,String>();
//         ProductTerrWrapper prdTerrWrapper = new ProductTerrWrapper();
//         Map<String,String> granlLobMap = new Map<String,String>();
//         String currentTerrType = '';
//         try{
//             curTerritoty = fetchCurrentTerritory(terrId);
//             COUNTRY_CODE = curTerritoty.fCountry__c;
//             currentTerrType = curTerritoty.Territory2Type.DeveloperName;
//             constructSOHValMap();
//             SOH_Filter = sohValMap.containsKey(SOH)?sohValMap.get(SOH):'';
//             genParentandChildMapSOH(currentTerrType);
//             allLowerLevelTerrIds = fetchAllLowerLevelTerrWithSOH(terrId,allTerrWithChildMap);
//             if(lob =='All'){
//                 lobList.add('Row Crops');
//                 lobList.add('Crop Protection');
//             }else{
//                 lobList.add(lob);
//             }
//             for(Season__c season:[SELECT Id,Parent_Season__c,SOH_Config_For_Prd_Allocation__c, SellOut_PA_Prd_Granularity_Submitted__c,Line_of_Business__c FROM Season__c 
//                                   WHERE Parent_Season__c =:seasonId AND SellOut_PA_Prd_Granularity_Submitted__c!=null]){
                                      
//                                       seasonIds.add(season.id);
//                                       selectedPrdAllocGranularity.add(season.SellOut_PA_Prd_Granularity_Submitted__c);
//                                       granlLobMap.put(season.Line_of_Business__c,season.SellOut_PA_Prd_Granularity_Submitted__c);
                                      
//                                   }
//             for(SOH_Config__mdt sohMt:[SELECT Id, SOH_Editable__c, SOH_Types__c, Country_Code__c FROM SOH_Config__mdt WHERE Country_Code__c=:COUNTRY_CODE]){
//                 SOHConfig.addAll(sohMt.SOH_Editable__c.split(','));
//             }
//             System.debug('seasonIds>>'+seasonIds+'---'+selectedPrdAllocGranularity+'-granlLobMap'+granlLobMap+'lobList==>'+lobList+'selectedPrdAllocGranularity=='+selectedPrdAllocGranularity+'allLowerLevelTerrIds=='+allLowerLevelTerrIds);
//             for(Prd_Allocation__c alloc:[SELECT Id,Hierarchy_Level_Indicator__c ,ProductId__r.Line_Of_Business__c,ProductId__c,ProductId__r.Product_Group__c,ProductId__r.Name,ProductId__r.Family ,TerritoryId__c, 
//                                          Previous_Allocation__c,Allocated_Product_Cascaded__c,ParentTerritoryId__c,Allocated_Product_Draft__c,Season__c FROM Prd_Allocation__c 
//                                          WHERE TerritoryId__c IN:allLowerLevelTerrIds AND Season__c IN:seasonIds 
//                                          AND ProductId__r.Line_Of_Business__c IN:lobList AND Hierarchy_Level_Indicator__c  IN :selectedPrdAllocGranularity]){
//                                              if(granlLobMap.containsKey(alloc.ProductId__r.Line_Of_Business__c) && granlLobMap.get(alloc.ProductId__r.Line_Of_Business__c)==alloc.Hierarchy_Level_Indicator__c){  
//                                                  prdMap.put(alloc.ProductId__c,alloc.ProductId__r.Name);
//                                                  terrIds.add(alloc.TerritoryId__c);
//                                                  if(currentTerrType!='Account_Manager'){
//                                                      terrIds.add(alloc.ParentTerritoryId__c);
//                                                      parentTerrIds.add(alloc.ParentTerritoryId__c);
//                                                     }
//                                               }                                             
//                                          }
//             prdTerrWrapper.seasonIds = seasonIds;
//             prdTerrWrapper.prdMap = prdMap;
//             prdTerrWrapper.terrIds=terrIds;
//             prdTerrWrapper.parentTerrIds=parentTerrIds;
//             prdTerrWrapper.sohEditable = SOHConfig;
//             prdTerrWrapper.currentTerrType = currentTerrType;
//         }catch(Exception e){
//             System.debug('Exception occured in gsfpClsProductAllocation.getProdAllocDetails==='+e.getMessage()+'==Line No=='+e.getLineNumber());
//         }
//         System.debug('terrIds in prdAlloc>>>'+terrIds);
//         return prdTerrWrapper;
//     }
    
//     /*
//     * Method Name : constructProdAllocWrapper
//     * Description : Method to return all details to be displayed in the table based on the products selected & filters applied in Target Setting & Allocation-> Product Allocation tab.
//     * Params      : List<String> terrIds,List<String> productIds,List<String> seasonIds,String lob,List<String> sohEditableLst,String SOH,Boolean isTerrClicked,String fnc,String currentTerrType
//    */
//     @AuraEnabled(cacheable=true)
//     public static ProductAllocationWrapper constructProdAllocWrapper(List<String> terrIds,List<String> parentTerrIds,List<String> productIds,List<String> seasonIds,String lob,List<String> sohEditableLst,String SOH,Boolean isTerrClicked,String fnc,String currentTerrType,Decimal randomDecimal){
//         System.debug('terrIds>>'+terrIds);
//         System.debug('productIds>>'+productIds);
//         System.debug('seasonIds>>'+seasonIds+'-SOH-'+SOH);
//          List<String> finalList = new List<String>();
//           List<String> parentTerIdList = new List<String>();
//         finalList.clear();
//         parentTerIdList.clear();
//         String loggedUserId;
//         ProductAllocationWrapper mainWrap = new ProductAllocationWrapper();
//         Map<String,List<AllocWrapper>> prdAllocMap = new Map<String,List<AllocWrapper>>();
//         Map<String,Decimal> remAllocMap = new Map<String,Decimal>();        
//         List<String> prdTerrIds = new List<String>();
//         List<String> lobList = new List<String>();
//         Map<String,String> prdNameMap = new Map<String,String>();
//         Map<String,Prd_Allocation__c> allocMap = new Map<String,Prd_Allocation__c>();        
//         Map<String,Decimal> prdSalesMap = new Map<String,Decimal>();
//         Map<String,Decimal> isfMap = new Map<String,Decimal>();
//         Map<String,Decimal> salesPlanMap = new Map<String,Decimal>();
//         Map<String,Decimal> aboveAllocMap = new Map<String,Decimal>();
//         Map<String,Decimal> fsfMap = new Map<String,Decimal>();
//         Map<String,Decimal> prdNetPriceMap = new Map<String,Decimal>();
//         Map<String,Territory2> parentTerrMap = new Map<String,Territory2>();
//         Map<string,set<string>> terrwithAllHigher = new  Map<string,set<string>>();
//         Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sales_Plan').getRecordTypeId();
//         terrNameWithId = new Map<String,String>();
//         Map<String,String> terrIdToTerrType = new Map<String,String>();
//         List<String> oppTerrIDs = new List<String>(terrIds);
//         List<String> oppTerrCPIDs = new List<String>(terrIds);
//         List<String> prdSalesTerrIds = new List<String>(terrIds);
//          List<String> parntTerrClckIds = new List<String>();
//         Decimal netPrice=1;
//         Decimal value=0;
//         loggedUserId = UserInfo.getUserId();
//         system.debug('loggedUserId==>'+loggedUserId);
//         UserTerritory2Association userTerrAssct = [SELECT Id, UserId, Territory2.Territory_Role_Descr__c  from UserTerritory2Association where UserId = :loggedUserId LIMIT 1];
//         String loggedUserRole = userTerrAssct.Territory2.Territory_Role_Descr__c;
//         if(lob =='All'){
//             lobList.add('Row Crops');
//             lobList.add('Crop Protection');
//         }else{
//             lobList.add(lob);
//         }
//         constructSOHValMap();
//         constructSOHMap();
//         String cntry  = '';
//         if(!terrIds.isEmpty()){
//             cntry = fetchCurrentTerritory(terrIds.get(0)).fCountry__c;
//         }
        
//         System.debug('terrIds Before clicked method>>>'+terrIds);
//         //When user clicks the territory hyperlink from Prd Allocation Page to navigate to its child territories.
//         String clickedTerrId = '';
//         if(isTerrClicked){
//             clickedTerrId = terrIds.get(0);
//             oppTerrIDs = new List<String>{terrIds.get(0)};
//             oppTerrCPIDs = new List<String>{terrIds.get(0)};
//             for(Prd_Allocation__c alloc:[SELECT Id,Hierarchy_Level_Indicator__c ,ProductId__r.Line_Of_Business__c,ProductId__c,ProductId__r.Product_Group__c,ProductId__r.Name,ProductId__r.Family ,TerritoryId__c, 
//                                          Previous_Allocation__c,Allocated_Product_Cascaded__c,ParentTerritoryId__c,Allocated_Product_Draft__c,Season__c FROM Prd_Allocation__c 
//                                          WHERE ParentTerritoryId__c IN:terrIds AND Season__c IN:seasonIds 
//                                          AND ProductId__c IN:productIds]){
//                                              terrIds.add(alloc.TerritoryId__c);
//                                              terrIds.add(alloc.ParentTerritoryId__c);
//                                              parntTerrClckIds.add(alloc.ParentTerritoryId__c);
//                                           }
//         }
//         System.debug('terrIds>>'+clickedTerrId);
//         SOH_Filter = sohValMap.containsKey(SOH)?sohValMap.get(SOH):'';
//         System.debug('SOH_Filter>'+SOH_Filter);
        
//         for(Territory2 terr: [SELECT Id,Description,DeveloperName,ParentTerritory2Id,Territory2Type.DeveloperName FROM Territory2 WHERE fCountry__c =:cntry AND Territory2Model.State = 'Active'])  {
//             if(terrIds.contains(terr.id)){
//                 if(clickedTerrId!=null && clickedTerrId!='' && String.valueOf(terr.id) != clickedTerrId){
//                     SOH_Filter = sohValMap.containsKey(terr.Territory2Type.DeveloperName)?sohValMap.get(terr.Territory2Type.DeveloperName):'';
//                 }
//             }            
//             terrNameWithId.put(terr.id,terr.Description);
//             parentTerrMap.put(terr.id,terr);
//             terrIdToTerrType.put(terr.id,terr.Territory2Type.DeveloperName);
//             territoryCdMap.put(terr.DeveloperName.subStringAfter('_').toUpperCase(),terr.Id);
//         }
//         String granularity = '';
//         Map<String,String> prdGrpMap = new Map<String,String>();
        
//         Map<String,String> prdColorMap = new Map<String,String>();
//         Map<String,Set<String>> childToParent = new Map<String,Set<String>>();
//         Map<String,Set<String>> parentChildMap = new Map<String,Set<String>>();


       
//         Set<String> psTerrIds = new Set<String>();
//         for(Products_Services_Portfolio_To_Product__c PSPTP : [SELECT Id,Product_SFID__r.Product_Group__c,Product_SFID__c,Territory_SF_Id__c,Net_Price__c,Color_Indicator__c  FROM Products_Services_Portfolio_To_Product__c 
//                                                                Where Products_and_Services_Portfolio_SFID__r.Season_SFID__c IN:seasonIds and
//                                                                Product_SFID__c IN:productIds ORDER BY Territory_SF_Id__c]){
//                                                                    prdNetPriceMap.put(PSPTP.Product_SFID__c , PSPTP.Net_Price__c);
//                                                                    prdColorMap.put(PSPTP.Territory_SF_Id__c+'-'+PSPTP.Product_SFID__c,PSPTP.Color_Indicator__c);
//                                                                    psTerrIds.add(PSPTP.Territory_SF_Id__c+'-'+PSPTP.Product_SFID__c);
//                                                                }
//         for(string key : psTerrIds){ 
//             String color = prdColorMap.containsKey(key)?prdColorMap.get(key):'';
//             String terrId = key.subStringBefore('-');
//             String terrDevNam = terrIdToTerrType.containsKey(terrId)?terrIdToTerrType.get(terrId):'';
//             if(parentTerrMap.containsKey(terrId)){                    
//                 String childTerrId = terrId;
//                 Boolean loopContinue = true;                
//                 do{
//                     if(parentTerrMap.containsKey(childTerrId)){
//                         string pterrId = parentTerrMap.get(childTerrId).ParentTerritory2Id;
//                         prdColorMap.put(pterrId+'-'+key.subStringAfter('-'),color);     
//                         if(childToParent.containsKey(terrId)){
//                             Set<String> s = childToParent.get(terrId);
//                             s.add(pterrId);                            
// 							childToParent.put(terrId,s);                            
//                         }else{
//                             childToParent.put(terrId,new Set<String>{pterrId});
//                         }
//                         childTerrId = pterrId;
//                     }else{
//                         loopContinue = false;
//                     }
//                 } while(loopContinue);              
//             }
//         }   
//         System.debug('prdColorMap>'+prdColorMap);
//         Set<Id> prdAllocTerrIds = new Set<Id>();
//         for(Prd_Allocation__c alloc:[SELECT Id,Is_freezed__c,Hierarchy_Level_Indicator__c ,ProductId__r.Line_Of_Business__c,ProductId__c,ProductId__r.Product_Group__c,ProductId__r.Name,ProductId__r.Family ,TerritoryId__c, 
//                                      Previous_Allocation__c,Allocated_Product_Cascaded__c,ParentTerritoryId__c,Allocated_Product_Draft__c,Season__c,
//                                      Allocated_Product_Draft_FSF__c,Allocated_Product_Draft_SP__c, Allocated_Prd_Cascaded_SP__c,Allocated_Prd_Cascaded_FSF__c,
//                                      Previous_Allocation_FSF__c,Previous_Allocation_SP__c, Is_freezed_FSF__c, Is_freezed_SP__c FROM Prd_Allocation__c 
//                                      WHERE TerritoryId__c IN:terrIds AND Season__c IN:seasonIds AND ProductId__c IN:productIds ORDER BY ParentTerritoryId__c]){
//                                          prdTerrIds.add(alloc.TerritoryId__c+'-'+alloc.ProductId__c);
//                                          prdAllocTerrIds.add(alloc.TerritoryId__c);
//                                          allocMap.put(alloc.TerritoryId__c+'-'+alloc.ProductId__c,alloc);
//                                          prdNameMap.put(alloc.ProductId__c,alloc.ProductId__r.Name);
//                                          prdGrpMap.put(alloc.ProductId__c,alloc.ProductId__r.Product_Group__c!=null?alloc.ProductId__r.Product_Group__c:alloc.ProductId__r.Family);
//                                          granularity = alloc.Hierarchy_Level_Indicator__c;
//                                          if(!parentChildMap.containsKey(alloc.ParentTerritoryId__c+'-'+alloc.ProductId__c)){
//                                             parentChildMap.put(alloc.ParentTerritoryId__c+'-'+alloc.ProductId__c, new Set<String>{alloc.TerritoryId__c+'-'+alloc.ProductId__c});
//                                         }else{
//                                             parentChildMap.get(alloc.ParentTerritoryId__c+'-'+alloc.ProductId__c).add(alloc.TerritoryId__c+'-'+alloc.ProductId__c);
//                                         }

//                                      }
//         System.debug('prdTerrIds>'+prdTerrIds);
       
       
//         parentTerIdList.addAll(parentTerrIds);
//         if(isTerrClicked){
//            parentTerIdList.clear();
//            parentTerIdList.addAll(parntTerrClckIds);
//         }
//                 List<Prd_Allocation__c> parentRecords = [SELECT Id, ParentTerritoryId__c,TerritoryId__c,ProductId__c,ProductId__r.Name FROM Prd_Allocation__c WHERE TerritoryId__c 
//                                                 IN: parentTerIdList
//                                                 AND Season__c IN:seasonIds AND ProductId__c IN:productIds];
//         for(Prd_Allocation__c prd : parentRecords){
//             if(parentChildMap.containsKey(prd.TerritoryId__c+'-'+prd.ProductId__c)){
//                 finalList.add(prd.TerritoryId__c+'-'+prd.ProductId__c);
//                 finalList.addAll(parentChildMap.get(prd.TerritoryId__c+'-'+prd.ProductId__c));
//                 }
//             }
//                 if(currentTerrType=='Account_Manager'){
//             finalList.clear();
//             finalList.addAll(prdTerrIds);
//         }
        
//         System.debug('finalList>'+finalList);

//         Decimal remainingAlloc = 0;
//         system.debug('prdAllocTerrIds==>'+prdAllocTerrIds+'seas==>'+seasonIds+'productIds==>'+productIds);
//         for(Prd_Allocation__c alloc:[SELECT Id,Hierarchy_Level_Indicator__c ,Is_freezed__c,ProductId__r.Line_Of_Business__c,ProductId__c,ProductId__r.Product_Group__c,ProductId__r.Name,ProductId__r.Family ,TerritoryId__c, 
//                                      Previous_Allocation__c,Allocated_Product_Cascaded__c,ParentTerritoryId__c,Allocated_Product_Draft__c,Season__c,Is_freezed_FSF__c,
//                                      Allocated_Product_Draft_FSF__c,Allocated_Product_Draft_SP__c, Allocated_Prd_Cascaded_SP__c,Allocated_Prd_Cascaded_FSF__c,
//                                      Previous_Allocation_FSF__c,Previous_Allocation_SP__c, Is_freezed_SP__c  FROM Prd_Allocation__c 
//                                      WHERE ParentTerritoryId__c IN:prdAllocTerrIds AND Season__c IN:seasonIds AND ProductId__c IN:productIds ORDER BY ParentTerritoryId__c]){
//                                          allocMap.put(alloc.TerritoryId__c+'-'+alloc.ProductId__c,alloc);
//                                          if(!remAllocMap.containsKey(alloc.ParentTerritoryId__c+'-'+alloc.ProductId__c)){
//                                              if(fnc=='ISF'){
//                                                  remAllocMap.put(alloc.ParentTerritoryId__c+'-'+alloc.ProductId__c,alloc.Allocated_Product_Cascaded__c);
//                                              }else if(fnc=='FSF'){
//                                                  remAllocMap.put(alloc.ParentTerritoryId__c+'-'+alloc.ProductId__c,alloc.Allocated_Prd_Cascaded_FSF__c);
//                                              }else if(fnc=='Sales Plan'){
//                                                  remAllocMap.put(alloc.ParentTerritoryId__c+'-'+alloc.ProductId__c,alloc.Allocated_Prd_Cascaded_SP__c);
//                                              }
                                             
//                                          }else{
//                                              if(fnc=='ISF'){
//                                                  remainingAlloc = remAllocMap.get(alloc.ParentTerritoryId__c+'-'+alloc.ProductId__c)!=null?remAllocMap.get(alloc.ParentTerritoryId__c+'-'+alloc.ProductId__c):0;
//                                                  remainingAlloc += alloc.Allocated_Product_Cascaded__c!=null?alloc.Allocated_Product_Cascaded__c:0;
//                                                  remAllocMap.put(alloc.ParentTerritoryId__c+'-'+alloc.ProductId__c,remainingAlloc);
//                                              }else if(fnc=='FSF'){
//                                                   remainingAlloc = remAllocMap.get(alloc.ParentTerritoryId__c+'-'+alloc.ProductId__c)!=null?remAllocMap.get(alloc.ParentTerritoryId__c+'-'+alloc.ProductId__c):0;
//                                                  remainingAlloc += alloc.Allocated_Prd_Cascaded_FSF__c!=null?alloc.Allocated_Prd_Cascaded_FSF__c:0;
//                                                  remAllocMap.put(alloc.ParentTerritoryId__c+'-'+alloc.ProductId__c,remainingAlloc);
//                                              }else if(fnc=='Sales Plan'){
//                                                   remainingAlloc = remAllocMap.get(alloc.ParentTerritoryId__c+'-'+alloc.ProductId__c)!=null?remAllocMap.get(alloc.ParentTerritoryId__c+'-'+alloc.ProductId__c):0;
//                                                  remainingAlloc += alloc.Allocated_Prd_Cascaded_SP__c!=null?alloc.Allocated_Prd_Cascaded_SP__c:0;
//                                                  remAllocMap.put(alloc.ParentTerritoryId__c+'-'+alloc.ProductId__c,remainingAlloc);
//                                              }
                                             
//                                          }
//                                       }
//         prdAllocEditCheck(seasonIds);
//         Map<String,String> oppParentTerrMap = new Map<String,String>();
//         for(OpportunityLineItem oli:[SELECT Opportunity.Territory2Id,Opportunity.Parent_Territories__c FROM OpportunityLineItem 
//                                      WHERE  Opportunity.Season_SFID__c IN:seasonIds AND Opportunity.RecordTypeId=: oppRecordTypeId 
//                                      AND Product2.Line_of_Business__c IN:lobList LIMIT 45000]){                                         
//                                          oppParentTerrMap.put(oli.Opportunity.Territory2Id,oli.Opportunity.Parent_Territories__c);
//                                      }        
//         System.debug('PD oppParentTerrMap++++++'+oppParentTerrMap);
//         for(AggregateResult agg:[SELECT Product2.Line_of_Business__c lob,Opportunity.Territory2Id TerritoryId,Opportunity.Territory2.ParentTerritory2Id parentTerrId,Product2Id,SUM(Forecast_Qty__c)isfSellIn, SUM(Sell_Out_Qty__c)isfSellOut,
//                                  SUM(Upsides_Above_Allocation_Sell_In__c)upsideSellIn, SUM(Upsides_Above_Allocation_Sell_Out__c)upsideSellOut,SUM(Planned_Sell_In_Qty__c)plannedSellIn,SUM(Planned_Sell_Out_Qty__c)plannedSellOut,
//                                  SUM(FSF_Sell_In_Qty__c)fsfSellIn,SUM(FSF_Sell_Out_Qty__c)fsfSellOut FROM OpportunityLineItem 
//                                  WHERE  Opportunity.Season_SFID__c IN:seasonIds AND Opportunity.RecordTypeId=: oppRecordTypeId 
//                                  AND Product2.Line_of_Business__c IN:lobList GROUP BY Opportunity.Territory2Id,Opportunity.Territory2.ParentTerritory2Id,Product2Id,Product2.Line_of_Business__c]){
//                                      netPrice = prdNetPriceMap.containsKey((String)agg.get('Product2Id'))?prdNetPriceMap.get((String)agg.get('Product2Id')):1;
//                                      String lineOfBusiness = (String)agg.get('lob');
//                                      String key = (String)agg.get('TerritoryId')+'-'+(String)agg.get('Product2Id');
//                                      Decimal forceastQty = (Decimal)agg.get('isfSellIn')!=null?(Decimal)agg.get('isfSellIn'):0;
//                                      Decimal sellOutQty = (Decimal)agg.get('isfSellOut')!=null?(Decimal)agg.get('isfSellOut'):0;
//                                      Decimal upsideAboveSellIn = (Decimal)agg.get('upsideSellIn')!=null?(Decimal)agg.get('upsideSellIn'):0;
//                                      Decimal upsideAboveSellOut = (Decimal)agg.get('upsideSellOut')!=null?(Decimal)agg.get('upsideSellOut'):0;
//                                      Decimal salesPlanSellIn = (Decimal)agg.get('plannedSellIn')!=null?(Decimal)agg.get('plannedSellIn'):0;
//                                      Decimal salesPlanSellOut = (Decimal)agg.get('plannedSellOut')!=null?(Decimal)agg.get('plannedSellOut'):0;
//                                      Decimal fsfSellIn = (Decimal)agg.get('fsfSellIn')!=null?(Decimal)agg.get('fsfSellIn'):0;
//                                      Decimal fsfSellOut = (Decimal)agg.get('fsfSellOut')!=null?(Decimal)agg.get('fsfSellOut'):0;
//                                      String parentTerrId = oppParentTerrMap.containsKey((String)agg.get('TerritoryId'))?oppParentTerrMap.get((String)agg.get('TerritoryId')):'';
//                                      String parentkey = '';
//                                      if(lineOfBusiness.toUpperCase()=='ROW CROPS'){
//                                          isfMap.put(key+'-SELLIN',forceastQty);
//                                          isfMap.put(key+'-SELLOUT',sellOutQty);
//                                          aboveAllocMap.put(key+'-SELLIN',upsideAboveSellIn);
//                                          aboveAllocMap.put(key+'-SELLOUT',upsideAboveSellOut);
//                                          salesPlanMap.put(key+'-SELLIN',salesPlanSellIn);
//                                          salesPlanMap.put(key+'-SELLOUT',salesPlanSellOut);
//                                          fsfMap.put(key+'-SELLIN',fsfSellIn);
//                                          fsfMap.put(key+'-SELLOUT',fsfSellOut);
//                                          Boolean loopEx = false;
//                                          System.debug('PD isfMap++++++'+isfMap);
//                                          System.debug('PD aboveAllocMap++++++'+aboveAllocMap);
//                                          do{
//                                              String parentTerrOppId = checkParentTerrIds(parentTerrId,oppTerrIDs);
//                                              System.debug('PD parentTerrOppId++++++'+parentTerrOppId);
//                                              if(parentTerrOppId!=null){                                                 
//                                                  parentkey = parentTerrOppId+'-'+(String)agg.get('Product2Id'); 
//                                                  System.debug('PD parentkey++++++'+parentkey);
//                                                  if(oppTerrIDs.indexOf(parentTerrOppId)!=-1){
//                                                      oppTerrIDs.remove(oppTerrIDs.indexOf(parentTerrOppId));
//                                                      System.debug('PD oppTerrIDs line number 783++++++');
//                                                  }
//                                                  if(!isfMap.containsKey(parentkey+'-SELLIN')){
//                                                      isfMap.put(parentkey+'-SELLIN',forceastQty);
//                                                      System.debug('PD IF isfMap SELLIN ++++++'+isfMap);
//                                                  }else{
//                                                      Decimal val = isfMap.get(parentkey+'-SELLIN');
//                                                      isfMap.put(parentkey+'-SELLIN',forceastQty+val);
//                                                      System.debug('PD ELSE isfMap SELLIN++++++'+isfMap);
//                                                  } 
//                                                  if(!isfMap.containsKey(parentkey+'-SELLOUT')){
//                                                      isfMap.put(parentkey+'-SELLOUT',sellOutQty);
//                                                  }else{
//                                                      Decimal val = isfMap.get(parentkey+'-SELLOUT');
//                                                      isfMap.put(parentkey+'-SELLOUT',sellOutQty+val);
//                                                  }
//                                                  //FSF
//                                                  if(!fsfMap.containsKey(parentkey+'-SELLIN')){
//                                                      fsfMap.put(parentkey+'-SELLIN',fsfSellIn);
//                                                  }else{
//                                                      Decimal val = fsfMap.get(parentkey+'-SELLIN');
//                                                      fsfMap.put(parentkey+'-SELLIN',fsfSellIn+val);
//                                                  } 
//                                                  if(!fsfMap.containsKey(parentkey+'-SELLOUT')){
//                                                      fsfMap.put(parentkey+'-SELLOUT',fsfSellOut);
//                                                  }else{
//                                                      Decimal val = fsfMap.get(parentkey+'-SELLOUT');
//                                                      fsfMap.put(parentkey+'-SELLOUT',fsfSellOut+val);
//                                                  }
                                                 
//                                                  //Sales Plan
//                                                  if(!salesPlanMap.containsKey(parentkey+'-SELLIN')){
//                                                      salesPlanMap.put(parentkey+'-SELLIN',salesPlanSellIn);
//                                                  }else{
//                                                      Decimal val = salesPlanMap.get(parentkey+'-SELLIN');
//                                                      salesPlanMap.put(parentkey+'-SELLIN',salesPlanSellIn+val);
//                                                  } 
//                                                  if(!salesPlanMap.containsKey(parentkey+'-SELLOUT')){
//                                                      salesPlanMap.put(parentkey+'-SELLOUT',salesPlanSellOut);
//                                                  }else{
//                                                      Decimal val = salesPlanMap.get(parentkey+'-SELLOUT');
//                                                      salesPlanMap.put(parentkey+'-SELLOUT',salesPlanSellOut+val);
//                                                  }
                                                 
//                                                   //Upside Allocation
//                                                  if(!aboveAllocMap.containsKey(parentkey+'-SELLIN')){
//                                                      aboveAllocMap.put(parentkey+'-SELLIN',upsideAboveSellIn);
//                                                       System.debug('PD IF aboveAllocMap SELLIN++++++'+aboveAllocMap);
//                                                  }else{
//                                                      Decimal val = aboveAllocMap.get(parentkey+'-SELLIN');
//                                                      aboveAllocMap.put(parentkey+'-SELLIN',upsideAboveSellIn+val);
//                                                       System.debug('PD ELSE aboveAllocMap SELLIN++++++'+aboveAllocMap);
//                                                  } 
//                                                  if(!aboveAllocMap.containsKey(parentkey+'-SELLOUT')){
//                                                      aboveAllocMap.put(parentkey+'-SELLOUT',upsideAboveSellOut);
//                                                  }else{
//                                                      Decimal val = aboveAllocMap.get(parentkey+'-SELLOUT');
//                                                      aboveAllocMap.put(parentkey+'-SELLOUT',upsideAboveSellOut+val);
//                                                  }
//                                              }else{
//                                                  loopEx = true;
//                                                  if(!isTerrClicked){
//                                                      oppTerrIDs = new List<String>(terrIds);
//                                                  }else{
//                                                      oppTerrIDs = new List<String>{terrIds.get(0)};
//                                                  }
                                                 
//                                              }
                                             
//                                          }while(!loopEx);
                                         
//                                      }else if(lineOfBusiness.toUpperCase()=='CROP PROTECTION'){
//                                          isfMap.put(key+'-SELLIN',forceastQty*netPrice);
//                                          isfMap.put(key+'-SELLOUT',sellOutQty*netPrice);
//                                          aboveAllocMap.put(key+'-SELLIN',upsideAboveSellIn*netPrice);
//                                          aboveAllocMap.put(key+'-SELLOUT',upsideAboveSellOut*netPrice);
//                                          salesPlanMap.put(key+'-SELLIN',salesPlanSellIn*netPrice);
//                                          salesPlanMap.put(key+'-SELLOUT',salesPlanSellOut*netPrice);
//                                          fsfMap.put(key+'-SELLIN',fsfSellIn*netPrice);
//                                          fsfMap.put(key+'-SELLOUT',fsfSellOut*netPrice);
//                                          Boolean isCPLoopExecute = false;
//                                          do{
//                                              String parentCPTerrOppId = checkParentTerrIds(parentTerrId,oppTerrCPIDs);
//                                              if(parentCPTerrOppId !=null){                                                 
//                                                  parentkey = parentCPTerrOppId+'-'+(String)agg.get('Product2Id');
//                                                 if(oppTerrCPIDs.indexOf(parentCPTerrOppId)!=-1){
//                                                      oppTerrCPIDs.remove(oppTerrCPIDs.indexOf(parentCPTerrOppId)); 
//                                                  }
//                                                  //ISF 
//                                                  if(!isfMap.containsKey(parentkey+'-SELLIN')){
//                                                      isfMap.put(parentkey+'-SELLIN',forceastQty*netPrice);
//                                                  }else{
//                                                      Decimal val = isfMap.get(parentkey+'-SELLIN');
//                                                      val+=forceastQty*netPrice;
//                                                      isfMap.put(parentkey+'-SELLIN',val);
//                                                  } 
//                                                  if(!isfMap.containsKey(parentkey+'-SELLOUT')){
//                                                      isfMap.put(parentkey+'-SELLOUT',sellOutQty*netPrice);
//                                                  }else{
//                                                      Decimal val = isfMap.get(parentkey+'-SELLOUT');
//                                                      val+=sellOutQty*netPrice;
//                                                      isfMap.put(parentkey+'-SELLOUT',val);
//                                                  } 
//                                                  //FSF
//                                                  if(!fsfMap.containsKey(parentkey+'-SELLIN')){
//                                                      fsfMap.put(parentkey+'-SELLIN',fsfSellIn*netPrice);
//                                                  }else{
//                                                      Decimal val = fsfMap.get(parentkey+'-SELLIN');
//                                                      val+=fsfSellIn*netPrice;
//                                                      fsfMap.put(parentkey+'-SELLIN',val);
//                                                  } 
//                                                  if(!fsfMap.containsKey(parentkey+'-SELLOUT')){
//                                                      fsfMap.put(parentkey+'-SELLOUT',fsfSellOut*netPrice);
//                                                  }else{
//                                                      Decimal val = fsfMap.get(parentkey+'-SELLOUT');
//                                                      val+=fsfSellOut*netPrice;
//                                                      fsfMap.put(parentkey+'-SELLOUT',val);
//                                                  } 
//                                                  //Sales Plan
//                                                  if(!salesPlanMap.containsKey(parentkey+'-SELLIN')){
//                                                      salesPlanMap.put(parentkey+'-SELLIN',salesPlanSellIn*netPrice);
//                                                  }else{
//                                                      Decimal val = salesPlanMap.get(parentkey+'-SELLIN');
//                                                      val+=salesPlanSellIn*netPrice;
//                                                      salesPlanMap.put(parentkey+'-SELLIN',val);
//                                                  } 
//                                                  if(!salesPlanMap.containsKey(parentkey+'-SELLOUT')){
//                                                      salesPlanMap.put(parentkey+'-SELLOUT',salesPlanSellOut*netPrice);
//                                                  }else{
//                                                      Decimal val = salesPlanMap.get(parentkey+'-SELLOUT');
//                                                      val+=salesPlanSellOut*netPrice;
//                                                      salesPlanMap.put(parentkey+'-SELLOUT',val);
//                                                  } 
                                                 
//                                                  //Upside Allocation
//                                                  if(!aboveAllocMap.containsKey(parentkey+'-SELLIN')){
//                                                      aboveAllocMap.put(parentkey+'-SELLIN',upsideAboveSellIn*netPrice);
//                                                  }else{
//                                                      Decimal val = aboveAllocMap.get(parentkey+'-SELLIN');
//                                                      val+=upsideAboveSellIn*netPrice;
//                                                      aboveAllocMap.put(parentkey+'-SELLIN',val);
//                                                  } 
//                                                  if(!aboveAllocMap.containsKey(parentkey+'-SELLOUT')){
//                                                      aboveAllocMap.put(parentkey+'-SELLOUT',upsideAboveSellOut*netPrice);
//                                                  }else{
//                                                      Decimal val = aboveAllocMap.get(parentkey+'-SELLOUT');
//                                                      val+=upsideAboveSellOut*netPrice;
//                                                      aboveAllocMap.put(parentkey+'-SELLOUT',val);
//                                                  } 
//                                              }else{
//                                                  isCPLoopExecute = true;
//                                                   if(!isTerrClicked){
//                                                       oppTerrCPIDs = new List<String>(terrIds);
//                                                   }else{
//                                                       oppTerrCPIDs = new List<String>{terrIds.get(0)};
//                                                   }
                                                 
//                                              }
                                             
//                                          }while(!isCPLoopExecute);
//                                      }
//                                  }
//         System.debug('territoryCdMap>'+territoryCdMap+'-childToParent-'+childToParent);
//         for(AggregateResult ag:[SELECT SUM(Open_Order_Qty_Local__c)openOrders,Product_SFID__c, Season_SFID__c, Territory_Cd__c,SalesIndicartor__c FROM Product_Sales__c
//                                 WHERE Product_SFID__c IN:productIds AND Season_SFID__c IN:seasonIds GROUP BY Product_SFID__c, Season_SFID__c, Territory_Cd__c,SalesIndicartor__c]){
//                                     String salesIndicator = (String)ag.get('SalesIndicartor__c');
//                                     String terrCode = (String)ag.get('Territory_Cd__c');
//                                     System.debug('terrCode--'+terrCode);
//                                     String terrId = territoryCdMap.containsKey(terrCode)?territoryCdMap.get(terrCode).subStringBefore('-'):'';
//                                     System.debug('terrId--'+terrId);
//                                     String prdId =(String)ag.get('Product_SFID__c');
//                                     Decimal openOrders = (Decimal)ag.get('openOrders') != null ? (Decimal)ag.get('openOrders'):0;
//                                     List<String> pTerrIds = childToParent.containsKey(terrId)?new List<String>(childToParent.get(terrId)):new List<String>();
//                                     System.debug('pTerrIds--'+pTerrIds);
//                                     Boolean execute = false;
//                                     String parentkey = '';
//                                     if(salesIndicator == 'D'){
//                                         prdSalesMap.put(terrId+'-'+prdId+'-SELLIN',openOrders);
//                                     }else if(salesIndicator == 'I'){
//                                         prdSalesMap.put(terrId+'-'+prdId+'-SELLOUT',openOrders);
//                                     }
//                                     do{
//                                         system.debug('pTerrIdspTerrIds=>'+pTerrIds+'prdSalesTerrIds='+prdSalesTerrIds);
//                                         String parentTerrPrdSalesId = checkParentTerrIdsForPrdSales(pTerrIds,prdSalesTerrIds); 
//                                         System.debug('parentTerrPrdSalesId--'+parentTerrPrdSalesId);
//                                         if(parentTerrPrdSalesId !=null){                                                 
//                                             parentkey = parentTerrPrdSalesId+'-'+prdId;
//                                             System.debug('parentkey--'+parentkey);
//                                             if(pTerrIds.indexOf(parentTerrPrdSalesId)!=-1){
//                                                 pTerrIds.remove(pTerrIds.indexOf(parentTerrPrdSalesId)); 
//                                             }
//                                             if(salesIndicator == 'D'){
//                                                 if(!prdSalesMap.containsKey(parentkey+'-SELLIN')){
//                                                     prdSalesMap.put(parentkey+'-SELLIN',openOrders);
//                                                 }else{
//                                                     Decimal val = 0;
//                                                     if(prdSalesMap.get(parentkey+'-SELLOUT') != null){
//                                                         val = prdSalesMap.get(parentkey+'-SELLIN');
//                                                         val+=openOrders;
//                                                     }
//                                                     prdSalesMap.put(parentkey+'-SELLIN',val);
//                                                 }
//                                             }else{
//                                                 if(!prdSalesMap.containsKey(parentkey+'-SELLOUT')){
//                                                     prdSalesMap.put(parentkey+'-SELLOUT',openOrders);
//                                                 }else{
//                                                     Decimal val = 0;
//                                                     if(prdSalesMap.get(parentkey+'-SELLOUT') != null){
//                                                         val = prdSalesMap.get(parentkey+'-SELLOUT');
//                                                         val+=openOrders;
//                                                     }
//                                                     prdSalesMap.put(parentkey+'-SELLOUT',val);
//                                                 }
//                                             }                                            
//                                         }else{
//                                              execute = true;
//                                             if(!isTerrClicked){
//                                                 prdSalesTerrIds = new List<String>(terrIds);
//                                             }else{
//                                                 prdSalesTerrIds = new List<String>{terrIds.get(0)};
//                                             }
                                             
//                                         }
//                                     }while(!execute);
                                     
//                                 }
        
//         List<AllocWrapper> allocWrapperLst = new List<AllocWrapper>();
//         for(String str:finalList){
//             String prdId = str.subStringAfter('-');
//             String terrId = str.subStringBefore('-');
//             AllocWrapper allocWrap = new AllocWrapper();
//             allocWrap.loggedInUserRole = currentTerrType;
//             allocWrap.prdId = prdId;
//             allocWrap.terrId = terrId;
//             allocWrap.parentTerId=parentTerrMap.containsKey(terrId)?parentTerrMap.get(terrId).ParentTerritory2Id+'-'+prdId:null;
//             allocWrap.terrName = terrNameWithId.containsKey(terrId)?terrNameWithId.get(terrId):'';
//             allocWrap.terrType = terrIdToTerrType.containsKey(terrId)?(sohTypeMap.containsKey(terrIdToTerrType.get(terrId))?sohTypeMap.get(terrIdToTerrType.get(terrId)):''):'';
//             allocWrap.countryCode = cntry;
//             allocWrap.isfSellInQty = isfMap.containsKey(str+'-SELLIN')?isfMap.get(str+'-SELLIN'):0;
//             allocWrap.isfSellOutQty = isfMap.containsKey(str+'-SELLOUT')?isfMap.get(str+'-SELLOUT'):0;
//             allocWrap.upsideAboveAllocSellIn = aboveAllocMap.containsKey(str+'-SELLIN')?aboveAllocMap.get(str+'-SELLIN'):0;
//             allocWrap.upsideAboveAllocSellOut = aboveAllocMap.containsKey(str+'-SELLOUT')?aboveAllocMap.get(str+'-SELLOUT'):0;
//             allocWrap.salesPlanSellIn = salesPlanMap.containsKey(str+'-SELLIN')?salesPlanMap.get(str+'-SELLIN'):0;
//             allocWrap.salesPlanSellOut = salesPlanMap.containsKey(str+'-SELLOUT')?salesPlanMap.get(str+'-SELLOUT'):0;
//             allocWrap.fsfSellIn = fsfMap.containsKey(str+'-SELLIN')?fsfMap.get(str+'-SELLIN'):0;
//             allocWrap.fsfSellOut = fsfMap.containsKey(str+'-SELLOUT')?fsfMap.get(str+'-SELLOUT'):0;
//             String prdGrp = allocMap.containsKey(str)?allocMap.get(str).ProductId__r.Family:'';                                
//             allocWrap.allocId = allocMap.containsKey(str)?allocMap.get(str).id:null;
//             allocWrap.ordersYTDSellIn = prdSalesMap.containsKey(str+'-SELLIN')?prdSalesMap.get(str+'-SELLIN'):0;
//             allocWrap.ordersYTDSellOut = prdSalesMap.containsKey(str+'-SELLOUT')?prdSalesMap.get(str+'-SELLOUT'):0;           
//             String prdGroup = prdGrpMap.containsKey(prdId)?(prdGrpMap.get(prdId)!=null?prdGrpMap.get(prdId):''):'';
//             allocWrap.colorIndicator = prdColorMap.containsKey(terrId+'-'+prdId)?prdColorMap.get(terrId+'-'+prdId):'';
//             Boolean isFreeze = false;
//             if(allocMap.containsKey(str)){
//                  isFreeze = fnc == 'ISF'?allocMap.get(str).Is_freezed__c:fnc == 'FSF'?allocMap.get(str).Is_freezed_FSF__c:fnc=='Sales Plan'?allocMap.get(str).Is_freezed_SP__c:false;
//             }           
//             if(currentTerrType == 'Account_Manager'){
//                 allocWrap.isEditable = false;
//             }else{
//                 if(isFreeze){
//                     allocWrap.isEditable = false;
//                 }else{                    
//                     if(prdAllocPrdGpVsEditMap!=null && prdAllocPrdGpVsEditMap.containsKey(prdGroup.toUpperCase())){
//                         if(prdAllocPrdGpVsEditMap.get(prdGroup.toUpperCase())){
//                             if(sohEditableLst.contains(SOH) && terrIdToTerrType.get(terrId) == SOH_Filter){//Is_freezed__c
//                                 allocWrap.isEditable = true;
//                             }else if(currentTerrType == 'Country' && terrIdToTerrType.get(terrId) == 'Country' && SOH == 'Country'){
//                                 allocWrap.isEditable = true;
//                             }else{
//                                 allocWrap.isEditable = false;
//                             }
//                         }else{
//                             allocWrap.isEditable = false;
//                         }
//                     } else{
//                         allocWrap.isEditable = false;
//                     }
//                 }
//             }            
//             if(fnc == 'ISF'){
//                 Decimal draftVal = allocMap.containsKey(str)?(allocMap.get(str).Allocated_Product_Draft__c!=null?allocMap.get(str).Allocated_Product_Draft__c:0):0;
//                 Decimal cascadedVal = allocMap.containsKey(str)?(allocMap.get(str).Allocated_Product_Cascaded__c!=null?allocMap.get(str).Allocated_Product_Cascaded__c:0):0;
//                 if(currentTerrType !='Country' && terrIdToTerrType.containsKey(terrId) && (terrIdToTerrType.get(terrId)==currentTerrType)){
//                     allocWrap.allocatedPrd = cascadedVal;
//                      allocWrap.allocatedPrdColor = 'Green';
//                 }else if(currentTerrType =='Country'){
//                      allocWrap.allocatedPrd = draftVal!=0?draftVal:cascadedVal;
//                     allocWrap.allocatedPrdColor = draftVal!=0?'Orange':'Green';
//                 }else{                    
//                     allocWrap.allocatedPrd = draftVal!=0?draftVal:cascadedVal;
//                     allocWrap.allocatedPrdColor = draftVal!=0?'Orange':'Green';
//                 }
//                allocWrap.previousPrdAlloc = allocMap.containsKey(str)?(allocMap.get(str).Previous_Allocation__c!=null?allocMap.get(str).Previous_Allocation__c:0):0;
//             }else if(fnc == 'FSF'){
//                 Decimal draftFSFVal = allocMap.containsKey(str)?(allocMap.get(str).Allocated_Product_Draft_FSF__c!=null?allocMap.get(str).Allocated_Product_Draft_FSF__c:0):0;
//                 Decimal cascadedFSFVal = allocMap.containsKey(str)?(allocMap.get(str).Allocated_Prd_Cascaded_FSF__c!=null?allocMap.get(str).Allocated_Prd_Cascaded_FSF__c:0):0;
//                 if(currentTerrType !='Country' && terrIdToTerrType.containsKey(terrId) && (terrIdToTerrType.get(terrId)==currentTerrType)){
//                     allocWrap.allocatedPrd = cascadedFSFVal;
//                     allocWrap.allocatedPrdColor = 'Green';
//                 }else if(currentTerrType =='Country'){
//                      allocWrap.allocatedPrd = draftFSFVal!=0?draftFSFVal:cascadedFSFVal;
//                      allocWrap.allocatedPrdColor = draftFSFVal!=0?'Orange':'Green';
//                 }else{
//                     allocWrap.allocatedPrd = draftFSFVal!=0?draftFSFVal:cascadedFSFVal;
//                     allocWrap.allocatedPrdColor = draftFSFVal!=0?'Orange':'Green';
//                 }
//                 allocWrap.previousPrdAlloc = allocMap.containsKey(str)?(allocMap.get(str).Previous_Allocation_FSF__c!=null?allocMap.get(str).Previous_Allocation_FSF__c:0):0;
//             }else if(fnc == 'Sales Plan'){
//                 Decimal draftSPVal = allocMap.containsKey(str)?(allocMap.get(str).Allocated_Product_Draft_SP__c!=null?allocMap.get(str).Allocated_Product_Draft_SP__c:0):0;
//                 Decimal cascadedSPVal = allocMap.containsKey(str)?(allocMap.get(str).Allocated_Prd_Cascaded_SP__c!=null?allocMap.get(str).Allocated_Prd_Cascaded_SP__c:0):0;
//                  if(currentTerrType !='Country' && terrIdToTerrType.containsKey(terrId) && (terrIdToTerrType.get(terrId)==currentTerrType)){
//                      allocWrap.allocatedPrd = cascadedSPVal;
//                      allocWrap.allocatedPrdColor = 'Green';
//                  }else if(currentTerrType =='Country'){
//                      allocWrap.allocatedPrd = draftSPVal!=0?draftSPVal:cascadedSPVal;
//                      allocWrap.allocatedPrdColor = draftSPVal!=0?'Orange':'Green';
//                 }else{
//                       allocWrap.allocatedPrd = draftSPVal!=0?draftSPVal:cascadedSPVal;
//                     allocWrap.allocatedPrdColor = draftSPVal!=0?'Orange':'Green';
//                  }
               
//                 allocWrap.previousPrdAlloc = allocMap.containsKey(str)?(allocMap.get(str).Previous_Allocation_SP__c!=null?allocMap.get(str).Previous_Allocation_SP__c:0):0;
//             }
//             if(terrIdToTerrType.containsKey(terrId) && terrIdToTerrType.get(terrId)=='Country'){
//                 allocWrap.unalloctedPrd = remAllocMap.containsKey(str)?(remAllocMap.get(str)!=null?(allocWrap.allocatedPrd-remAllocMap.get(str)):0):0;
//                 allocWrap.remainingAlloc = 0;
//             }else{
//                 allocWrap.unalloctedPrd = 0;
//                 allocWrap.remainingAlloc = remAllocMap.containsKey(str)?(remAllocMap.get(str)!=null?(allocWrap.allocatedPrd-remAllocMap.get(str)):0):0;
//             }
//             if((parentTerIdList.contains(terrId) && currentTerrType != 'Account_Manager')||(allocWrap.terrType=='Territory' && isTerrClicked)){
//                 allocWrap.isParentTerr= true;
//             }else{
//                 allocWrap.isParentTerr= false;
//             }
           
//             if(!prdAllocMap.containsKey(prdId+';'+(prdNameMap.containsKey(prdId)?prdNameMap.get(prdId):''))){
//                 allocWrap.isFirst= true;
//                 prdAllocMap.put(prdId+';'+(prdNameMap.containsKey(prdId)?prdNameMap.get(prdId):''),new List<AllocWrapper>{allocWrap});
//             }else{
//                 allocWrap.isFirst= false;
//                 allocWrapperLst = prdAllocMap.get(prdId+';'+(prdNameMap.containsKey(prdId)?prdNameMap.get(prdId):''));
//                 allocWrapperLst.add(allocWrap)                             ;
//                 prdAllocMap.put(prdId+';'+(prdNameMap.containsKey(prdId)?prdNameMap.get(prdId):''),allocWrapperLst);
//             }
            
//         }
//         mainWrap.allocWrapperMap = prdAllocMap;
//         System.debug('mainWrap>>'+mainWrap);
//         return mainWrap;
//     }  
    
//     /*
//     * Method Name : prdAllocEditCheck
//     * Description : Method to construct map which holds if the Product Allocation functionality for the product groups is open for the season or not
//     * Params      : List<String> seasonIds
//    */
//     private static void prdAllocEditCheck(List<String> seasonIds){
//         Boolean isSellOutEditable =false; 
//         System.debug('seasonIds--'+seasonIds);
//         for(Season__c season:[SELECT Id,Product_Group__c, PA_Process_Close_Date_Submitted__c,Line_of_Business__c, PA_Process_Open_Date_Submitted__c, PA_Process_Close_Date__c, 
//                               PA_Process_Open_Date__c, SellOut_PA_Prd_Granularity_Submitted__c FROM Season__c WHERE Id IN:seasonIds]){
//             if(season.Product_Group__c !=null){
//                 if(season.PA_Process_Open_Date_Submitted__c ==null || season.PA_Process_Open_Date_Submitted__c == null){
//                     isSellOutEditable=false;
//                 }
//                 if((season.PA_Process_Open_Date_Submitted__c <=system.today() && season.PA_Process_Close_Date_Submitted__c >=system.today())){
//                     if(season.SellOut_PA_Prd_Granularity_Submitted__c!=null){
//                         isSellOutEditable =true;
//                     }
//                     else{
//                         isSellOutEditable =false;
//                     }
//                     prdAllocPrdGpVsEditMap.put(season.Product_Group__c.toUppercase(), isSellOutEditable);                
//                 }
                
//             }
//         }
//         System.debug('prdAllocPrdGpVsEditMap>>'+prdAllocPrdGpVsEditMap);
//     }
//     /*
//     * Method Name : updateProductAllocation
//     * Description : Method which updates Prd_Allocation__c object during Save/Cascade action from Target Setting& Allocation-> Product Allocation tab.
//     * Params      : String jsonStr,String action,String fnc
//    */
//     @AuraEnabled
//     public static void updateProductAllocation(String jsonStr,String action,String fnc){
//         System.debug('jsonStr--'+jsonStr+'-action-'+action+'fnc--'+fnc);
//         //jsonStr - AllocaId|SellIn/SellOut
        
//         Map<String,List<AllocWrapper>> updateMap = new Map<String,List<AllocWrapper>>();
//         Set<Id> prdAllocIds = new Set<Id>();        
//         try{
//             Map<String,Object> prdAllocMap = (Map<String,Object>) JSON.deserializeUntyped(jsonStr);
//             System.debug('prdAllocMap>'+prdAllocMap);
//             for(String key: prdAllocMap.keySet()){
//                 AllocWrapper info = new AllocWrapper();
//                 info.allocId = key;
//                 prdAllocIds.add(key);
//                 info.allocatedPrd = prdAllocMap.containsKey(key)?Decimal.valueOf((String)prdAllocMap.get(key)):0;
//                 System.debug('info.allocatedPrd=='+info.allocatedPrd);
//                 if(!updateMap.containsKey(key)){
//                     updateMap.put(key,new List<AllocWrapper>{info}); 
//                 }else{
//                     List<AllocWrapper> lst = updateMap.get(key);
//                     lst.add(info);
//                     updateMap.put(key,lst); 
//                 }
//             }
//             System.debug('prdAllocIds--'+prdAllocIds);
//             List<Prd_Allocation__c> allocList = [SELECT Id, ProductId__c,ProductId__r.Product_Group__c, TerritoryId__c, Previous_Allocation__c,Allocated_Product_Draft__c, 
//                                                  Allocated_Product_Cascaded__c, Allocated_Product_Draft_FSF__c,Allocated_Product_Draft_SP__c,Allocated_Prd_Cascaded_SP__c,
//                                                  Allocated_Prd_Cascaded_FSF__c,Season__c,Previous_Allocation_FSF__c,Previous_Allocation_SP__c
//                                                  FROM Prd_Allocation__c WHERE Id IN:prdAllocIds];
//             System.debug('allocList>'+allocList);
//             List<Prd_Allocation__c> updateAllocLst = new List<Prd_Allocation__c>();
//             for(Prd_Allocation__c alloc : allocList){
//                 List<AllocWrapper> wrapLst = updateMap.containsKey(alloc.id)?updateMap.get(alloc.id):new List<AllocWrapper>();
//                     if(wrapLst!=null){
//                         for(AllocWrapper wrap:wrapLst){
//                             if(action == 'Save'){
//                                 if(fnc=='ISF'){
//                                         alloc.Allocated_Product_Draft__c=wrap.allocatedPrd;
//                                     }else if(fnc=='FSF'){
//                                         alloc.Allocated_Product_Draft_FSF__c=wrap.allocatedPrd;
//                                     }else if(fnc=='Sales Plan'){
//                                         alloc.Allocated_Product_Draft_SP__c=wrap.allocatedPrd;
//                                     }                               
//                             }else if(action == 'Cascade'){
//                                 if(wrap.allocatedPrd!=0){
//                                     System.debug('alloc.Allocated_Product_Cascaded__c=='+alloc.Allocated_Product_Cascaded__c+'alloc.Allocated_Prd_Cascaded_FSF__c==>'+alloc.Allocated_Prd_Cascaded_FSF__c+'alloc.Allocated_Prd_Cascaded_SP__c=='+alloc.Allocated_Prd_Cascaded_SP__c);
//                                     if(alloc.Allocated_Product_Cascaded__c!=0 && fnc=='ISF'){
//                                         alloc.Previous_Allocation__c = alloc.Allocated_Product_Cascaded__c;
                                        
//                                     }else if(alloc.Allocated_Prd_Cascaded_FSF__c!=0 && fnc=='FSF'){
//                                         alloc.Previous_Allocation_FSF__c = alloc.Allocated_Prd_Cascaded_FSF__c;
                                        
//                                     }else if(alloc.Allocated_Prd_Cascaded_SP__c!=0 && fnc=='Sales Plan'){
//                                         alloc.Previous_Allocation_SP__c = alloc.Allocated_Prd_Cascaded_SP__c;
                                        
//                                     }
//                                 }

//                                  if(fnc=='ISF'){
//                                         alloc.Allocated_Product_Cascaded__c=wrap.allocatedPrd;
//                                         if(alloc.Allocated_Product_Cascaded__c!=0){
//                                             alloc.Allocated_Product_Draft__c = 0;
//                                         }
//                                     }else if(fnc=='FSF'){
//                                         alloc.Allocated_Prd_Cascaded_FSF__c = wrap.allocatedPrd;
//                                         if(alloc.Allocated_Prd_Cascaded_FSF__c!=0){
//                                             alloc.Allocated_Product_Draft_FSF__c = 0;
//                                         }
//                                     }else if(fnc=='Sales Plan'){
//                                         alloc.Allocated_Prd_Cascaded_SP__c = wrap.allocatedPrd;
//                                         if(alloc.Allocated_Prd_Cascaded_SP__c!=0){
//                                             alloc.Allocated_Product_Draft_SP__c = 0;
//                                         }
//                                     }


//                             }
//                         }
//                         updateAllocLst.add(alloc);
//                     }                
//                 }
//                 if(!updateAllocLst.isEmpty()){
//                     System.debug('updateAllocLst>>'+updateAllocLst);
//                     update updateAllocLst;
//                 }
//             }catch(Exception e){
//                 System.debug('Exception while saving the records in updateProductAllocation:'+e.getMessage()+'in Line No:'+e.getLineNumber());
//             }
//         }
    
//     public class SOHWrapper{
//         @AuraEnabled public List<String> terrTypes;
//         @AuraEnabled public String currentTerrType;
//     }
    
//     public class ProductAllocationWrapper{
//         @AuraEnabled public Map<String,List<AllocWrapper>> allocWrapperMap{get;set;}
//     }
    
//      public class ProductTerrWrapper{
//         @AuraEnabled public Map<String,String> prdMap{get;set;}
//          @AuraEnabled public Set<String> terrIds{get;set;}
//          @AuraEnabled public Set<String> parentTerrIds{get;set;}
//          @AuraEnabled public Set<String> seasonIds{get;set;}
//          @AuraEnabled public List<String> sohEditable{get;set;}
//          @AuraEnabled public String currentTerrType;
//     }
    
//     public class ProductWrapper{
//         @AuraEnabled public Id prdId{get;set;}  
//         @AuraEnabled public String prdName{get;set;}
//         @AuraEnabled public String prdGrp{get;set;}
//         @AuraEnabled public String prdLOB{get;set;}
//         @AuraEnabled public String prdColorIndicator{get;set;}
        
//         @AuraEnabled public Products_Services_Portfolio_To_Product__c psptp{get;set;}
//     }    
//     public class AllocWrapper{
//         @AuraEnabled public String loggedInUserRole{get;set;}        
//         @AuraEnabled public Decimal allocatedPrd{get;set;}
//         @AuraEnabled public Decimal previousPrdAlloc{get;set;}
//         @AuraEnabled public Decimal remainingAlloc{get;set;}
//         @AuraEnabled public Decimal unalloctedPrd{get;set;}
//         @AuraEnabled public Decimal isfSellInQty{get;set;}
//         @AuraEnabled public Decimal isfSellOutQty{get;set;}
//         @AuraEnabled public Decimal salesPlanSellIn{get;set;}
//         @AuraEnabled public Decimal salesPlanSellOut{get;set;}        
//         @AuraEnabled public Decimal fsfSellIn{get;set;}
//         @AuraEnabled public Decimal fsfSellOut{get;set;}
//         @AuraEnabled public Decimal ordersYTDSellIn{get;set;}
//         @AuraEnabled public Decimal ordersYTDSellOut{get;set;}
//         @AuraEnabled public Decimal upsideAboveAllocSellIn{get;set;}
//         @AuraEnabled public Decimal upsideAboveAllocSellOut{get;set;}   
//         @AuraEnabled public String colorIndicator{get;set;}
//         @AuraEnabled public String allocatedPrdColor{get;set;}
//         @AuraEnabled public Id terrId{get;set;}
//         @AuraEnabled public Id prdId{get;set;}
//         @AuraEnabled public Id allocId{get;set;}
//         @AuraEnabled public Id seasonId{get;set;}
//         @AuraEnabled public String terrName{get;set;}
//         @AuraEnabled public String terrType{get;set;}
//         @AuraEnabled public String countryCode{get;set;}
//         @AuraEnabled public Boolean isEditable{get;set;}
//         @AuraEnabled public Boolean isFirst{get;set;}
//         @AuraEnabled public Boolean isParentTerr{get;set;}
//         @AuraEnabled public String parentTerId {get;set;}
//     }
    
//      /*
//     * Method Name : checkParentTerrIds
//     * Description : Method which returns parent terrid for the OLI territory id.
//     * Params      : String parentTerrIds,List<String> terrIds
//    */
//     private static String checkParentTerrIds(String parentTerrIds,List<String> terrIds){
//         List<String> parentTerrIdsOfOpp = new List<String>(parentTerrIds.split(','));
//         String parentTerr = null;
//         for(String terr:terrIds){
//             if(parentTerrIdsOfOpp.contains(terr)){
//                 parentTerr = terr;
//             }
//         }
//         return parentTerr;
//     }
    
//     private static String checkParentTerrIdsForPrdSales(List<String> parentTerrIds,List<String> terrIds){
//        // List<String> parentTerrIdsOfOpp = new List<String>(parentTerrIds.split(','));
//         String parentTerr = null;
//         for(String terr:terrIds){
//             if(parentTerrIds.contains(terr)){
//                 parentTerr = terr;
//             }
//         }
//         return parentTerr;
//     }
// }

}