# ✈️ Airway Ally - Your Personal Travel Assistant

[![Flutter](https://img.shields.io/badge/Flutter-3.32.6-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange.svg)](https://firebase.google.com/)
[![Real-time](https://img.shields.io/badge/Real--time-Enabled-green.svg)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Airway Ally** is a comprehensive travel assistant app built with Flutter that provides real-time flight tracking, document management, chat support, and airport guides. Perfect for travelers who need assistance with navigation, document organization, and real-time travel updates.

## 🚀 Features

### ✈️ Real-time Flight Tracking
- **Live API Integration**: Real-time flight data from Aviation Stack API
- **Live Status Updates**: Boarding → Departed → Arrived with live timestamps
- **Flight Search**: Search flights by number or route
- **Progress Tracking**: Real-time flight progress and ETA calculations
- **"LIVE" Badge**: Indicates real-time data vs simulated data

### 📄 Document Management
- **Real-time Cloud Storage**: Firebase Storage integration
- **Live Document Streams**: Real-time document synchronization
- **Smart Categories**: Travel Documents, Flight Documents, Accommodation, etc.
- **Search & Filter**: Real-time search and category filtering
- **Cross-device Sync**: Access documents from any device

### 💬 Real-time Chat System
- **Live Messaging**: Instant message delivery with Firebase Firestore
- **Online Status**: Real-time user presence indicators
- **Typing Indicators**: Live typing status
- **Read Receipts**: Message status tracking
- **Conversation Management**: Real-time conversation lists

### 🏢 Airport Guides
- **Comprehensive Information**: Terminals, gates, amenities
- **Transportation Options**: Parking, shuttles, public transport
- **Travel Tips**: Security, customs, local information
- **Interactive Maps**: Terminal layouts and navigation

### 🔐 Secure Authentication
- **Firebase Auth**: Real-time login status
- **Cross-device Sessions**: Seamless device switching
- **Profile Management**: User profiles and settings
- **Security**: End-to-end encryption

### 📱 Smart Notifications
- **Push Notifications**: Firebase Cloud Messaging
- **Local Notifications**: Device-specific alerts
- **Flight Reminders**: Departure and arrival notifications
- **Document Alerts**: Important document reminders

## 🛠️ Technical Stack

### Frontend
- **Flutter 3.32.6**: Cross-platform UI framework
- **Dart**: Programming language
- **Material Design 3**: Modern UI components
- **Riverpod**: State management

### Backend & Services
- **Firebase Authentication**: User management
- **Firebase Firestore**: Real-time database
- **Firebase Storage**: Cloud file storage
- **Firebase Cloud Messaging**: Push notifications
- **Aviation Stack API**: Real-time flight data

### Development Tools
- **FlutterFire CLI**: Firebase configuration
- **Flutter Local Notifications**: Local alerts
- **HTTP Package**: API communication
- **Timezone**: Timezone handling

## 📱 Screenshots

### Main Features
- **Authentication**: Secure login and registration
- **Dashboard**: Role-based home screens
- **Flight Tracking**: Real-time flight information
- **Document Management**: Cloud storage interface
- **Chat System**: Real-time messaging
- **Airport Guides**: Comprehensive airport information

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.32.6 or higher
- Dart SDK 3.0 or higher
- Firebase project setup
- iOS Simulator / Android Emulator / Physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/airway_ally.git
   cd airway_ally
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project
   - Add iOS and Android apps
   - Download configuration files:
     - `google-services.json` (Android)
     - `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories

4. **API Keys Setup**
   - Get Aviation Stack API key
   - Update `lib/services/flight_api_service.dart` with your API key

5. **Run the app**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Firebase Configuration
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication, Firestore, Storage, and Cloud Messaging
3. Add your apps (iOS/Android) to the project
4. Download and add configuration files

### API Keys
- **Aviation Stack API**: Get free API key from [Aviation Stack](https://aviationstack.com/)
- Update the API key in `lib/services/flight_api_service.dart`

### Environment Variables
Create a `.env` file in the root directory:
```env
AVIATION_STACK_API_KEY=your_api_key_here
FIREBASE_PROJECT_ID=your_project_id
```

## 📁 Project Structure

```
airway_ally/
├── lib/
│   ├── core/
│   │   └── app_theme.dart
│   ├── features/
│   │   ├── auth/
│   │   ├── airport/
│   │   ├── chat/
│   │   ├── documents/
│   │   ├── matching/
│   │   ├── onboarding/
│   │   ├── profile/
│   │   └── trips/
│   ├── providers/
│   ├── services/
│   └── utils/
├── test/
├── android/
├── ios/
├── web/
└── pubspec.yaml
```

## 🧪 Testing

Run the test suite:
```bash
flutter test
```

Run with coverage:
```bash
flutter test --coverage
```

## 📦 Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🔒 Security Features

- **Firebase Security Rules**: User data isolation
- **Encryption**: All data encrypted in transit and at rest
- **Authentication**: Required for all operations
- **User Isolation**: Users can only access their own data

## 🌐 Real-time Features

### Live Data Flow
```
User Action → Firebase → Real-time Stream → UI Update
     ↓           ↓              ↓            ↓
   Send Message → Firestore → Live Stream → Message Appears
   Upload Doc → Storage → Live Stream → Doc Appears
   Search Flight → API → Live Stream → Results Update
```

### Real-time Capabilities
- ✅ **Live Flight Data**: Real-time API integration
- ✅ **Live Document Sync**: Instant cloud synchronization
- ✅ **Live Chat**: Real-time messaging
- ✅ **Live User Status**: Online/offline indicators
- ✅ **Live Notifications**: Instant push alerts

## 📊 Performance

- **Fast Loading**: Sub-second response times
- **Offline Support**: Works without internet
- **Efficient Caching**: Smart local storage
- **Scalable**: Handles thousands of users
- **Cross-platform**: Consistent experience

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team**: For the amazing framework
- **Firebase Team**: For the real-time backend services
- **Aviation Stack**: For flight data API
- **Material Design**: For the beautiful UI components

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/airway_ally/issues)
- **Documentation**: [Wiki](https://github.com/yourusername/airway_ally/wiki)
- **Email**: support@airwayally.com

## 🚀 Deployment

### App Store Deployment
1. Build iOS app: `flutter build ios --release`
2. Archive in Xcode
3. Upload to App Store Connect

### Google Play Deployment
1. Build Android app: `flutter build appbundle --release`
2. Upload to Google Play Console

### Web Deployment
1. Build web app: `flutter build web --release`
2. Deploy to Firebase Hosting or any web hosting service

---

**Made with ❤️ for travelers worldwide**

*Airway Ally - Your Personal Travel Assistant* ✈️
