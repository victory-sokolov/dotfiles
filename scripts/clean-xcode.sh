#!/usr/bin/env bash

# clean-xcode.sh
#
# Enhanced script: shows sizes of common Xcode caches / derived-data,
# prints a total, and prompts the user before removing anything.

set -euo pipefail

TARGETS=(
	"${HOME}/Library/Developer/Xcode/DerivedData"
	"${HOME}/Library/Developer/Xcode/iOS DeviceSupport"
	"${HOME}/Library/Developer/Xcode/watchOS DeviceSupport"
	"${HOME}/Library/Developer/CoreSimulator/Caches"
	"${HOME}/Library/Caches/com.apple.dt.Xcode"
)

human_kb() {
	kb=${1:-0}
	if [ "$kb" -lt 1024 ]; then
		echo "${kb}K"
		return
	fi
	mb=$((kb/1024))
	if [ "$mb" -lt 1024 ]; then
		echo "${mb}M"
		return
	fi
	# show one decimal for GB
	gb=$(awk "BEGIN {printf \"%.1f\", ${mb}/1024}")
	echo "${gb}G"
}

total_kb=0
any_found=false

printf "%-66s %10s\n" "Path" "Size"
printf "%s\n" "$(printf '%.0s-' {1..80})"
for p in "${TARGETS[@]}"; do
	if [ -e "$p" ]; then
		kb=$(du -sk "$p" 2>/dev/null | awk '{print $1}')
		human=$(human_kb "$kb")
		printf "%-66s %10s\n" "$p" "$human"
		total_kb=$((total_kb + (kb + 0)))
		any_found=true
	else
		printf "%-66s %10s\n" "$p" "(missing)"
	fi
done

if ! $any_found; then
	echo "No Xcode-related directories found to evaluate. Exiting."
	exit 0
fi

human_total=$(human_kb "$total_kb")
printf "%s\n" "$(printf '%.0s-' {1..80})"
printf "%-66s %10s\n" "Total" "$human_total"

read -r -p "Delete all listed items? [y/N]: " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
	echo "Removing..."
	for p in "${TARGETS[@]}"; do
		if [ -e "$p" ]; then
			rm -rf "$p"
			echo "Removed: $p"
		fi
	done
	xcrun simctl delete unavailable || true
	echo "Cleanup finished."
else
	echo "Aborted: no files were removed."
fi
