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
echo "📱 Running Airway Ally on Android..."

# Run the app
flutter run -d android 