public with sharing class ContactTriggerHelper {
    
    // Existing logic: Rollup summary of contacts
    public static void rollupContactsOnAccount(List<Contact> newList, List<Contact> oldList) {
        Set<Id> accountIdSet = new Set<Id>();
        List<Account> accountsToUpdateList = new List<Account>(); 
        
        if(newList != null){
            for(Contact con : newList){
                if(con.AccountId != null){
                    accountIdSet.add(con.AccountId);
                }
            }
        }
        if(oldList != null){
            for(Contact con : oldList){
                if(con.AccountId != null){
                    accountIdSet.add(con.AccountId);
                }
            }
        }
        
        if(accountIdSet.size() > 0){
            for(AggregateResult result : [SELECT Count(Id)noOfContacts, AccountId FROM Contact WHERE AccountId IN :accountIdSet GROUP BY AccountId]){
                Account acc = new Account();
                acc.Id = (String)result.get('AccountId');
                acc.contactSize__c = Integer.valueOf(result.get('noOfContacts'));
                accountsToUpdateList.add(acc);
            }
        }
        
        if(accountsToUpdateList.size() > 0){
            update accountsToUpdateList;
        }
    }

    // Existing logic: Mark Duplicate__c = true (preserved original functionality)
    public static void markDuplicateContacts(List<Contact> newList) {
        Set<String> emailSet = new Set<String>();
        Set<String> lastNameSet = new Set<String>();
        for(Contact con : newList){
            if(con.Email != null){
                emailSet.add(con.Email);
            }
            if(con.lastName != null){
                lastNameSet.add(con.lastName);
            }
        }
        
        if(emailSet.size() > 0 || lastNameSet.size() > 0){
            List<Contact> contactList = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Email IN :emailSet AND LastName IN :lastNameSet];
            for(Contact con : newList){
                if(contactList.size() > 0){
                    con.Duplicate__c = true;
                }
            }
        }
    }

    // New logic: Stop duplicate contact creation by email
    public static void preventDuplicateEmails(List<Contact> newList, Map<Id, Contact> oldMap) {
        Set<String> emailSet = new Set<String>();
        
        for(Contact con : newList){
            if(con.Email != null && (oldMap == null || con.Email != oldMap.get(con.Id).Email)){
                emailSet.add(con.Email);
            }
        }
        
        if(!emailSet.isEmpty()){
            List<Contact> existingContacts = [SELECT Id, Email FROM Contact WHERE Email IN :emailSet];
            Set<String> existingEmails = new Set<String>();
            
            for(Contact c : existingContacts){
                if(c.Email != null){
                    existingEmails.add(c.Email.toLowerCase());
                }
            }
            
            for(Contact con : newList){
                if(con.Email != null && existingEmails.contains(con.Email.toLowerCase())){
                    con.addError('A Contact with this email address already exists. Duplicate creation is stopped.');
                }
            }
        }
    }
}
