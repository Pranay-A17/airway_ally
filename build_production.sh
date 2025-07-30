#!/bin/bash

# Airway Ally Production Build Script
# This script builds the app for production deployment

echo "🚀 Building Airway Ally for Production..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Get Flutter version
FLUTTER_VERSION=$(flutter --version | head -n 1)
print_status "Using $FLUTTER_VERSION"

# Clean previous builds
print_status "Cleaning previous builds..."
flutter clean

# Get dependencies
print_status "Getting dependencies..."
flutter pub get

# Run tests
print_status "Running tests..."
flutter test

# Build for different platforms
echo ""
print_status "Building for different platforms..."

# Build for iOS
print_status "Building for iOS..."
flutter build ios --release --no-codesign

if [ $? -eq 0 ]; then
    print_success "iOS build completed successfully!"
else
    print_error "iOS build failed!"
fi

# Build for Android
print_status "Building for Android..."
flutter build apk --release

if [ $? -eq 0 ]; then
    print_success "Android build completed successfully!"
else
    print_error "Android build failed!"
fi

# Build for Web
print_status "Building for Web..."
flutter build web --release

if [ $? -eq 0 ]; then
    print_success "Web build completed successfully!"
else
    print_error "Web build failed!"
fi

# Create deployment package
echo ""
print_status "Creating deployment package..."

# Create deployment directory
DEPLOY_DIR="deployment_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$DEPLOY_DIR"

# Copy builds to deployment directory
if [ -d "build/ios/archive" ]; then
    cp -r build/ios/archive "$DEPLOY_DIR/ios"
    print_success "iOS build copied to $DEPLOY_DIR/ios"
fi

if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    cp build/app/outputs/flutter-apk/app-release.apk "$DEPLOY_DIR/airway_ally.apk"
    print_success "Android APK copied to $DEPLOY_DIR/airway_ally.apk"
fi

if [ -d "build/web" ]; then
    cp -r build/web "$DEPLOY_DIR/web"
    print_success "Web build copied to $DEPLOY_DIR/web"
fi

# Create README for deployment
cat > "$DEPLOY_DIR/README.md" << EOF
# Airway Ally - Production Build

## Build Information
- Build Date: $(date)
- Flutter Version: $FLUTTER_VERSION
- App Version: 1.0.0

## Deployment Files

### iOS
- Location: \`ios/\`
- Instructions: Open in Xcode and archive for App Store

### Android
- File: \`airway_ally.apk\`
- Instructions: Install directly on Android devices

### Web
- Location: \`web/\`
- Instructions: Deploy to any web server

## Installation Instructions

### For Friends & Family Testing

#### Android Users:
1. Download \`airway_ally.apk\`
2. Enable "Install from Unknown Sources" in Settings
3. Install the APK file
4. Open Airway Ally app

#### iOS Users:
1. Open the iOS project in Xcode
2. Connect your device
3. Build and run on device
4. Trust the developer certificate in Settings

#### Web Users:
1. Deploy the \`web/\` folder to any web server
2. Share the URL with testers

## Features Available
- ✅ Real-time flight tracking
- ✅ Airport guides and information
- ✅ Travel assistance features
- ✅ User authentication
- ✅ Cross-platform support

## Support
For issues or questions, contact the development team.
EOF

print_success "Deployment package created in: $DEPLOY_DIR"

# Show file sizes
echo ""
print_status "Build Summary:"
if [ -f "$DEPLOY_DIR/airway_ally.apk" ]; then
    APK_SIZE=$(du -h "$DEPLOY_DIR/airway_ally.apk" | cut -f1)
    echo "📱 Android APK: $APK_SIZE"
fi

if [ -d "$DEPLOY_DIR/web" ]; then
    WEB_SIZE=$(du -sh "$DEPLOY_DIR/web" | cut -f1)
    echo "🌐 Web Build: $WEB_SIZE"
fi

echo ""
print_success "🎉 Production build completed successfully!"
print_status "Deployment files are ready in: $DEPLOY_DIR"
print_status "Share the deployment folder with your friends and family for testing!" 