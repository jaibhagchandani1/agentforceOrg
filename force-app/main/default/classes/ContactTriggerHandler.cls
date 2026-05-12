public with sharing class ContactTriggerHandler {
    
    public static void beforeInsert(List<Contact> newList) {
        ContactTriggerHelper.markDuplicateContacts(newList);
        ContactTriggerHelper.preventDuplicateEmails(newList, null);
    }
    
    public static void beforeUpdate(List<Contact> newList, Map<Id, Contact> oldMap) {
        ContactTriggerHelper.markDuplicateContacts(newList);
        ContactTriggerHelper.preventDuplicateEmails(newList, oldMap);
    }
    
    public static void afterInsert(List<Contact> newList) {
        ContactTriggerHelper.rollupContactsOnAccount(newList, null);
    }
    
    public static void afterUpdate(List<Contact> newList, Map<Id, Contact> oldMap) {
        ContactTriggerHelper.rollupContactsOnAccount(newList, oldMap.values());
    }
    
    public static void afterDelete(List<Contact> oldList) {
        ContactTriggerHelper.rollupContactsOnAccount(null, oldList);
    }
    
    public static void afterUndelete(List<Contact> newList) {
        ContactTriggerHelper.rollupContactsOnAccount(newList, null);
    }
}
