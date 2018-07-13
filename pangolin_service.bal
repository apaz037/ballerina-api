import ballerina/http;

endpoint http:Listener listener {
    port:9090
};

// Order management is done using an in memory map.
// Add some sample orders to 'ordersMap' at startup.
map<json> ordersMap;

// RESTful service.
@http:ServiceConfig { basePath: "/api" }
service<http:Service> orderMgt bind listener {

    // Resource that handles the HTTP GET requests that are directed to a specific
    // order using path '/orders/<orderID>
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/pangolin/{pangolinId}"
    }
    findPangolin(endpoint client, http:Request req, string orderId) {
        // Implementation
    }

    // Resource that handles the HTTP POST requests that are directed to the path
    // '/orders' to create a new Order.
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/pangolin"
    }
    addPangolin(endpoint client, http:Request req) {
        // Implementation
    }

    // Resource that handles the HTTP PUT requests that are directed to the path
    // '/orders' to update an existing Order.
    @http:ResourceConfig {
        methods: ["PUT"],
        path: "/pangolin/{pangolinId}"
    }
    updatePangolin(endpoint client, http:Request req, string orderId) {
        // Implementation
    }

    // Resource that handles the HTTP DELETE requests, which are directed to the path
    // '/orders/<orderId>' to delete an existing Order.
    @http:ResourceConfig {
        methods: ["DELETE"],
        path: "/pangolin/{pangolinId}"
    }
    cancelPangolin(endpoint client, http:Request req, string orderId) {
        // Implementation
    }
}