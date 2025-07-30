# 🚀 Quick Start Guide - Airway Ally

## 📱 Running the App

### **Important:** Always run commands from the `airway_ally` directory!

```bash
cd "/Users/pranaydeeprakam/Airway Ally/airway_ally"
```

## 🎯 Quick Commands

### **Android App:**
```bash
# Option 1: Use the script (recommended)
./run_android.sh

# Option 2: Manual command
flutter run -d emulator-5554
```

### **iOS App:**
```bash
flutter run -d "iPhone 15 Pro Max"
```

### **Web App:**
```bash
flutter run -d chrome
```

### **All Platforms:**
```bash
# Run on all connected devices
flutter run -d all
```

## 📱 Available Devices

### **Android:**
- `emulator-5554` - Android emulator (recommended)

### **iOS:**
- `iPhone 15 Pro Max` - iOS simulator

### **Web:**
- `chrome` - Chrome browser

## 🔧 Troubleshooting

### **If Android emulator is not running:**
```bash
# Start Android emulator
flutter emulators --launch Medium_Phone_API_36.0

# Wait 15 seconds, then run:
flutter run -d android
```

### **If you get "No pubspec.yaml found":**
```bash
# Make sure you're in the correct directory
cd "/Users/pranaydeeprakam/Airway Ally/airway_ally"
pwd  # Should show: /Users/pranaydeeprakam/Airway Ally/airway_ally
```

### **If app doesn't start:**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run -d emulator-5554
```

## 🎮 Hot Reload

Once the app is running:
- Press `r` for hot reload
- Press `R` for hot restart
- Press `q` to quit

## 📊 App Features

### **✅ Working Features:**
- 🔐 User authentication
- 💬 Real-time chat
- ✈️ Flight tracking
- 📄 Document management
- 🏢 Airport guides
- 🔔 Push notifications
- 🏆 Badge system

### **📱 Platform Support:**
- ✅ iOS (iPhone/iPad)
- ✅ Android (Phone/Tablet)
- ✅ Web (Chrome/Safari)

## 🎉 Success!

Your Airway Ally app should now be running on the Android emulator!

**Next Steps:**
1. Test all features
2. Try on different platforms
3. Share with others for testing

---

**Need Help?** Check the detailed guides:
- `ANDROID_SETUP.md` - Complete Android setup
- `SHARING_GUIDE.md` - How to share the app
- `README.md` - Full project documentation 