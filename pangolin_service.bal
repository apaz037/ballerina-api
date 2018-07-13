import ballerina/http;

endpoint http:Listener listener {
    port:9090
};

// pangolin management is done using an in memory map.
// Add some sample pangolins to 'pangolinsMap' at startup.
map<json> pangolinMap;

// RESTful service.
@http:ServiceConfig { basePath: "/api" }
service<http:Service> PangolinService bind listener {

    // Resource that handles the HTTP GET requests that are directed to a specific
    // pangolin using path '/pangolins/<pangolinID>
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/pangolin/{pangolinId}"
    }
    findPangolin(endpoint client, http:Request req, string pangolinId) {
        // let's find the pangolin we want and return it in JSON
        json? payload = pangolinMap[pangolinId];
        http:Response response;
        if (payload == null) {
            payload = "PangolinId: " + pangolinId + " could not be found";
        }

        //  Set the JSON payload of our response
        response.setJsonPayload(payload, contentType = "application/json");
        _ = client->respond(response);
    }

    // Resource that handles the HTTP POST requests that are directed to the path
    // '/pangolins' to create a new pangolin.
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/pangolin"
    }
    addPangolin(endpoint client, http:Request req) {
        json pangolinReq = check req.getJsonPayload();
        string pangolinId = pangolinReq.Pangolin.ID.toString();
        pangolinMap[pangolinId] = pangolinReq;

        //  create our response
        json payload = { status: "Pangolin " + pangolinId + " was born"};
        http:Response response;
        response.setJsonPayload(payload, contentType = "application/json");

        // set 201 for created
        response.statusCode = 201;
        //  set location header in the response message
        //  that way we can send our user back the pangolin we just created
        response.setHeader("Location", "http://localhost:9090/api/pangolin/" + pangolinId);

        // send the response the client
        _= client->respond(response);
    }

    // Resource that handles the HTTP PUT requests that are directed to the path
    // '/pangolins' to update an existing pangolin.
    @http:ResourceConfig {
        methods: ["PUT"],
        path: "/pangolin/{pangolinId}"
    }
    updatePangolin(endpoint client, http:Request req, string pangolinId) {
        json updatedPangolin = check req.getJsonPayload();

        // find the pangolin that needs to be updated and retrieve it in JSON
        json existingPangolin = pangolinMap[pangolinId];

        //  update existing pangolin with the attributes of the updated pangolin
        if (existingPangolin != null) {
            existingPangolin.Pangolin.Name = updatedPangolin.Pangolin.Name;
            existingPangolin.Pangolin.Size = updatedPangolin.Pangolin.Size;
            pangolinMap[pangolinId] = existingPangolin;
        } else {
            existingPangolin = "Pangolin " + pangolinId + " is no where to be found";
        }
    }

    // Resource that handles the HTTP DELETE requests, which are directed to the path
    // '/pangolins/<pangolinId>' to delete an existing pangolin.
    @http:ResourceConfig {
        methods: ["DELETE"],
        path: "/pangolin/{pangolinId}"
    }
    cancelPangolin(endpoint client, http:Request req, string pangolinId) {
        http:Response response;

        //  get rid of the pangolin
        _ = pangolinMap.remove(pangolinId);

        json payload = "Got it.  Pangolin " + pangolinId + " wont be bothering us anymore...";

        // let's set our payload
        response.setJsonPayload(payload, contentType = "application/json");
        _ = client->respond(response);
    }
}