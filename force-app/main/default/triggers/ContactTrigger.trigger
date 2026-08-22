trigger ContactTrigger on Contact (before insert, before update) {

    ContactTriggerHandler handler = new ContactTriggerHandler();

    handler.copyAccOwn(Trigger.new);
    System.debug('copyAccOwn');
}