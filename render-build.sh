#!/bin/bash

# Set the directory where Chrome will be installed
CHROME_DIR="$HOME/chrome"
CHROMEDRIVER_DIR="$HOME/chromedriver"

# Create directories
mkdir -p $CHROME_DIR $CHROMEDRIVER_DIR

# Download and install Chrome
if [ $RENDER ]; then
    echo "Installing Chrome for Render.com"
    wget -q -O $CHROME_DIR/chrome-linux.zip https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    unzip -q $CHROME_DIR/chrome-linux.zip -d $CHROME_DIR
    ln -s $CHROME_DIR/google-chrome /usr/local/bin/google-chrome
fi

# Download and install ChromeDriver
if [ $RENDER ]; then
    echo "Installing ChromeDriver for Render.com"
    CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d '.' -f 1)
    CHROMEDRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION")
    wget -N "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" -P $CHROMEDRIVER_DIR
    unzip $CHROMEDRIVER_DIR/chromedriver_linux64.zip -d $CHROMEDRIVER_DIR
    ln -s $CHROMEDRIVER_DIR/chromedriver /usr/local/bin/chromedriver
    chmod +x $CHROMEDRIVER_DIR/chromedriver
fi
