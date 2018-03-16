import websockets.*;

WebsocketClient ws;


class Player {
  PVector pos;
  
  Player(int x, int y) {
    pos = new PVector(x,y);
  }
  
  void draw() {
    println(pos);
    noStroke();
    fill(255, 77, 77);
    rect(pos.x,pos.y,20,20); 
  }
  
  String toJSON() {
    return new JSONObject().setString("event", "newPlayer").setInt("x", int(pos.x)).setInt("y", int(pos.y)).toString();
  }
  
}

ArrayList<Player> list = new ArrayList<Player>();

void setup() {
  size(1920,1080);
  background(75);
  ws = new WebsocketClient(this, "ws://quiver-gum.glitch.me");
}

void draw() {
 drawAll(list);
 if (mousePressed) {  
  ws.sendMessage(new Player(mouseX, mouseY).toJSON());
 }
}

void drawAll(ArrayList<Player> l) {
  for (Player p : l) {
    p.draw();
  }
}

void webSocketEvent(String msg){
  JSONObject json = parseJSONObject(msg);
  if (json == null) {
    println("JSONObject could not be parsed");
  } else {
    println(json.getString("event"));
    if (json.getString("event").equals("newPlayerRPC")) {
      Player player = new Player(json.getInt("x"), json.getInt("y"));
      player.draw();
      list.add(player);
    }
  }
}
