
var express = require('express');

var app = express();
var server = app.listen(8000);

console.log("My socket server is running");

var websocket = require('websocket').server;

wsServer = new websocket({
  httpServer: server
});

// WebSocket server
wsServer.on('request', function(request) {
  var connection = request.accept(null, request.origin);
  console.log("We got someone on");
  // This is the most important callback for us, we'll handle
  // all messages from users here.
  connection.on('message', function(message) {
    if (message.type === 'utf8') {
    	console.log("We got an event: " + message.utf8Data);
    	try {
    		var command = JSON.parse(message.utf8Data);
	    } catch (e) {
	    	console.log("couldn't parse data.");
	    	throw e;
	    	return;
	    }
       if (command.event == "newPlayer") {
       	
       	console.log("NewPlayer at coordinates: x = " + command.x + " y = " + command.y);
       }
    }
  });

  connection.on('close', function(connection) {
    // close user connection
  });
});
