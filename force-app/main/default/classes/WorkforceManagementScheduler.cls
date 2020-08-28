global class WorkforceManagementScheduler implements Schedulable {

    global static String scheduleJob(String schedule) {
        WorkforceManagementScheduler sc = new WorkforceManagementScheduler();
        return System.schedule('Workforce Management Notifier', schedule, sc);
    }
    global void execute(SchedulableContext sc){
        WorkforceManagementBatch batch = new WorkforceManagementBatch(WorkforceManagementHelper.getReadyToSendCasesQuery());
        Id batchProcessId = Database.executeBatch(batch, 1);
    }
}