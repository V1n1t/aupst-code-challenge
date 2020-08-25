/**
 * @Author             : Vineeth Batreddy
 * @Description        : Utility class for common HTTP methods
**/
public abstract class HTTPUtility {

    /**
    * @description : method to create basic HTTPRequest
    **/
    public static HttpRequest createHTTPRequest(String endPointURL, String method, Integer timeout){
        Httprequest request = new HttpRequest();
        request.setEndpoint(endPointURL);
        request.setMethod(method);
        request.setTimeout(timeout);
        return request;
    }
}