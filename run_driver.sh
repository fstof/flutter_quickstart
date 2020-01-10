#!/bin/bash
emulator @Pixel_3_XL_API_29 > /dev/null &
sleep 10

flutter run --observatory-port 8888 --disable-service-auth-codes test_driver/app.dart > /dev/null &

dart test_driver/app_test_ready.dart http://127.0.0.1:8888 > /dev/null
sleep 5

dart test_driver/app_test.dart http://127.0.0.1:8888

adb devices | grep emulator | cut -f1 | while read line; do adb -s $line emu kill; done
