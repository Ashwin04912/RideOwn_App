#include <WiFi.h>
#include <WebServer.h>
#include <ESPmDNS.h>
#include <Firebase_ESP_Client.h>
#include <ArduinoJson.h>  // Install ArduinoJson library

//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Firebase Configuration
#define API_KEY "AIzaSyC_wmflQu4qHyqStC6PapK49_JhwLzmV3U"
#define DATABASE_URL "https://gecw-cycles-default-rtdb.firebaseio.com/"

// WiFi Credentials
const char* ssid = "hello";         // Change to your phone's hotspot SSID
const char* password = "11221122";  // Change to your phone's hotspot password

// Firebase Credentials
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// Web Server
WebServer server(80);

String globalOtp = "";
String phone = "";
const int LED_PIN = 2;   // ESP32 built-in LED (GPIO 2)


// Fetch OTP from Firebase
String fetchOtpFromFirebase(String phoneNumber) {
  String path = "/user_data/" + phoneNumber + "/otp";  // Construct the correct path
  if (Firebase.RTDB.getString(&fbdo, path)) {
    globalOtp = fbdo.stringData();
    Serial.println("Fetched OTP: " + globalOtp);  
    return globalOtp;
  } else {
    Serial.println("Failed to fetch OTP: " + fbdo.errorReason());
    return "";
  }
}


// Handle GET OTP request from phone 
void getOtpHandleJsonData() {
  Serial.println("hahah");
  if (server.hasArg("plain")) {
    String jsonData = server.arg("plain");
    Serial.println("Received JSON: " + jsonData);

    StaticJsonDocument<200> doc;
    DeserializationError error = deserializeJson(doc, jsonData);
    if (error) {
      Serial.println("JSON Parsing Failed");
      server.send(400, "application/json", "{\"error\": \"Invalid JSON\"}");
      return;
    }

    String receivedData = doc["data"].as<String>();
    String receivedPhoneData = doc["phone"].as<String>();

    phone = receivedPhoneData;

    Serial.println("Extracted Data: " + receivedData);

    if (receivedData == "getotp") {
      globalOtp = fetchOtpFromFirebase(receivedPhoneData);
      if (!globalOtp.isEmpty()) {
        server.send(200, "application/json", "{\"otp\": \"" + globalOtp + "\", \"message\": \"success\"}");
      } else {
        server.send(500, "application/json", "{\"error\": \"Failed to fetch OTP\"}");
      }
    }
  }
}

// Handle Cycle Locking
void lockCycleHandleJsonData() {
  if (server.hasArg("plain")) {
    String jsonData = server.arg("plain");
    Serial.println("Received JSON: " + jsonData);

    StaticJsonDocument<200> doc;
    DeserializationError error = deserializeJson(doc, jsonData);
    if (error) {
      Serial.println("JSON Parsing Failed");
      server.send(400, "application/json", "{\"error\": \"Invalid JSON\"}");
      return;
    }

    String receivedData = doc["data"].as<String>();
    Serial.println("Extracted Data: " + receivedData);

    if (receivedData == "lock_cycle") {
      //write the code for locking cycle without otp here

      Serial.println("cycle locked");
      server.send(200, "application/json", "{\"message\": \"Cycle Locked Successfully\"}");
    } else {
      server.send(400, "application/json", "{\"error\": \"Locking cycle failed\"}");
    }
  } else {
    server.send(400, "application/json", "{\"error\": \"No Data Sent\"}");
  }
}

// Handle Cycle Return with OTP Verification
void returnCycleHandleJsonData() {
  if (server.hasArg("plain")) {
    String jsonData = server.arg("plain");
    Serial.println("Received JSON: " + jsonData);

    StaticJsonDocument<200> doc;
    DeserializationError error = deserializeJson(doc, jsonData);
    if (error) {
      Serial.println("JSON Parsing Failed");
      server.send(400, "application/json", "{\"error\": \"Invalid JSON\"}");
      return;
    }

    String receivedData = doc["data"].as<String>();
    String receivedOtp = doc["otp"].as<String>();
    Serial.println("Extracted Data: " + receivedData);
    Serial.println("Received OTP: " + receivedOtp);
    Serial.println("Stored OTP: " + globalOtp);

    if (receivedData == "return_cycle") {
      if (receivedOtp == globalOtp) {
        digitalWrite(LED_PIN, LOW);  // Unlock cycle
        server.send(200, "application/json", "{\"message\": \"Cycle Returned Successfully\"}");
        globalOtp = "";  // Reset stored OTP
      } else {
        server.send(401, "application/json", "{\"error\": \"Incorrect OTP\"}");
      }
    } else {
      server.send(400, "application/json", "{\"error\": \"Error in returning cycle\"}");
    }
  } else {
    server.send(400, "application/json", "{\"error\": \"No Data Sent\"}");
  }
}



void checkPasswordHandleJsonData() {
  if (server.hasArg("plain")) {  // Check if there's JSON data in the request
    String requestBody = server.arg("plain");  
    Serial.println("Received JSON: " + requestBody);

    DynamicJsonDocument doc(200); // Adjust size based on JSON complexity
    DeserializationError error = deserializeJson(doc, requestBody);

    if (error) {
      Serial.println("JSON Parsing Failed");
      server.send(400, "application/json", "{\"message\": \"Invalid JSON\"}");
      return;
    }

    // Extract OTP from the JSON request
    String receivedOtp = doc["otp"].as<String>();

    if (receivedOtp == globalOtp) {
      //write the lock opening logic here

      Serial.println("Lock Opened");
      server.send(200, "application/json", "{\"message\": \"Lock Opened\"}");
    } else {
      Serial.println("Incorrect OTP");
      server.send(403, "application/json", "{\"message\": \"Incorrect OTP\"}");
    }
  } else {
    server.send(400, "application/json", "{\"message\": \"No Data Received\"}");
  }
}


// Setup function
void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);  // Ensure LED is OFF initially

  // Connect to WiFi
  WiFi.begin(ssid, password);
  Serial.println("Connecting to WiFi...");

  int retries = 20;  // Retry up to 20 times
  while (WiFi.status() != WL_CONNECTED && retries > 0) {
    delay(500);
    Serial.print(".");
    retries--;
  }

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\nConnected to WiFi!");
    Serial.print("ESP32 IP Address: ");
    Serial.println(WiFi.localIP());  // Print ESP32 IP

     if (!MDNS.begin("gecw-cycles")) {  // Change "esp32" to any hostname you want
        Serial.println("Error starting mDNS");
        return;
    }
    Serial.println("mDNS started. Access at http://gecw-cycles.local");
  } else {
    Serial.println("\nFailed to connect to WiFi");
    return;  // Stop execution if no WiFi
  }


  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  config.token_status_callback = tokenStatusCallback;  // Token helper

  config.signer.anonymous = true;  // Enable anonymous sign-in

  if (Firebase.signUp(&config, &auth, "", "")) {
  Serial.println("Firebase SignUp Success");
} else {
  Serial.println("Firebase SignUp Failed: " + fbdo.errorReason());
}


  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  // Set up Web Server routes
  server.on("/get-otp", HTTP_POST, getOtpHandleJsonData);
  server.on("/check-password", HTTP_POST, checkPasswordHandleJsonData);
  server.on("/lock_cycle", HTTP_POST, lockCycleHandleJsonData);
  server.on("/return_cycle", HTTP_POST, returnCycleHandleJsonData);
  server.begin();

  Serial.println("Web Server started...");


  // if (Firebase.RTDB.setString(&fbdo, "/message", "good boy....")) {
  //   Serial.println("Stored 'hello' in Firebase successfully!");
  // } else {
  //   Serial.println("Failed to store 'hello': " + fbdo.errorReason());
  // }
}

// Loop function
void loop() {
  server.handleClient();  // Handle incoming requests

  // Ensure WiFi stays connected
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("WiFi Disconnected! Reconnecting...");
    WiFi.disconnect();
    WiFi.reconnect();
  }
}


