#!/usr/bin/env bash

# Install Chrome
mkdir -p /opt/render/chrome
cd /opt/render/chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt-get update
apt-get install -y ./google-chrome-stable_current_amd64.deb

# Install ChromeDriver
CHROME_DRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)
wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P /opt/render/chromedriver/
unzip /opt/render/chromedriver/chromedriver_linux64.zip -d /opt/render/chromedriver/
rm /opt/render/chromedriver/chromedriver_linux64.zip
mv /opt/render/chromedriver/chromedriver /opt/render/chrome/
chmod 0755 /opt/render/chrome/chromedriver

# Install Python dependencies
pip install -r requirements.txt
