#!/bin/bash
set -e

APP_NAME="Geometry Dash.app"
APP_PATH="/Applications/$APP_NAME"
DOWNLOADS_DIR="$HOME/Downloads"
ZIP_PATH="$DOWNLOADS_DIR/Geometry-Dash.zip"
URL="https://github.com/RedZebra123H/geometrydash/releases/download/gd/Geometry-Dash.zip"

if [ -d "$APP_PATH" ]; then
  BUTTON=$(osascript -e 'button returned of (display dialog "'"$APP_NAME"' is already installed. Do you want to update it?" buttons {"No","Yes"} default button "Yes")')
  if [ "$BUTTON" = "No" ]; then
    echo "Update cancelled. Exiting."
    exit 0
  fi
  echo "Removing existing $APP_NAME..."
  rm -rf "$APP_PATH"
fi

echo "Downloading Geometry Dash..."
curl -L --progress-bar "$URL" -o "$ZIP_PATH"

echo "Unzipping..."
cd "$DOWNLOADS_DIR"
unzip -o "$ZIP_PATH"

if [ ! -d "$DOWNLOADS_DIR/$APP_NAME" ]; then
  echo "$APP_NAME not found after unzipping."
  exit 1
fi

echo "Installing to Applications..."
mv "$DOWNLOADS_DIR/$APP_NAME" "$APP_PATH"

echo "Cleaning up..."
rm -f "$ZIP_PATH"

echo "Removing quarantine attributes..."
xattr -r -c "$APP_PATH"

echo "Installation complete."

BUTTON=$(osascript -e 'button returned of (display dialog "'"$APP_NAME"' has been installed.\n\nDo you want to open it now?" buttons {"No","Yes"} default button "Yes")')
if [ "$BUTTON" = "Yes" ]; then
  open "$APP_PATH"
fi
