@isTest
private class WorkforceManagementBatchTest {
    @TestSetup
    static void createData(){
        insert TestDataFactory.createCases(100);
    }

    @isTest static void positiveTest() {

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('WFMMockResponseSuccess');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        List<Case> cases  = new List<Case>();
        for (Case c : [SELECT status FROM Case]) {
            c.Status = 'Closed';
            c.Is_WorkForcePlanner_notified__c = false;
            cases.add(c);
        }
        Update cases;

        Test.startTest();
        WorkforceManagementBatch batch = new WorkforceManagementBatch(WorkforceManagementHelper.getReadyToSendCasesQuery());
        Id batchProcessId = Database.executeBatch(batch, 1);
        Test.stopTest();
        System.assertEquals(100, [SELECT Is_WorkForcePlanner_notified__c FROM Case where Is_WorkForcePlanner_notified__c = true].size(), 'workforce planner notified flag is updated on all cases');

    }

    @isTest static void negativeTest() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('WFMMockResponseFailure');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        List<Case> cases  = new List<Case>();
        for (Case c : [SELECT status FROM Case]) {
            c.Status = 'Closed';
            c.Is_WorkForcePlanner_notified__c = false;
            cases.add(c);
        }
        Update cases;

        Test.startTest();
        WorkforceManagementBatch batch = new WorkforceManagementBatch(WorkforceManagementHelper.getReadyToSendCasesQuery());
        Id batchProcessId = Database.executeBatch(batch, 1);
        Test.stopTest();
        System.assertEquals(100, [SELECT Is_WorkForcePlanner_notified__c FROM Case where Is_WorkForcePlanner_notified__c = false AND Workforce_Planning_Error__c != null].size(), 'workforce planner error is updated on all cases');

    }
}
