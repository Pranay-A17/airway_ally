#!/bin/bash

echo "🚀 Starting Airway Ally on Android..."

# Check if Android emulator is running
if ! flutter devices | grep -q "android"; then
    echo "📱 Starting Android emulator..."
    flutter emulators --launch Medium_Phone_API_36.0
    sleep 15
fi

# Wait for emulator to be ready
echo "⏳ Waiting for Android emulator to be ready..."
while ! flutter devices | grep -q "android"; do
    sleep 2
done

echo "✅ Android emulator ready!"

# Get the Android device ID
ANDROID_DEVICE=$(flutter devices | grep "android" | head -1 | awk '{print $1}' | sed 's/•//g' | xargs)
echo "📱 Found Android device: $ANDROID_DEVICE"

if [ -z "$ANDROID_DEVICE" ]; then
    echo "❌ No Android device found. Available devices:"
    flutter devices
    exit 1
fi

echo "📱 Running Airway Ally on Android device: $ANDROID_DEVICE..."

# Run the app
flutter run -d "$ANDROID_DEVICE" 