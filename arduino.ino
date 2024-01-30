// Include required libraries
#include <WiFi.h>
#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>
#include <NTPClient.h>
#include <WiFiUdp.h>

// Define WiFi credentials
#define WIFI_SSID "aditya"
#define WIFI_PASSWORD "aditya123"

#define SOUND_SPEED 0.034
const int trigPin = 12;
const int echoPin = 13;
long duration;
float distanceCm;

// Define Firebase API Key, Project ID, and user credentials
#define API_KEY "AIzaSyBXfYxo46NyfcMhGZjjOQ5JuNF8qKyvIzk"
#define FIREBASE_PROJECT_ID "samagam-hackathon"
#define USER_EMAIL "aditya@gmail.com"
#define USER_PASSWORD "1852005"

// Define Firebase Data object, Firebase authentication, and configuration
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

// Define NTP Client to get time
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "pool.ntp.org", 0, 60000); // Change '0' to your timezone's offset in seconds

void setup() {
  // Initialize serial communication for debugging
  Serial.begin(115200);

  pinMode(trigPin, OUTPUT); // Sets the trigPin as an Output
  pinMode(echoPin, INPUT); // Sets the echoPin as an Input

  // Connect to Wi-Fi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  // Initialize a NTPClient to get time
  timeClient.begin();
  
  // Print Firebase client version
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  // Assign the API key
  config.api_key = API_KEY;

  // Assign the user sign-in credentials
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  // Assign the callback function for the long-running token generation task
  config.token_status_callback = tokenStatusCallback;  // see addons/TokenHelper.h

  // Begin Firebase with configuration and authentication
  Firebase.begin(&config, &auth);

  // Reconnect to Wi-Fi if necessary
  Firebase.reconnectWiFi(true);
}

void loop() {

  
  
  // Define the path to the Firestore document
  String documentPath="Esp32/GDB-C4";

  // Create a FirebaseJson object for storing data
  FirebaseJson content;

  // Update the NTP client to get the current time
  timeClient.update();

  // Get current time
  unsigned long epochTime = timeClient.getEpochTime();

  // Create timestamp string
  String timeStamp = String(epochTime);

  // Read distance from the sensor
  float dist = distance();
  String location = "GDB_C4"; // Dummy location data
  

  // Print distance, location, and time values
  Serial.println(dist);
  Serial.println(location);
 

  // Check if the values are valid (not NaN)
  if (!isnan(dist)) {
    // Set the fields in the FirebaseJson object
    content.set("fields/dist/stringValue", String(dist, 2));
    content.set("fields/location/stringValue", location);
    
    content.set("fields/timestamp/stringValue", timeStamp);

    Serial.print("Update/Add Data... ");

    // Use the patchDocument method to update the Firestore document
    if (Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "", documentPath.c_str(), content.raw(), "dist,location,timestamp")) {
      Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
    } else {
      Serial.println(fbdo.errorReason());
    }
  } else {
    Serial.println("Failed to read sensor data.");
  }

  // Delay before the next reading
  delay(10000);
}

float distance() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  // Reads the echoPin, returns the sound wave travel time in microseconds
  duration = pulseIn(echoPin, HIGH);
  
  // Calculate the distance
  distanceCm = duration * SOUND_SPEED/2;
  return distanceCm;
}
