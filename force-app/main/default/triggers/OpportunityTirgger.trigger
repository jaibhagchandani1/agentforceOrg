trigger OpportunityTirgger on Opportunity (before insert,before update,before delete) {
	
    if(Trigger.isBefore){
        If(Trigger.isdelete){
            for(Opportunity opp : Trigger.old){
                if(opp.StageName =='Negotiation/Review'){
                    opp.addError('Cannotdelete the opp ');
                }
            }
        }
    }
}