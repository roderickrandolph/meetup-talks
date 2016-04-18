var sync    = require('synchronize')
var AWS     = require("aws-sdk");
var ip      = require('ip');
var express = require('express');
var app     = express();

AWS.config.update({
    region:   "us-east-1",
    endpoint: "https://dynamodb.us-east-1.amazonaws.com"
});

var APP_VERSION         = "0.0.3";
var HOST_IP             = ip.address();
var DYNAMODB_TABLE_NAME = "TripleRTracker";

var dynamodb  = new AWS.DynamoDB();
var docClient = new AWS.DynamoDB.DocumentClient();
var metadaService = new AWS.MetadataService({
    httpOptions: {
        timeout: 10
    }
});

sync.fiber(function(){
    try {
        AWS_PRIVATE_IPV4 = sync.await(metadaService.request("/latest/meta-data/local-ipv4", sync.defers()));

        if (AWS_PRIVATE_IPV4) {
            console.log("found aws ip address: " + AWS_PRIVATE_IPV4[0]);
            HOST_IP = AWS_PRIVATE_IPV4[0];
            console.log("new host ip address: " + HOST_IP);
        }
    } catch(err) {
        console.log("aws ip address was not found");
    }
});

console.log("host ip address: " + HOST_IP);

app.get('/', function(req, res) {
    function saveVisits(visitCount) {
        var updateItem = {
            TableName: DYNAMODB_TABLE_NAME,
            Item: {
                "IPAddress": HOST_IP,
                "NumOfVisits": visitCount
            }
        };

        docClient.put(updateItem, function(err, data) {
            if (err) {
                console.log(JSON.stringify(err, null, 2));
            }
        });

        return visitCount;
    }

    var getItem = {
        TableName: DYNAMODB_TABLE_NAME,
        Key: { "IPAddress": HOST_IP }
    };

    docClient.get(getItem, function(err, data) {
        if (err) {
            console.log(JSON.stringify(err, null, 2));
            res.send("there was an error");
        }

        var visits = 0;

        if ('Item' in data && typeof data["Item"].NumOfVisits !== undefined) {
            visits = data["Item"].NumOfVisits;
        }

        res.send('ip: ' + HOST_IP + "\n" + 'ip visits: ' + saveVisits(visits + 1) + "\n" + 'version: ' + APP_VERSION);
    });
});

app.listen(80);
