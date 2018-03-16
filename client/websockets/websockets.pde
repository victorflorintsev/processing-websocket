import websockets.*;

WebsocketClient ws;


class Player {
  PVector pos;
  
  Player(int x, int y) {
    pos = new PVector(x,y);
    noStroke();
    fill(255, 77, 77);
    rect(x,y,20,20);
  }
  
  String toJSON() {
   return "{\"event\": \"newPlayer\", \"x\": " + pos.x + ", \"y\": " + pos.y + "}"; 
  }
  
}

ArrayList<Player> list = new ArrayList<Player>();

void setup() {
  size(1920,1080);
  background(75);
  ws = new WebsocketClient(this, "ws://localhost:3000/");
}

void draw() {
 if (mousePressed) {
  Player newPlayer = new Player(mouseX, mouseY);
  list.add(newPlayer);
  ws.sendMessage(newPlayer.toJSON());
 }
}
