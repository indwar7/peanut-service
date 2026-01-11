# Peanut Trading App

Peanut Trading App is a Flutter-based mobile application 
The application integrates with the **Peanut Client Account Service** to provide authentication, user profile data, open trades listing, and profit calculation in a production-ready UI.

---

## 📱 Technology Stack

- **Framework:** Flutter
- **Language:** Dart
- **Platform:** Android
- **Architecture:** Clean / MVVM-inspired
- **Networking:** REST APIs
- **State Management:** Flutter native / Provider (as implemented)
- **Build Output:** APK

---

## 🎯 Functional Requirements Implemented

### 1. User Authorization (Peanut Service)

- Login using Peanut REST API
- Authentication via:
  - `POST IsAccountCredentialsCorrect`
- Secure access-token handling
- Token expiration handling
- Persistent login (no need to re-enter credentials)
- Logout and re-login support

**Test Account Credentials**


---

### 2. User Profile Data

The application fetches and displays user account data using authenticated requests.

**APIs Used**
- `GetAccountInformation`
- `GetLastFourNumbersPhone`

**Displayed Information**
- Basic account details
- Last four digits of the registered phone number

---

### 3. Open Trades Listing

- Fetches user trades using:
  - `GetOpenTrades`
- Trades displayed in a scrollable list of cards
- Supports:
  - Pull-to-refresh or refresh action
  - Smooth scrolling
- UI updates correctly on data refresh

---

### 4. Profit Calculation

- Calculates total user profit using the `profit` field from open trades
- Automatically updates when the trades list is refreshed
- Profit is clearly displayed to the user

---

### 5. Promotional Campaigns (Optional Feature)

- Promotional campaigns fetched using SOAP API:
  - `GetCCPromo`
- No authentication required
- Language parameter: `en`
- Promotions displayed as cards
- Clickable links supported
- Image domain updated to:
  - `forex-images.ifxdb.com`

---

## 🌐 APIs & Documentation

- **Peanut REST API (Swagger):**  
  https://peanut.ifxdb.com/docs/clientcabinet/index.html

- **SOAP Promo Service:**  
  https://api-forexcopy.contentdatapro.com/Services/CabinetMicroService.svc

---

## 🧩 Application Behavior & UX

- Responsive UI for different screen sizes
- Handles:
  - Screen rotation
  - App background/foreground transitions
- Graceful handling of:
  - Internet connectivity loss
  - API errors
  - Token expiration
- User-friendly error messages
- Clean, production-ready UI design

---

## 📁 Project Structure (Overview)

lib/
├── main.dart
├── screens/
│ ├── auth/
│ ├── profile/
│ ├── trades/
│ └── promotions/
├── services/
│ ├── auth_service.dart
│ ├── api_service.dart
│ └── promo_service.dart
├── models/
└── utils/




---

## ▶️ Getting Started

### Prerequisites
- Flutter SDK installed
- VS Code
- Android Emulator [google pixel 9]

### Run the Application
```bash
flutter pub get
flutter run
