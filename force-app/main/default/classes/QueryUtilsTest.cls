@isTest
private class QueryUtilsTest{
	
	@testSetup 
    static void createTestData() {

    	Account a = new Account();
    	a.Name = 'Test Account';
    	insert a;

    	Contact c1 = new Contact();
    	c1.FirstName = 'First1';
    	c1.LastName = 'Last1';
    	c1.AccountId = a.Id;
    	insert c1;

        Contact c2 = new Contact();
        c2.FirstName = 'First2';
        c2.LastName = 'Last2';
        c2.AccountId = a.Id;
        insert c2;

    }

    static TestMethod void getRecords_simpleFilter() {
    	Map<String, String> filters = new Map<String, String>();
    	filters.put('FirstName', 'First1');
    	filters.put('LastName', 'Last1');
    	List<Contact> contacts = QueryUtils.getRecords('Contact', filters, 'Account.Name', 'ORDER BY FirstName ASC');
    	System.assert(true, contacts.get(0).Account.Name.equalsIgnoreCase('Test Account'));
    }

    static TestMethod void getRecords_complexFilter() {        
        List<QueryUtils.Filter> filters = new List<QueryUtils.Filter>();
        // filter 1
        QueryUtils.Filter filter1 = new QueryUtils.Filter();
        filter1.name = 'FirstName';
        filter1.operator = 'IN';
        filter1.value = new List<String>{'First1','Last2'};
        filters.add(filter1);
        // filter 2
        QueryUtils.Filter filter2 = new QueryUtils.Filter();
        filter2.name = 'Account.Name';
        filter2.operator = 'IN';
        filter2.value = new List<String>{'Test Account'};
        filters.add(filter2);

        List<Contact> contacts = QueryUtils.getRecords('Contact', filters, 'Account.Name', 'ORDER BY FirstName ASC');
        System.debug('!@#$% contacts size() : ' + contacts.size());
        System.assertEquals(true, contacts.size()==1);
        System.assertNotEquals('Last2', contacts.get(0).LastName);
        System.assert(true, contacts.get(0).Account.Name.equalsIgnoreCase('Test Account'));
    }

    static TestMethod void getRecord() {
        Map<String, String> filters = new Map<String, String>();
        filters.put('FirstName', 'First1');
        filters.put('LastName', 'Last1');
        Contact contact = (Contact) QueryUtils.getRecord('Contact', filters, 'Account.Name');
        System.assert(true, contact.Account.Name.equalsIgnoreCase('Test Account'));
    }
    
    static TestMethod void getRecordForUpdate_simpleFilter() {
        Map<String, String> filters = new Map<String, String>();
        filters.put('FirstName', 'First1');
        filters.put('LastName', 'Last1');
        Contact contact = (Contact) QueryUtils.getRecordForUpdate('Contact', filters, 'Account.Name');
        System.assert(true, contact.Account.Name.equalsIgnoreCase('Test Account'));
    }
    
    static TestMethod void getRecordForUpdate_simpleFilter_negative() {
        Map<String, String> filters = new Map<String, String>();
        filters.put('FirstName', 'First11');
        filters.put('LastName', 'Last11');
        Contact contact = (Contact) QueryUtils.getRecordForUpdate('Contact', filters, 'Account.Name');
        System.assert(true, contact == null);
    }
    
    static TestMethod void getRecordsForUpdate_complexFilter() {        
        List<QueryUtils.Filter> filters = new List<QueryUtils.Filter>();
        // filter 1
        QueryUtils.Filter filter1 = new QueryUtils.Filter();
        filter1.name = 'FirstName';
        filter1.operator = 'IN';
        filter1.value = new List<String>{'First1','Last2'};
        filters.add(filter1);
        // filter 2
        QueryUtils.Filter filter2 = new QueryUtils.Filter();
        filter2.name = 'Account.Name';
        filter2.operator = 'IN';
        filter2.value = new List<String>{'Test Account'};
        filters.add(filter2);

        List<Contact> contacts = QueryUtils.getRecordsForUpdate('Contact', filters, 'Account.Name');
        System.debug('!@#$% contacts size() : ' + contacts.size());
        System.assertEquals(true, contacts.size()==1);
        System.assertNotEquals('Last2', contacts.get(0).LastName);
        System.assert(true, contacts.get(0).Account.Name.equalsIgnoreCase('Test Account'));
    }

    static TestMethod void getRecord_negative() {
        Map<String, String> filters = new Map<String, String>();
        filters.put('FirstName', 'Last1');
        filters.put('LastName', 'First1');
        Contact contact = (Contact) QueryUtils.getRecord('Contact', filters, 'Account.Name');
        System.assert(true, contact == null);
    }

    static TestMethod void getCommaSeperatedFields() {
        System.assert(true, String.isNotBlank(QueryUtils.getCommaSeperatedFields('Account')));
        System.assert(true, QueryUtils.getCommaSeperatedFields('Account').contains(','));
    }
}