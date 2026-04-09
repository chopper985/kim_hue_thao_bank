#!/bin/bash

set -e # Stop on error

echo "🔧 Setting up Android signing configuration..."

missing_env=0
if [ -z "$ANDROID_KEYSTORE_BASE64" ]; then
    echo "❌ Error: ANDROID_KEYSTORE_BASE64 is not set"
    missing_env=1
fi
if [ -z "$ANDROID_KEYSTORE_PASSWORD" ]; then
    echo "❌ Error: ANDROID_KEYSTORE_PASSWORD is not set"
    missing_env=1
fi
if [ -z "$ANDROID_KEY_PASSWORD" ]; then
    echo "❌ Error: ANDROID_KEY_PASSWORD is not set"
    missing_env=1
fi
if [ -z "$ANDROID_KEY_ALIAS" ]; then
    echo "❌ Error: ANDROID_KEY_ALIAS is not set"
    missing_env=1
fi
if [ "$missing_env" -ne 0 ]; then
    exit 1
fi

# Decode keystore from base64
echo "📦 Decoding keystore..."
echo "$ANDROID_KEYSTORE_BASE64" | base64 -d > android/app/preny.jks

# Verify keystore was created
if [ ! -f android/app/preny.jks ]; then
    echo "❌ Error: Keystore file was not created"
    exit 1
fi

echo "✅ Keystore decoded successfully"

# Create key.properties file
echo "📝 Creating key.properties..."
cat > android/key.properties << EOF
storePassword=$ANDROID_KEYSTORE_PASSWORD
keyPassword=$ANDROID_KEY_PASSWORD
keyAlias=$ANDROID_KEY_ALIAS
storeFile=app/preny.jks
EOF

echo "✅ key.properties created successfully"
echo "✅ Android signing setup completed!"
