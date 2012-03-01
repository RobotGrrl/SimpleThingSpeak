/*

 A bare-bones example of sending data into the cloud for
 various ThingSpeak implementations, like MyRobots
 
 We use Client to connect to the ThingSpeak server on port 80,
 then send the data with our fields using GET
 
 Upon successful send of the request, we should receive a number
 back from the server representing the entry_id of the info
 
 There are two main points in this sketch- 
 1. you can send one piece of data at a time, with the sendData() method
 2. you can send a bulk of data in one request, with the sendDatum() method
 
 For more information:
 ThingSpeak: http://thingspeak.com
 MyRobots: http://myrobots.com
 
 Based off of the example by Keegan Mann
 http://keeganmann.wordpress.com/2011/04/15/thingspeak-light-sensor-test/
 
 By RobotGrrl
 robotgrrl.com Feb 28, 2012
 
 */

import processing.net.*;

String SERVER = "bots.myrobots.com"; // MyRobots or ThingSpeak
String APIKEY = "F6427DAE58A545CF"; // your channel's API key

//String SERVER = "api.thingspeak.com"; // MyRobots or ThingSpeak
//String APIKEY = "RIFAALZY9I1NMI6M"; // your channel's API key

int FREQ = 30; // update every 30s

Client c;

int sec_0 = 88; // previous second, silly value
int sec; // time counter

// for sendData
String data;
float meep = 13.37;

// for sendDatum
String[] fields = { "field1", "field2", "field3", "field4", "field5", "field6", "field7", "field8" };
float[] datum = new float[8];


void setup() {
  size(200, 200);
  frameRate(60);
  println("Hi!");
}


void draw() {

  if (c != null) {
    if (c.available() > 0) {
      data = c.readString();
      println("entry_id: " + data + "\n");
    }
  }

  sec = second();

  if (sec%FREQ == 0 && sec_0 != sec) {
    println("\n\nding!");
    sec_0 = sec;
    if(sec == 30) {
      sendData("field1", meep);
    } else {
      for(int i=0; i<fields.length; i++) {
        datum[i] = (float)i;
      }
      sendDatum(fields, datum);
    }
    println("done");
  } 
  else {
    if (sec != sec_0) {
      print(sec + " ");
      sec_0 = sec;
    }
  }
  
}

void sendData(String field, float num) {

  String url = ("GET /update?key="+APIKEY+"&"+field+"=" + num + "\n");
  print("sending data: " + url);
  
  c = new Client(this, SERVER, 80);
  if (c != null) c.write(url);
  
}

void sendDatum(String fields[], float num[]) {
  
  String url = ("GET /update?key="+APIKEY);
  StringBuffer sb = new StringBuffer(url);
  
  for(int i=0; i<fields.length; i++) {
    String s = ("&"+fields[i]+"="+datum[i]);
    sb.append(s);
  }
  
  sb.append("&status=sent from processing!\n");
  
  String finalurl = sb.toString();
  print("sending data: " + finalurl);
  
  c = new Client(this, SERVER, 80);
  if (c != null) c.write(finalurl);
  
}

