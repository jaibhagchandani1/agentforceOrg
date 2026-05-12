//write a trigger to update the count of opplineitem on account whenever the new opp line item is added in the opportunity of that account
trigger OppLineItemTrigger on OpportunityLineItem (after insert,after update,after delete) {
    Set<Id> accId = new Set<Id>();
    Set<Id> oppId = new Set<Id>();
    List<Account> accToUpdate = new List<Account>();
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        for(OpportunityLineItem oli : trigger.new){
        	oppId.add(oli.OpportunityId);
    	}
    }
    if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isDelete)){
        for(OpportunityLineItem oli : trigger.old){
        	oppId.add(oli.OpportunityId);
    	}
    }
    
    for(Opportunity opp : [Select Id,AccountId From Opportunity Where ID IN:oppId]){
        accId.add(opp.AccountId);
    }
    
    for(AggregateResult result : [Select count(id)countOfOLI,Opportunity.AccountId accountsId 
                            from OpportunityLineItem Where Opportunity.AccountId IN:accId Group By Opportunity.AccountId]){
    		Account acc = new Account();
            acc.id = (String)result.get('accountsId');
            acc.OppLineItemCount__c = (Integer)result.get('countOfOLI');
           	accToUpdate.add(acc);
    }
    
    if(accToUpdate.size()>0){
        UPDATE accToUpdate;
    }
    

}