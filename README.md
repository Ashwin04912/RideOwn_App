# 🚲 Secure & Seamless Cycle with User Tracking

A **Flutter-based mobile app** built for our mini project: **Smart Cycle Locking System** — a secure and convenient way to lock/unlock your bicycle using your smartphone via Bluetooth.

## 🚲 Project Overview – Secure & Seamless Cycle with User Tracking


This project presents a smart bicycle-sharing system designed for college campuses, combining IoT, mobile app automation, and user tracking for a seamless, secure experience.

The system enables students and staff to request, unlock, and return bicycles using a Flutter mobile app integrated with an ESP32-based electronic lock. It eliminates the need for manual key handling by implementing OTP-based authentication via Wi-Fi, with user and usage data securely stored and managed through Firebase.

---

## 🛠️ Tech Stack

### 📱 Software
- **Flutter** – Cross-platform mobile framework.
- **Dart** – Programming language for Flutter.
- **Bluetooth Communication** – Using `flutter_blue_plus` package.
- **State Management** – SetState / Provider (as per implementation).
- **Platform** – Android (primary), iOS (optional).

### 🔩 Hardware
- **Microcontroller** – Arduino UNO/Nano or ESP32.
- **Bluetooth Module** – HC-05/HC-06 or built-in (ESP32).
- **Locking Mechanism** – Servo motor or electronic solenoid lock.
- **Power Supply** – Battery for portability.
- **Chassis** – Bicycle-mounted casing to hold electronics.

---

## 🚀 Features

- 🔒 **Lock & Unlock** your cycle from the mobile app.
- 🔍 **Scan & Connect** to available Bluetooth devices.
- 📡 **Real-time Bluetooth communication**.
- 🔋 **Battery Level Monitoring** (optional, if implemented in hardware).
- 🌐 **Responsive UI** with Flutter Material Components.
- 🛠️ Built for **ease of use** and **expandability**.

---

## 📸 Screenshots

> (Add screenshots of the app interface and hardware setup here)

---

## 📦 Installation & Setup

### 🔧 Flutter App

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/mini_pro_app.git
   cd mini_pro_app
Install dependencies

bash
Copy
Edit
flutter pub get
Connect your Android device (with Developer Mode + USB Debugging enabled)

Run the app

bash
Copy
Edit
flutter run
Make sure:

Location & Bluetooth permissions are granted.

Bluetooth is enabled on your device.

🤖 Hardware Setup (Basic Overview)
Upload Arduino code for Bluetooth-based locking.

Connect the Bluetooth module to the microcontroller (TX, RX).

Use digital pin to control the lock (servo/solenoid).

Ensure the lock responds to commands like "LOCK" / "UNLOCK" from the app.

(Add circuit diagram, Arduino sketch reference if needed)

📈 Future Scope
📍 Add GPS tracking for lock location.

🔐 Implement User Authentication and lock ownership.

🧠 Add Theft detection using motion sensors.

☁️ Integrate with Firebase for data sync and cloud control.

🗺️ Real-time map and tracking features.

🧑‍💻 Authors
Ashwin – Flutter Developer

[Your teammate’s name] – Embedded Systems Engineer

Project Type: BTech Mini Project (2025)

Institution: [Your College Name]

📚 Useful Links
Flutter Documentation

FlutterBluePlus Package

Arduino Bluetooth Basics

📜 License
This project is for educational purposes. Feel free to reuse and modify the code for learning or building similar systems. Attribution appreciated!

diff
Copy
Edit

Let me know if you'd like to include:
- A sample Arduino code section
- Circuit diagrams
- App screenshots
- Permissions handling steps

I can help you generate those too!







