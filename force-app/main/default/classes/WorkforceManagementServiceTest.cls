@isTest
private class WorkforceManagementServiceTest {
    @TestSetup
    static void createData(){
        insert TestDataFactory.createCases(250);
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
            cases.add(c);
        }
        Test.startTest();
        Update cases;
        Test.stopTest();
        System.assertEquals(50, [SELECT Status, Secret_Key__c, Is_WorkForcePlanner_notified__c FROM Case WHERE Is_WorkForcePlanner_notified__c = true AND WFM_Service_Invocation_Timestamp__c != null].size(), '50 cases are processed successfully');
    }

    @isTest static void negativeTest() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('WFMMockResponseFailure');
        mock.setStatusCode(500);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        List<Case> cases  = new List<Case>();
        for (Case c : [SELECT status FROM Case]) {
            c.Status = 'Closed';
            cases.add(c);
        }
        Test.startTest();
        Update cases;
        Test.stopTest();
        System.assertEquals(50, [SELECT Status, Secret_Key__c, Is_WorkForcePlanner_notified__c FROM Case WHERE Is_WorkForcePlanner_notified__c = false AND Workforce_Planning_Error__c != null].size(), '50 case records should have an error message');

    }
}
