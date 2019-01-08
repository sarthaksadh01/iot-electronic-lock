

#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>

#ifndef APSSID
#define APSSID "doorlock"//don't change the name as same name confg in app
#define APPSK  "password"
#endif

/* Set these to your desired credentials. */
const char *ssid = APSSID;
const char *password = APPSK;

ESP8266WebServer server(80);

void handleRoot() {
  server.send(200, "text/html", "you are connected");
  int val=server.arg("lock").toInt();
  if(val==0)
  digitalWrite(LED_BUILTIN, HIGH);
  else{
    digitalWrite(LED_BUILTIN, LOW);//unlock the door for one second 
    delay(1000);
    digitalWrite(LED_BUILTIN, HIGH);
  }
  
  Serial.println(val);
}

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, HIGH);
  
  delay(1000);
  Serial.begin(9600);
  Serial.println();
  Serial.print("Configuring access point...");
  WiFi.softAP(ssid, password);

  IPAddress myIP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(myIP);
  server.on("/", handleRoot);
  server.begin();
  Serial.println("HTTP server started");
}

void loop() {
  server.handleClient();
}
