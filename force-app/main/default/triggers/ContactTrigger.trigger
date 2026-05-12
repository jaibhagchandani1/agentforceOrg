trigger ContactTrigger on Contact (before insert, before update, after insert, after update, after delete, after undelete) {
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            ContactTriggerHandler.beforeInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            ContactTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            ContactTriggerHandler.afterInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            ContactTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
        if (Trigger.isDelete) {
            ContactTriggerHandler.afterDelete(Trigger.old);
        }
        if (Trigger.isUndelete) {
            ContactTriggerHandler.afterUndelete(Trigger.new);
        }
    }
}