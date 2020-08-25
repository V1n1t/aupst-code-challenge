/**
 * @Author             : Vineeth Batreddy
 * @Description        : This class holds all utility methods for mock configuration
**/
public without sharing class MockUtility {

    public static Map<String, String> getMock(String name) {

        Map<String,String> filters = new Map<String, String>();
        filters.put('MasterLabel', name);
        Mock_Configuration__mdt mock = (Mock_Configuration__mdt) QueryUtils.getRecord('Mock_Configuration__mdt', filters, null);
        System.debug('!@#$% mock : ' + mock);

        Map<String,String> mockConfig = new Map<String, String>();
        if(mock != null) {
            mockConfig.put('name', mock.MasterLabel);
            mockConfig.put('url', mock.Mock_Url__c);
            mockConfig.put('isEnabled', String.valueOf(mock.Enable__c));	
        }

        return mockConfig;
    }

    public static Boolean isEnabled(String name) {
        Map<String, String> mockConfig = getMock(name);
        if(mockConfig.size()>0 && mockConfig.get('isEnabled').equalsIgnoreCase('true'))
            return true;
        else
            return false;
    }

    public static String getMockEndpoint(String name) {
        Map<String, String> mockConfig = getMock(name);
        if(mockConfig.size()>0 && mockConfig.get('isEnabled').equalsIgnoreCase('true'))
            return mockConfig.get('url');
        else
            return '';
    }
}