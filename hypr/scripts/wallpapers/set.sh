#!/bin/bash
set -euo pipefail

WALL=$1
echo "setting $WALL as wallpaper"

swww img "$WALL" --transition-type simple --transition-fps 60

echo "set $WALL as wallpaper successfully"

if command -v wal >/dev/null 2>&1; then
	echo "Applying pywal colors..."
	wal -i "$WALL"
	echo "pywal applied successfully"
	"$HOME/.config/mako/update-colors.sh" &
	"$HOME/.config/keyboard/set-color-keyboard.sh" &
else
	echo "Pywal not installed, skipping"
fi
