public without sharing class ExceptionLogUtility {
    
    private static final String NO_RESPONSE = 'No response from the API';

    public static Exception_Log__c constructException(String businessFunctionName, String errorCode, Exception ex) {
        Exception_Log__c excpLog = new Exception_Log__c();
        excpLog.Business_Function_Name__c = businessFunctionName;
        excpLog.Error_Code__c = errorCode;
        excpLog.Error_Message__c = ex.getMessage();
        excpLog.Is_Admin_Notified__c = false;
        excpLog.Is_Case_Created__c = false;
        excpLog.Is_Integration_Exception__c = false;
        excpLog.Logged_in_User__c = UserInfo.getName();
        excpLog.Stack_Trace__c = ex.getStackTraceString();
        excpLog.Timestamp__c = System.now();

        return excpLog;
    }

    public static void commitExceptions(List<Exception_Log__c> exceptions) {
        if(exceptions!=null && exceptions.size()>0)
            upsert exceptions;
    }

    public static Exception_Log__c noResponseException(String businessFunction, String errorCode) {
        return constructException(businessFunction, errorCode, null);
    }
}
