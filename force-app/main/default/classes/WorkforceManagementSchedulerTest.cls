@isTest
private class WorkforceManagementSchedulerTest {
    @TestSetup
    static void createData(){
        insert TestDataFactory.createCases(100);
    }
    
    @isTest 
    static void TestSchedulable() {

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
        WorkforceManagementScheduler.scheduleJob('0 13 1 1/1 * ? *');        
        Test.stopTest();
    }
}