#!/bin/bash

# 1. Masuk ke folder project
echo "Starting Build Process..."

# 2. Download Flutter SDK (Versi Ringan)
if [ ! -d "flutter" ]; then
  echo "Downloading Flutter SDK..."
  git clone https://github.com/flutter/flutter.git -b stable --depth 1
fi

# 3. Masukkan Flutter ke PATH sistem Vercel
export PATH="$PATH:`pwd`/flutter/bin"

# 4. Aktifkan fitur Web
flutter config --enable-web

# 5. Jalankan Build (Menggunakan renderer HTML untuk kompatibilitas lebih baik)
echo "Building Flutter Web..."
flutter build web --release --web-renderer html

echo "Build Finished Successfully!"
