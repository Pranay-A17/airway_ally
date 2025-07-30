#!/bin/bash

echo "🚀 Deploying Airway Ally for Testing"
echo "====================================="

# Build the web version
echo "📦 Building web version..."
flutter build web --release

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "🌐 Your app is ready for testing!"
    echo ""
    echo "📋 Sharing Options:"
    echo "1. Upload to Firebase Hosting (recommended):"
    echo "   - Install Firebase CLI: npm install -g firebase-tools"
    echo "   - Login: firebase login"
    echo "   - Initialize: firebase init hosting"
    echo "   - Deploy: firebase deploy"
    echo ""
    echo "2. Upload to Netlify:"
    echo "   - Drag the 'build/web' folder to netlify.com"
    echo ""
    echo "3. Upload to GitHub Pages:"
    echo "   - Push to GitHub and enable Pages in repository settings"
    echo ""
    echo "4. Local testing:"
    echo "   - Run: python3 -m http.server 8000"
    echo "   - Visit: http://localhost:8000"
    echo ""
    echo "📁 Build files are in: build/web/"
    echo "🔗 Share the deployed URL with your friends!"
else
    echo "❌ Build failed. Please check the errors above."
fi 