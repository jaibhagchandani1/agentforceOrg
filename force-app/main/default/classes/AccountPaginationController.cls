public with sharing class AccountPaginationController {
    @AuraEnabled(cacheable=true)
    public static AccountPageWrapper getAccounts(Integer pageSize, Integer pageNumber) {
        Integer offsetValue = (pageNumber - 1) * pageSize;
        
        List<Account> accountList = [
            SELECT Id, Name, Industry, Phone, Website
            FROM Account
            ORDER BY Name ASC
            LIMIT :pageSize
            OFFSET :offsetValue
        ];
        
        Integer totalRecords = [SELECT COUNT() FROM Account];
        
        AccountPageWrapper wrapper = new AccountPageWrapper();
        wrapper.records = accountList;
        wrapper.totalRecords = totalRecords;
        return wrapper;
    }

    public class AccountPageWrapper {
        @AuraEnabled public List<Account> records;
        @AuraEnabled public Integer totalRecords;
    }
}
