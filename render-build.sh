#!/bin/bash

# Install Chrome
if [ $RENDER ]; then
    echo "Installing Chrome for Render.com"
    apt-get update
    apt-get install -y wget gnupg2
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
    apt-get update
    apt-get install -y google-chrome-stable
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
