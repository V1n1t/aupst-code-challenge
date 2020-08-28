public without sharing class WorkforceManagementHelper {
    
    public static List<Case> getReadyToSendCases() {
        return Database.query(getReadyToSendCasesQuery());
    }

    public static String getReadyToSendCasesQuery() {
        return 'SELECT '+ QueryUtils.getCommaSeperatedFields('Case') + ' FROM Case WHERE Status = \''+ GlobalConstants.CASE_STATUS_CLOSED +'\' AND Is_WorkForcePlanner_notified__c = FALSE';
    }
}
