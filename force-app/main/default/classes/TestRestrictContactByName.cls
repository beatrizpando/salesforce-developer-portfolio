@isTest
private with sharing class TestRestrictContactByName {
    @isTest
    static void TestRestrictContactWithInvalidName() {
        Contact conInvalid = new Contact(
            FirstName = 'Contact Test 3',
            LastName = 'INVALIDNAME'
        );
        
        Test.startTest();
        Database.SaveResult resultInsertado = Database.insert(conInvalid, false, AccessLevel.USER_MODE);
        Test.stopTest();
        // Verify
        // In this case the deletion should have been stopped by the trigger,
        // so verify that we got back an error.
        Assert.isFalse(resultInsertado.isSuccess());
        Assert.isTrue(resultInsertado.getErrors().size() > 0);
        Assert.areEqual('The Last Name "'+conInvalid.LastName+'" is not allowed for DML',
        resultInsertado.getErrors()[0].getMessage());
    }

    
}