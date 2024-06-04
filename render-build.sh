#!/bin/bash

# Set the directory where Chrome will be installed
CHROME_DIR="$HOME/chrome"
CHROMEDRIVER_DIR="$HOME/chromedriver"

# Create directories
mkdir -p $CHROME_DIR $CHROMEDRIVER_DIR

# Download and install Chrome
if [ $RENDER ]; then
    echo "Installing Chrome for Render.com"
    wget -q -O $CHROME_DIR/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    ar x $CHROME_DIR/google-chrome-stable_current_amd64.deb -C $CHROME_DIR
    tar -xvf $CHROME_DIR/data.tar.xz -C $CHROME_DIR
    mv $CHROME_DIR/opt/google/chrome/* $CHROME_DIR/
    rm -rf $CHROME_DIR/opt
    rm -f $CHROME_DIR/google-chrome-stable_current_amd64.deb
    rm -f $CHROME_DIR/data.tar.xz
fi

# Verify installation of Chrome
if [ -f "$CHROME_DIR/google-chrome" ]; then
    echo "Chrome installed successfully"
else
    echo "Chrome installation failed"
    exit 1
fi

# Download and install ChromeDriver
if [ $RENDER ]; then
    echo "Installing ChromeDriver for Render.com"
    CHROME_VERSION=$($CHROME_DIR/google-chrome --version | awk '{print $3}' | cut -d '.' -f 1)
    CHROMEDRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION")
    wget -N "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" -P $CHROMEDRIVER_DIR
    unzip $CHROMEDRIVER_DIR/chromedriver_linux64.zip -d $CHROMEDRIVER_DIR
    chmod +x $CHROMEDRIVER_DIR/chromedriver
    rm $CHROMEDRIVER_DIR/chromedriver_linux64.zip
fi

# Verify installation of ChromeDriver
if [ -f "$CHROMEDRIVER_DIR/chromedriver" ]; then
    echo "ChromeDriver installed successfully"
else
    echo "ChromeDriver installation failed"
    exit 1
fi
