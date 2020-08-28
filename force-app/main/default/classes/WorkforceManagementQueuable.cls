public class WorkforceManagementQueuable implements Queueable, Database.AllowsCallouts {
    
    private Id caseId;
    private Id ownerId;
    
    public WorkforceManagementQueuable(Id caseId, Id ownerId) {
        this.caseId = caseId;
        this.ownerId = ownerId;
    }
    public void execute(QueueableContext context) {
        WorkforceManagementService.invoke(caseId, ownerId);
    }
    
}