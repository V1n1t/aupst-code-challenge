public without sharing class IntegrationLogUtility {

    public static Integration_Log__c constructIntegrationLog(String serviceName, String sObjectId, String type, String payload, Boolean isException, Id exceptionLogRecord) {
        Integration_Log__c integrationLog = new Integration_Log__c();
        integrationLog.Service_Name__c = serviceName;
        integrationLog.sObjectId__c = sObjectId;
        integrationLog.Timestamp__c = System.now();
        integrationLog.Type__c = type;
        integrationLog.Request_Response__c = payload;
        if(isException!=null)
            integrationLog.Is_Exception__c = isException;
        if(exceptionLogRecord!=null)
            integrationLog.Exception_Details__c = exceptionLogRecord;

        return integrationLog;
    }

    public static void commitIntegrationLogs(List<Integration_Log__c> integrationLogs) {
        if(integrationLogs!=null && integrationLogs.size()>0)
            upsert integrationLogs;
    }

    public static List<Integration_Log__c> addException(List<Integration_Log__c> integrationLogs, Exception_Log__c exceptionLog) {
        if(integrationLogs.size()>0 && exceptionLog!=null) {
            for(Integration_Log__c integrationLog : integrationLogs) {
                integrationLog.Exception_Details__c = exceptionLog.Id;
                integrationLog.Is_Exception__c = true;
            }
        }

        return integrationLogs;
    }
}
