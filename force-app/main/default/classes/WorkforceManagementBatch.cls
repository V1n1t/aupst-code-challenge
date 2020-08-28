global class WorkforceManagementBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
	
	String query;

	global WorkforceManagementBatch(String q) {
		query = q;
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

	global void execute(Database.BatchableContext BC,List<sObject> scope) {
		
        List<Case> cases = (List<Case>)scope;
        for(Case c : cases)
            WorkforceManagementService.batchInvoke(cases);
		
	}

	global void finish(Database.BatchableContext BC) {

    }

}