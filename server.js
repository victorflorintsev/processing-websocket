var Server = require('ws').Server;
var port = process.env.PORT || 3000;
var ws = new Server({
    port: port
});

ws.on('connection', function(w) {
  
    w.on('message', function(message) {
        console.log("We got an event: " + message);
        try {
            var command = JSON.parse(message);
        } catch (e) {
            console.log("couldn't parse data.");
            throw e;
            return;
        }
        if (command.event == "newPlayer") {

            console.log("NewPlayer at coordinates: x = " + command.x + " y = " + command.y);
            w.send(JSON.stringify({"event": "newPlayerRPC", "x": command.x, "y": command.y}));
        }
    });

    w.on('close', function() {
        console.log('closing connection');
    });

});


console.log("My socket server is running");