#include <WiFi.h>
#include <WebServer.h>
#include <ESPmDNS.h>
#include <Firebase_ESP_Client.h>
#include <ArduinoJson.h>  // Install ArduinoJson library
#include <Preferences.h>   // ESP32 Preferences library for persistent storage

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

// Create a preferences object
Preferences preferences;

String globalOtp = "";
String phone = "";
const int LED_PIN = 2;   // ESP32 built-in LED (GPIO 2)

// Function to store OTP in Preferences
void storeOtpInPreferences(String otp, String phoneNumber) {
  // Open preferences with "cycle-lock" namespace
  preferences.begin("cycle-lock", false);
  
  // Store OTP and phone number
  preferences.putString("otp", otp);
  preferences.putString("phone", phoneNumber);
  
  // Close the preferences
  preferences.end();
  
  Serial.println("OTP and phone number stored in Preferences");
}

// Function to retrieve OTP from Preferences
void retrieveOtpFromPreferences() {
  // Open preferences with "cycle-lock" namespace
  preferences.begin("cycle-lock", true); // true = read-only mode
  
  // Retrieve OTP and phone number
  globalOtp = preferences.getString("otp", "");
  phone = preferences.getString("phone", "");
  
  // Close the preferences
  preferences.end();
  
  if (globalOtp != "") {
    Serial.println("Retrieved from Preferences - OTP: " + globalOtp + ", Phone: " + phone);
  } else {
    Serial.println("No valid OTP found in Preferences");
  }
}

// Function to clear OTP from Preferences
void clearOtpFromPreferences() {
  // Open preferences with "cycle-lock" namespace
  preferences.begin("cycle-lock", false);
  
  // Clear OTP and phone (you can use remove() to delete the key or just store empty string)
  preferences.putString("otp", "");
  // If you want to completely remove the keys:
  // preferences.remove("otp");
  // preferences.remove("phone");
  
  // Close the preferences
  preferences.end();
  
  globalOtp = "";
  phone = "";
  Serial.println("OTP cleared from Preferences");
}

// Fetch OTP from Firebase
String fetchOtpFromFirebase(String phoneNumber) {
  String path = "/cycle_one/users/" + phoneNumber + "/otp";  // Construct the correct path
  if (Firebase.RTDB.getString(&fbdo, path)) {
    globalOtp = fbdo.stringData();
    Serial.println("Fetched OTP: " + globalOtp);
    
    // Store OTP and phone in Preferences for persistence across power cycles
    storeOtpInPreferences(globalOtp, phoneNumber);
    
    return globalOtp;
  } else {
    Serial.println("Failed to fetch OTP: " + fbdo.errorReason());
    return "";
  }
}

// Handle GET OTP request from phone 
void getOtpHandleJsonData() {
  Serial.println("Handling OTP request");
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
      // Code for locking cycle without OTP
      digitalWrite(LED_PIN, HIGH);  // Lock cycle - LED ON to indicate lock
      
      Serial.println("Cycle locked");
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
        digitalWrite(LED_PIN, LOW);  // Unlock cycle - LED OFF to indicate unlock
        
        // Clear OTP from both global variable and Preferences
        clearOtpFromPreferences();
        
        server.send(200, "application/json", "{\"message\": \"Cycle Returned Successfully\"}");
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
      // Write the lock opening logic here
      digitalWrite(LED_PIN, LOW);  // Unlock cycle - LED OFF

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
  
  // Retrieve OTP and phone from Preferences if available
  retrieveOtpFromPreferences();
  
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

    // Corrected mDNS initialization
    if (!MDNS.begin("gecw-cycles")) {
      Serial.println("Error starting mDNS");
      return;
    }
    
    // Add service advertisement for HTTP
    MDNS.addService("http", "tcp", 80);
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
  
  if (globalOtp != "") {
    Serial.println("Restored previous OTP session: " + globalOtp + " for phone: " + phone);
  }
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