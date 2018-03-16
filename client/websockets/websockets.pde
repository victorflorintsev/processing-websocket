import java.net.URI;
import java.net.URISyntaxException;
import java.nio.ByteBuffer;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.drafts.Draft;
import org.java_websocket.drafts.Draft_6455;
import org.java_websocket.handshake.ServerHandshake;

public class EmptyClient extends WebSocketClient {

  public EmptyClient(URI serverUri, Draft draft) {
    super(serverUri, draft);
  }

  public EmptyClient(URI serverURI) {
    super(serverURI);
  }

  @Override
  public void onOpen(ServerHandshake handshakedata) {
    connected = true;
    println("new connection opened");
  }

  @Override
  public void onClose(int code, String reason, boolean remote) {
    println("closed with exit code " + code + " additional info: " + reason);
  }

  @Override
  public void onMessage(String msg) {
    println("received message: " + msg);

    JSONObject json = parseJSONObject(msg);
                if (json == null) {
                  println("JSONObject could not be parsed");
                } else {
                  if (json.getString("event").equals("newPlayerRPC")) {
                    Player player = new Player(json.getInt("x"), json.getInt("y"), json.getString("color"));
                    player.draw();
                    list.add(player);
                  }
                }
  }

  @Override
  public void onMessage(ByteBuffer message) {
    println("received ByteBuffer");
  }

  @Override
  public void onError(Exception ex) {
    System.err.println("an error occurred:" + ex);
  }

}

String[] colors = {"#c56cf0", "#ffb8b8", "#ff3838", "#ff9f1a", "#fff200", "#32ff7e", "#7efff5", "#18dcff", "#7d5fff", "#4b4b4b"};
String mycolor = colors[int(random(0,colors.length))];
boolean connected = false;
 //<>//
WebSocketClient client;
void setup() {
  size(1920,1080);
  background(75);
  
  try {
   client = new EmptyClient(new URI("ws://processing-websockets.glitch.me"));
  } catch (Exception e) {e.printStackTrace();}
  client.connect();
}

class Player {
  PVector pos;
  String col;
  
  Player(int x, int y, String col1) {
    pos = new PVector(x,y);
    col = col1; // Easy to do load JSON.
    
  }
  
  void draw() {
    noStroke();
    fill(color(unhex("FF" + col.substring(1)))); // Getting the color string to the correct type (type [color])
    rect(pos.x,pos.y,20,20); 
  }
  
  String toJSON() {
    return new JSONObject().setString("event", "newPlayer").setInt("x", int(pos.x)).setInt("y", int(pos.y)).setString("color", col).toString();
  }
  
}

ArrayList<Player> list = new ArrayList<Player>();



void draw() {
 drawAll(list);
}

void mouseDragged() {
  if (connected) {
   client.send(new Player(mouseX, mouseY, mycolor).toJSON()); 
  } 
}

void drawAll(ArrayList<Player> l) {
  for (int i = 0; i < l.size(); i++) {
   l.get(i).draw(); 
  }
}
