#!/bin/bash

# Environment Setup Script for Airway Ally
echo "🔧 Setting up environment variables for Airway Ally..."

# Check if .env file exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    cp env.example .env
    echo "✅ .env file created!"
else
    echo "ℹ️  .env file already exists"
fi

echo ""
echo "📋 Next steps:"
echo "1. Edit .env file with your actual API keys"
echo "2. Get Aviation Stack API key from: https://aviationstack.com/"
echo "3. Optional: Update Firebase keys if needed"
echo ""
echo "🔐 Your .env file should look like this:"
echo "AVIATION_STACK_API_KEY=your_actual_key_here"
echo "FIREBASE_API_KEY=your_firebase_key_here"
echo "FLUTTER_ENV=development"
echo ""
echo "⚠️  Remember: Never commit .env file to version control!"
echo "✅ Add .env to your .gitignore file" 