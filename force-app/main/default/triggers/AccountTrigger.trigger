trigger AccountTrigger on Account (AFTER INSERT, AFTER UPDATE,Before Delete)
{
    set<Id> accountIdUpdatedOwnership = new set<Id>();
    If(Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)){
        for(Account acc : Trigger.new){
            if(acc.Ownership != Trigger.oldMap.get(acc.Id).Ownership && acc.Ownership == 'Private'){
                accountIdUpdatedOwnership.add(acc.Id);
            }
        }
    }
    
    if(accountIdUpdatedOwnership.size()>0){
        List<Contact> contactList = [Select id,leadsource,accountid from contact where AccountId IN:accountIdUpdatedOwnership];
        for(Contact con : contactList){
            con.leadsource = 'Partner Referral';
        }
        Update contactList;
    }
    //Prevent deletion of account if contact is there
    If(trigger.isDelete && trigger.isbefore){
        
        Map<Id,Integer> mapOfIDANDInteger = new  Map<Id,Integer>();
        for(AggregateResult result : [Select Count(ID),accountId from contact where AccountID IN:trigger.oldMap.keySet() GROUP By AccountId]){
                mapOfIDANDInteger.put((Id)result.get('accountId'),(Integer)result.get('expr0'));
        }
        
        for (Account acc : Trigger.old) {
            if(mapOfIDANDInteger.containsKey(acc.Id) && mapOfIDANDInteger.get(acc.Id) > 0){
                acc.Adderror('cannot delete the account which has more than one contact');
            }
        }        
    }
}