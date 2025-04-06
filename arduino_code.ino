#include <WiFi.h>
#include <WebServer.h>
#include <Firebase_ESP_Client.h>
#include <ArduinoJson.h>
#include <Preferences.h>
#include <time.h>
//Provide the token generation process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"

// Firebase Configuration
#define API_KEY "AIzaSyC_wmflQu4qHyqStC6PapK49_JhwLzmV3U"
#define DATABASE_URL "https://gecw-cycles-default-rtdb.firebaseio.com/"

#define IN1 18  // L298N Input 1
#define IN2 19  // L298N Input 2

// WiFi Credentials
const char* ssid = "hello";         // Change to your phone's hotspot SSID
const char* password = "11221122";  // Change to your phone's hotspot password

// Firebase Credentials
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// Web Server
WebServer server(80);

// Preferences for persistent storage
Preferences preferences;

String globalOtp = "";
String phone = "";
const int LED_PIN = 2;  // ESP32 built-in LED (GPIO 2)

// Function to store OTP in Preferences
void storeOtpInPreferences(String otp, String phoneNumber) {
  preferences.begin("cycle-lock", false);
  preferences.putString("otp", otp);
  preferences.putString("phone", phoneNumber);
  preferences.end();
  Serial.println("OTP and phone number stored in Preferences");
}

// Function to retrieve OTP from Preferences
void retrieveOtpFromPreferences() {
  preferences.begin("cycle-lock", true);
  globalOtp = preferences.getString("otp", "");
  phone = preferences.getString("phone", "");
  preferences.end();

  if (globalOtp != "") {
    Serial.println("Retrieved from Preferences - OTP: " + globalOtp + ", Phone: " + phone);
  } else {
     storeOtpInPreferences("7926", "8075627926");
    Serial.println("No valid OTP found in Preferences");
  }
}

// Function to clear OTP from Preferences
void clearOtpFromPreferences() {
  preferences.begin("cycle-lock", false);
  preferences.putString("otp", "");
  preferences.putString("phone", "");
  preferences.end();
  globalOtp = "";
  phone = "";
  Serial.println("OTP cleared from Preferences");
}

// Fetch OTP from Firebase
String fetchOtpFromFirebase(String phoneNumber) {
  String path = "/cycle_one/users/" + phoneNumber + "/otp";
  if (Firebase.RTDB.getString(&fbdo, path)) {
    globalOtp = fbdo.stringData();
    Serial.println("Fetched OTP: " + globalOtp);
    storeOtpInPreferences(globalOtp, phoneNumber);
    return globalOtp;
  } else {
    Serial.println("Failed to fetch OTP: " + fbdo.errorReason());
    return "";
  }
}

// Handle GET OTP request
void getOtpHandleJsonData() {
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


void checkPasswordHandleJsonData() {
  if (server.hasArg("plain")) {  // Check if there's JSON data in the request
    String requestBody = server.arg("plain");
    Serial.println("Received JSON: " + requestBody);

    DynamicJsonDocument doc(200);  // Adjust size based on JSON complexity
    DeserializationError error = deserializeJson(doc, requestBody);
    if (error) {
      Serial.println("JSON Parsing Failed: " + String(error.c_str()));
      server.send(400, "application/json", "{\"message\": \"Invalid JSON\"}");
      return;
    }

    // Extract OTP from the JSON request
    String receivedOtp = doc["otp"].as<String>();

    if (receivedOtp == globalOtp) {
      
      // Unlock cycle - turn the LED OFF
      digitalWrite(LED_PIN, LOW);
      
      // Update 'status' to "On_Ride" for the specific user and set the global "isAvailable" flag to false
      String statusPath = "/cycle_one/users/" + phone + "/status";
      String availabilityPath = "/cycle_one/isAvailable";
      
      bool statusUpdated = Firebase.RTDB.setString(&fbdo, statusPath, "On_Ride");
      bool availUpdated  = Firebase.RTDB.setBool(&fbdo, availabilityPath, false);
      
      if (statusUpdated && availUpdated) {
        Serial.println("Status updated to On_Ride and isAvailable set to false in Firebase.");
      } else {
        Serial.println("Failed to update status/availability: " + fbdo.errorReason());
      }
      
      Serial.println("Lock Opened");
      unlock();  // Unlock lock
      delay(2000);

      server.send(200, "application/json", "{\"message\": \"Lock Opened\"}");
    } else {
      Serial.println("Incorrect OTP");
      server.send(403, "application/json", "{\"message\": \"Incorrect OTP\"}");
    }
  } else {
    server.send(400, "application/json", "{\"message\": \"No Data Received\"}");
  }
}

// Handle Cycle Locking
void lockCycleHandleJsonData() {
  if (!server.hasArg("plain")) {
    server.send(400, "application/json", "{\"error\": \"No Data Sent\"}");
    return;
  }

  String jsonData = server.arg("plain");
  Serial.println("Received JSON: " + jsonData);

  StaticJsonDocument<200> doc;
  DeserializationError err = deserializeJson(doc, jsonData);
  if (err) {
    Serial.println("JSON Parsing Failed: " + String(err.c_str()));
    server.send(400, "application/json", "{\"error\": \"Invalid JSON\"}");
    return;
  }

  String receivedData = doc["data"] | "";
  if (receivedData == "lock_cycle") {
    
    digitalWrite(LED_PIN, HIGH);
    Serial.println("Cycle locked");
    lock();  // Lock back
    delay(2000);
    server.send(200, "application/json", "{\"message\": \"Cycle Locked Successfully\"}");
  } else {
    server.send(400, "application/json", "{\"error\": \"Locking cycle failed\"}");
  }
}

// Handle Cycle Return with OTP Verification
void returnCycleHandleJsonData() {
  if (!server.hasArg("plain")) {
    server.send(400, "application/json", "{\"error\":\"No Data Sent\"}");
    return;
  }

  String jsonData = server.arg("plain");
  Serial.println("Received JSON: " + jsonData);

  StaticJsonDocument<200> doc;
  DeserializationError err = deserializeJson(doc, jsonData);
  if (err) {
    Serial.println("JSON Parsing Failed: " + String(err.c_str()));
    server.send(400, "application/json", "{\"error\":\"Invalid JSON\"}");
    return;
  }

  String receivedData = doc["data"] | "";
  String receivedOtp = doc["otp"] | "";

  if (receivedData == "return_cycle") {
    if (receivedOtp == globalOtp) {
      digitalWrite(LED_PIN, LOW);
      
      // Get current date and time
      struct tm timeinfo;
      char timeString[25];
      if (getLocalTime(&timeinfo)) {
        strftime(timeString, sizeof(timeString), "%Y-%m-%dT%H:%M:%S", &timeinfo);
      } else {
        strcpy(timeString, "Time Unavailable");
      }
      String currentTime = String(timeString);

      String path = "/cycle_one/users/" + phone + "/returned_time";
      if (Firebase.RTDB.setString(&fbdo, path, currentTime)) {
        Serial.println("Returned time updated in Firebase: " + currentTime);
        clearOtpFromPreferences();
        lock();  // Lock back
        delay(2000);
        server.send(200, "application/json", "{\"message\":\"Cycle Returned Successfully\"}");
      } else {
        Serial.println("Failed to update returned time: " + fbdo.errorReason());
        server.send(500, "application/json", "{\"error\":\"Failed to update returned time\"}");
      }
    } else {
      server.send(401, "application/json", "{\"error\":\"Incorrect OTP\"}");
    }
  } else {
    server.send(400, "application/json", "{\"error\":\"Error in returning cycle\"}");
  }

  delay(100);
  server.client().stop();
}

// Setup function
void setup() {
  pinMode(IN1, OUTPUT);
  pinMode(IN2, OUTPUT);
  digitalWrite(IN1, LOW);
  digitalWrite(IN2, LOW);

  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);

  retrieveOtpFromPreferences();

  WiFi.begin(ssid, password);
  Serial.println("Connecting to WiFi...");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nConnected to WiFi!");
  Serial.print("ESP32 IP Address: ");
  Serial.println(WiFi.localIP());

  configTime(0, 0, "pool.ntp.org");

  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;
  config.token_status_callback = tokenStatusCallback;
  config.signer.anonymous = true;

  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("Firebase SignUp Success");
  } else {
    Serial.println("Firebase SignUp Failed: " + fbdo.errorReason());
  }

  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  String ipAddress = WiFi.localIP().toString();
  Firebase.RTDB.setString(&fbdo, "/cycle_one/ip_address", ipAddress);

  server.on("/get-otp", HTTP_POST, getOtpHandleJsonData);
  server.on("/check-password", HTTP_POST, checkPasswordHandleJsonData); //unlovk
  server.on("/lock_cycle", HTTP_POST, lockCycleHandleJsonData);
  server.on("/return_cycle", HTTP_POST, returnCycleHandleJsonData);
  server.begin();

  Serial.println("Web Server started...");
}

// Loop function
void loop() {
  server.handleClient();
  if (WiFi.status() != WL_CONNECTED) {
    WiFi.disconnect();
    WiFi.reconnect();
  }
}

void unlock() {
    digitalWrite(IN1, HIGH);  // Forward rotation (unlock)
    digitalWrite(IN2, LOW);
    delay(1000);  // Lock opens for 1 second
    stopMotor();
}

void lock() {
    digitalWrite(IN1, LOW);
    digitalWrite(IN2, HIGH);  // Reverse rotation (lock)
    delay(1000);  // Lock engages for 1 second
    stopMotor();
}

void stopMotor() {
    digitalWrite(IN1, LOW);
    digitalWrite(IN2, LOW);
}