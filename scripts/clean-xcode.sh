#!/usr/bin/env bash

# clean-xcode.sh
#
# This script removes various Xcode cache and derived data directories to
# free up disk space and resolve common build issues. It also deletes
# unavailable simulators using `xcrun simctl`.
#
# Usage: Run this script from any location. It will operate on standard
# Xcode data paths under the current user’s home directory.

# Remove Xcode derived data (build artifacts, indexes, etc.)
rm -rf "${HOME}/Library/Developer/Xcode/DerivedData"

# Remove device support files for iOS (usually contains symbol files)
rm -rf "${HOME}/Library/Developer/Xcode/iOS DeviceSupport"

# Remove device support files for watchOS
rm -rf "${HOME}/Library/Developer/Xcode/watchOS DeviceSupport"

# Clear simulator cache data
rm -rf "${HOME}/Library/Developer/CoreSimulator/Caches"

# Remove Xcode-specific caches
rm -rf "${HOME}/Library/Caches/com.apple.dt.Xcode"

# Delete unavailable simulators to clean up simctl state
xcrun simctl delete unavailable
