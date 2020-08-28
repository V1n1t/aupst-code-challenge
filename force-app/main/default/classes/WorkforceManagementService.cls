public without sharing class WorkforceManagementService {
    
    private static final String SERVICE_NAME = 'WFMService';
    private static List<Integration_Log__c> integrationLogs = new List<Integration_Log__c>();
    private static List<Exception_Log__c> exceptionLogs = new List<Exception_Log__c>();
    private static List<Case> casesToUpdate = new List<Case>();
    
    public static void batchInvoke(List<Case> cases) {
        for(Case c : cases)
            invoke(c.Id, c.OwnerId);
    }
    
    public static void invoke(String caseId, String agentId) {
        try {
            HttpRequest request = prepareRequest(caseId, agentId);

            HttpResponse response = sendRequest(request);

            processResponse(response, caseId);
        }
        
        catch(Exception e) {
            exceptionLogs.add(ExceptionLogUtility.constructException(SERVICE_NAME, 'ERR-001', e));
        }
        finally {
            //if(!casesToUpdate.isEmpty())
            //    update casesToUpdate;

            // commit exceptions
            ExceptionLogUtility.commitExceptions(exceptionLogs);

            // link integration logs with exception log if any
            if(!exceptionLogs.isEmpty())
                integrationLogs = IntegrationLogUtility.addException(integrationLogs, exceptionLogs.get(0));
                
            // commit integration logs
            IntegrationLogUtility.commitIntegrationLogs(integrationLogs);
        }
    }

    private static HttpRequest prepareRequest(String caseId, String agentId) {
        
        // add retrieval from configuraion here
        HttpRequest request = HttpUtility.createHTTPRequest(SERVICE_NAME, 'POST', 10000);
        HTTPUtility.setContentType(request, 'application/x-www-form-urlencoded');
        
        Map<String, String> valueMap = new Map<String, String>();
        valueMap.put('id', caseId);
        valueMap.put('agentid', agentId);
        String req = urlEncode(valueMap);
        
        request.setBody(req);
        
        return request;
    }

    private static HttpResponse sendRequest(HttpRequest request) {
        
        // set endpoint. use mock endpoint if mocks are enabled
        String mockEndpoint = MockUtility.getMockEndpoint(SERVICE_NAME);
        if(String.isNotBlank(mockEndpoint))
            request.setEndpoint(mockEndpoint);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        // add request and response to the integration logs
        integrationLogs.add(IntegrationLogUtility.constructIntegrationLog(SERVICE_NAME, '', 'Request', request.getBody(), null, null));
        integrationLogs.add(IntegrationLogUtility.constructIntegrationLog(SERVICE_NAME, '', 'Response', response.getBody(), null, null));
        
        return response;
    }

    private static void processResponse(HttpResponse response, String caseId) {
        
        if(response!=null) {
            WorkforceManagementResponse resp = (WorkforceManagementResponse) JSON.deserialize(response.getBody(), WorkforceManagementResponse.class);
            
            Map<String,String> filters = new Map<String, String>();
            filters.put('Id', caseId);
            Case thisCase = (Case) QueryUtils.getRecord('Case', filters, null);
            thisCase.WFM_Service_Invocation_Timestamp__c = System.now();

            if(resp!=null && String.isNotBlank(resp.success)) {
                if(resp.success.equalsIgnoreCase('true')) {
                    thisCase.Is_WorkForcePlanner_notified__c = true;
                    thisCase.Secret_Key__c = resp.secretKey;
                    thisCase.Workforce_Planning_Error__c = '';
                }
                else if(resp.success.equalsIgnoreCase('false')) {
                    thisCase.Is_WorkForcePlanner_notified__c = false;
                    thisCase.Secret_Key__c = '';
                    thisCase.Workforce_Planning_Error__c = resp.error;
                }
            }
            else {
                exceptionLogs.add(ExceptionLogUtility.noResponseException(SERVICE_NAME, 'ERR-002'));
            }
            
            update thisCase;
        }
    }
    
    public static String urlEncode(Map<String, String> valueMap) {
        String res = '';
        for(String k : valueMap.keySet()) {
            res += EncodingUtil.urlEncode(k, 'UTF-8') + '=' + EncodingUtil.urlEncode(valueMap.get(k), 'UTF-8') + '&';
        }
        return res.removeEnd('&');    
    }

}