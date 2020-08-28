/**
 * @Author             : Vineeth Batreddy
 * @Description        : Utility class for common HTTP methods
**/
public abstract class HTTPUtility {

    /**
    * @description : method to create basic HTTPRequest
    **/
    public static HttpRequest createHTTPRequest(String namedCredential, String method, Integer timeout) {
        Httprequest request = new HttpRequest();
        request.setEndpoint('callout:'+namedCredential);
        request.setMethod(method);
        request.setTimeout(timeout);
        return request;
    }

    public static HttpRequest setContentType(HttpRequest request, String contentType) {
        request.setHeader('Content-Type', contentType);
        return request;
    }
}