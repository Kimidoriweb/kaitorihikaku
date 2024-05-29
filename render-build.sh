#!/bin/bash

# Install Chrome
if [ $RENDER ]; then
    echo "Installing Chrome for Render.com"
    curl -sSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o google-chrome-stable_current_amd64.deb
    dpkg -i google-chrome-stable_current_amd64.deb || apt-get -fy install
    apt-get install -y libxss1 libappindicator1 libindicator7
    rm google-chrome-stable_current_amd64.deb
else
    echo "Skipping Chrome installation since it's not running on Render.com"
fi

# Install chromedriver
if [ $RENDER ]; then
    echo "Installing ChromeDriver for Render.com"
    CHROME_VERSION=$(google-chrome --version | awk '{print $3}')
    CHROMEDRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE")
    wget -N "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
    unzip chromedriver_linux64.zip
    mv -f chromedriver /usr/local/bin/chromedriver
    chmod +x /usr/local/bin/chromedriver
    rm chromedriver_linux64.zip
else
    echo "Skipping ChromeDriver installation since it's not running on Render.com"
fi
