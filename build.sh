#!/bin/bash

echo "--- CLONING FLUTTER ---"
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

export PATH="$PATH:`pwd`/flutter/bin"

echo "--- PREPARING ---"
flutter config --enable-web

echo "--- BUILDING ---"
# Kita gunakan perintah paling dasar agar tidak ada error option
flutter build web --release

echo "--- CHECKING OUTPUT ---"
if [ -d "build/web" ]; then
  echo "SUCCESS: build/web directory exists."
else
  echo "ERROR: build/web directory NOT FOUND."
  exit 1
fi
