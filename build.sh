#!/bin/bash

# 1. Clone Flutter SDK jika belum ada
if [ ! -d "flutter" ]; then
  git clone https://github.com/flutter/flutter.git -b stable
fi

# 2. Masukkan ke PATH agar bisa dipanggil
export PATH="$PATH:`pwd`/flutter/bin"

# 3. Jalankan build
flutter doctor
flutter build web
