// Modify Requests for Hugo Websites to work on S3

'use strict';

exports.handler = (event, context, callback) => {

    // Extract the request from the CloudFront event that is sent to Lambda@Edge 
    var request = event.Records[0].cf.request;

    // Extract the URI from the request
    var olduri = request.uri;

    // Add trailing slash where missing (stuff with no suffix)
    var slashuri = olduri.replace(/(\/[a-zäöüßA-ZÄÖÜ0-9_\-\+\%]+$)/, "$1\/");

    // Match any '/' that occurs at the end of a URI. Replace it with a default index
    var newuri = slashuri.replace(/\/$/, "\/index.html");

    // Log the URI as received by CloudFront and the new URI to be used to fetch from origin
    console.log("Old URI: " + olduri);
    console.log("Sls URI: " + slashuri);
    console.log("New URI: " + newuri);

    // Replace the received URI with the URI that includes the index page
    request.uri = newuri;

    // Return to CloudFront
    return callback(null, request);
}