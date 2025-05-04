trigger accountTrigger on Account (after insert) {
    Set<Id> accId = new Set<Id>();
    for(Account ac : trigger.New){
        accId.add(ac.Id);
    }

    List<Contact> conList = new List<Contact>();

    for(Id acId : accId){
    contact con = new contact();
    con.LastName = 'TestCon';
    con.AccountId = acId;
    conList.add(con);
    }

    insert conList;
    
}