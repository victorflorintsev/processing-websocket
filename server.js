// goes on glitch.com

var Server = require('ws').Server;
var port = process.env.PORT || 3000;
var ws = new Server({
    port: port
});
var global_counter = 0;
var all_active_connections = {};


ws.on('connection', function(w) {
  console.log("connection added")
  var id = global_counter++;
  all_active_connections[id] = w;
  w.id = id; 
    w.on('message', function(message) {
      
        try {
            var command = JSON.parse(message);
        } catch (e) {
            console.log("couldn't parse data.");
            console.log(message);
            return;
        }
        if (command.event == "newPlayer") {

            console.log("NewPlayer at coordinates: x = " + command.x + " y = " + command.y);
            for (var conn in all_active_connections) {
              command["event"] = "newPlayerRPC";
              //JSON.stringify({"event": "newPlayerRPC", "x": command.x, "y": command.y, "color": command.color}) old way
              all_active_connections[conn].send(JSON.stringify(command));
            }
        }
    });

    w.on('close', function() {
        delete all_active_connections[w.id];
        console.log('closing connection');
    });

});


console.log("My socket server is running");