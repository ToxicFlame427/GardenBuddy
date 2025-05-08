# Verbose printing, +10,000 lines of stuff per file
# Only really needs to be use when there are release build issues
# Build iOS release
flutter build ios -v > ./logs/ios_build_log.txt 2>&1