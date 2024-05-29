#!/bin/bash

# Install Chrome
if [ $RENDER ]; then
    echo "Installing Chrome for Render.com"
    mkdir -p /usr/local/share/chrome
    wget -q -O /usr/local/share/chrome/chrome-linux.zip https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    unzip -q /usr/local/share/chrome/chrome-linux.zip -d /usr/local/share/chrome/
    ln -s /usr/local/share/chrome/google-chrome /usr/bin/google-chrome
fi

# Install ChromeDriver
if [ $RENDER ]; then
    echo "Installing ChromeDriver for Render.com"
    CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d '.' -f 1)
    CHROMEDRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION")
    wget -N "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
    unzip chromedriver_linux64.zip -d /usr/local/bin/
    rm chromedriver_linux64.zip
    chmod +x /usr/local/bin/chromedriver
fi
