# Verbose printing with both, +10,000 lines of stuff per file
# Only really needs to be use when there are release build issues
# Build APK release
flutter build apk -v > ./logs/android_apk_build_log.txt 2>&1
# Build AAB release
flutter build aab -v > ./logs/android_aab_build_log.txt 2>&1