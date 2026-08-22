@IsTest
private with sharing class TestAccountDeletion {
  @IsTest
  static void TestDeleteAccountWithOneOpportunity() {
    // Test data setup
    // Create one account with one opportunity by calling a utility method
    Account[] accts = TestDataFactory.createAccountsWithOpps(1,1);
    // Perform test
    Test.startTest();
      Database.DeleteResult result = Database.delete(accts[0], false, AccessLevel.USER_MODE);
    Test.stopTest();
    // Verify that the deletion should have been stopped by the trigger,
    // so check that we got back an error.
    Assert.isFalse(result.isSuccess());
    Assert.isTrue(result.getErrors().size() > 0);
    Assert.areEqual('Cannot delete account with related opportunities.',
      result.getErrors()[0].getMessage());
  }
  @IsTest
  static void TestDeleteAccountWithNoOpportunities() {
    // Test data setup
    // Create one account with no opportunities by calling a utility method
    List<Account> accts = TestDataFactory.createAccountsWithOpps(1, 0);
    
    Test.startTest();
        // 2. Pasar la lista o el registro directamente asegurando el Modo Usuario
        Database.DeleteResult result = Database.delete(accts[0], false, AccessLevel.USER_MODE);
    Test.stopTest();
    
    // Bloque de diagnóstico por si acaso vuelve a fallar (mantenlo temporalmente)
    if (!result.isSuccess()) {
        for(Database.Error err : result.getErrors()) {
            System.debug('ERROR CRÍTICO ACTUAL: ' + err.getMessage());
        }
    }
    
    // 3. Verificar el éxito de la eliminación
    Assert.isTrue(result.isSuccess(), 'La cuenta no pudo ser eliminada de forma exitosa.');

  }
  @IsTest
  static void TestDeleteBulkAccountsWithOneOpportunity() {
    // Test data setup
    // Create accounts with one opportunity each by calling a utility method
    Account[] accts = TestDataFactory.createAccountsWithOpps(200,1);
    // Perform test
    Test.startTest();
      Database.DeleteResult[] results = Database.delete(accts, false, AccessLevel.USER_MODE);
    Test.stopTest();
    // Verify for each record.
    // In this case the deletion should have been stopped by the trigger,
    // so check that we got back an error.
    for(Database.DeleteResult dr : results) {
      Assert.isFalse(dr.isSuccess());
      Assert.isTrue(dr.getErrors().size() > 0);
      Assert.areEqual('Cannot delete account with related opportunities.',
        dr.getErrors()[0].getMessage());
    }
  }
  @IsTest
  static void TestDeleteBulkAccountsWithNoOpportunities() {
    // Test data setup
    // Create accounts with no opportunities by calling a utility method
    Account[] accts = TestDataFactory.createAccountsWithOpps(200,0);
    // Perform test
    Test.startTest();
      Database.DeleteResult[] results = Database.delete(accts, false, AccessLevel.USER_MODE);
    Test.stopTest();
    // For each record, verify that the deletion was successful
    for(Database.DeleteResult dr : results) {
      Assert.isTrue(dr.isSuccess());
    }
  }
}