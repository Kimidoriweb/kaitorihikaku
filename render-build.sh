#!/usr/bin/env bash

# Move to the root of the repository
cd "$(dirname "$0")"

# Ensure we are in the correct directory
echo "Current directory: $(pwd)"
echo "Listing files in the current directory:"
ls -la

if [ -f requirements.txt ]; then
    echo "Found requirements.txt in $(pwd)"
else
    echo "requirements.txt not found in $(pwd)"
    exit 1
fi

# Install Chrome
mkdir -p /opt/render/chrome
cd /opt/render/chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt-get update
apt-get install -y ./google-chrome-stable_current_amd64.deb

# Install ChromeDriver
CHROME_DRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)
wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P /opt/render/chromedriver/
unzip -o /opt/render/chromedriver/chromedriver_linux64.zip -d /opt/render/chromedriver/
rm /opt/render/chromedriver/chromedriver_linux64.zip
mv /opt/render/chromedriver/chromedriver /opt/render/chrome/
chmod 0755 /opt/render/chrome/chromedriver

# Go back to the root of the repository
cd "$(dirname "$0")"

# Check if requirements.txt exists
if [ -f requirements.txt ]; then
    echo "Installing Python dependencies"
    pip install -r requirements.txt
else
    echo "ERROR: requirements.txt not found."
    exit 1
fi
