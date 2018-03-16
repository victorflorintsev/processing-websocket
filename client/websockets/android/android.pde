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
    send("Hello, it is me. Mario :)");
    System.out.println("new connection opened");
  }

  @Override
  public void onClose(int code, String reason, boolean remote) {
    System.out.println("closed with exit code " + code + " additional info: " + reason);
  }

  @Override
  public void onMessage(String msg) {
    System.out.println("received message: " + msg);

    JSONObject json = parseJSONObject(msg);
                if (json == null) {
                  println("JSONObject could not be parsed");
                } else {
                  if (json.getString("event").equals("newPlayerRPC")) {
                    Player player = new Player(json.getInt("x"), json.getInt("y"));
                    player.draw();
                    list.add(player);
                  }
                }
  }

  @Override
  public void onMessage(ByteBuffer message) {
    System.out.println("received ByteBuffer");
  }

  @Override
  public void onError(Exception ex) {
    System.err.println("an error occurred:" + ex);
  }

}


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
  
  Player(int x, int y) {
    pos = new PVector(x,y);
  }
  
  void draw() {
    noStroke();
    fill(255, 77, 77);
    rect(pos.x,pos.y,20,20); 
  }
  
  String toJSON() {
    return new JSONObject().setString("event", "newPlayer").setInt("x", int(pos.x)).setInt("y", int(pos.y)).toString();
  }
  
}

ArrayList<Player> list = new ArrayList<Player>();



void draw() {
 drawAll(list);
 if (mousePressed) {
  client.send(new Player(mouseX, mouseY).toJSON());
 }
}

void drawAll(ArrayList<Player> l) {
  for (int i = 0; i < l.size(); i++) {
   l.get(i).draw(); 
  }
}
