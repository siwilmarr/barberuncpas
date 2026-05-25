#!/bin/bash

echo "--- MENGINSTAL FLUTTER ---"
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

export PATH="$PATH:`pwd`/flutter/bin"

echo "--- KONFIGURASI ---"
flutter config --enable-web
flutter doctor

echo "--- MEMULAI BUILD ---"
# Pastikan menggunakan --output agar folder hasil jelas
flutter build web --release --web-renderer html

echo "--- VERIFIKASI HASIL ---"
if [ -d "build/web" ]; then
  echo "Folder build/web ditemukan!"
  ls build/web
else
  echo "ERROR: Folder build/web TIDAK DITEMUKAN!"
  exit 1
fi

echo "--- BUILD SELESAI ---"
