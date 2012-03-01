import processing.net.*;

String APIKEY = "RIFAALZY9I1NMI6M"; // your channel's API key
int FREQ = 30; // every 30s

Client c;
String data;

void setup() {
  size(200, 200);
  println("Hi!");
}

void draw() {
  
  println(second()+1);
  
  if((second()+1)%FREQ == 0) {
    sendData("field1", random(0, 10));
  } else {
    if(millis()%1000 == 0) {
      println("~");
    }
  }
  
  if(c != null) {
    if(c.available() > 0) {
      data = c.readString();
      println(data);
    }
  }
  
}

void sendData(String field, float num) {
  c = new Client(this, "api.thingspeak.com", 80); // Connect to server on port 80
  c.write("GET /update?key="+APIKEY+"&"+field+"=" + num + " HTTP/1.1\n");
  c.write("Host: robotgrrl.com\n\n"); // Be polite and say who we are
}
