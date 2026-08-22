public with sharing class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer numContacts, String lastName) {

        List<Contact> contacts = new List<Contact>();
        
        for (Integer i = 0; i < numContacts; i++) {
            // Crea el contacto asignando el nombre único y el apellido común
            Contact c = new Contact(
                FirstName = 'Test ' + i,
                LastName = lastName
            );
            // Añade el contacto a la lista sin insertarlo en la base de datos
            contacts.add(c);
        }
        
        return contacts;
    }
}
