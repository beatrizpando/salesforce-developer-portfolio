trigger ContactNotificationTrigger on Contact (after insert, after delete) {
    if (Trigger.isInsert) {
        Integer recordCount = Trigger.new.size();
        // Set the recipientIDs to the current user
        Set<String> recipientIDs = new Set<String>{UserInfo.getUserId()};
        // Call a utility method from another class
        CustomContactNotification.notifyUsers(recipientIDs, recordCount);
    }
    else if (Trigger.isDelete) {
        // Process after delete
    }
}