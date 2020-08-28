/**
 * @Author             : Vineeth Batreddy
 * @Description        : This class handles all trigger execution logic for Case
**/
public with sharing class CaseTriggerHandler extends TriggerHandler{

    public override void afterUpdate() {

        try {
            List<Id> closedCases = new List<Id>();
            map<Id, Case> before = (Map<Id, Case>)Trigger.oldMap;
            map<Id, Case> after = (Map<Id, Case>)Trigger.newMap;
            List<Id> enqueJobIds = new List<Id>();
            for(Id caseId : after.keySet()){ 
                if (after.get(caseId).Status == GlobalConstants.CASE_STATUS_CLOSED &&
                    before.get(caseId).Status != GlobalConstants.CASE_STATUS_CLOSED &&
                    after.get(caseId).Secret_Key__c == null &&
                    !after.get(caseId).Is_WorkForcePlanner_notified__c) {
                        closedCases.add(caseId);
                }            
            }
            if (!closedCases.isEmpty()) {
                Integer queueableLimit = LIMITS.getLimitQueueableJobs() - LIMITS.getQueueableJobs();
                for (Integer c=0; c < queueableLimit; c++) {
                    Id caseRecordId = closedCases.get(c);
                    System.enqueueJob(new WorkforceManagementQueuable(caseRecordId, after.get(caseRecordId).OwnerId));
                }  
            }          
        } catch (Exception e) {
            insert ExceptionLogUtility.constructException('CaseTriggerHandler', 'ERR-003', e); 
        }
    } 
}