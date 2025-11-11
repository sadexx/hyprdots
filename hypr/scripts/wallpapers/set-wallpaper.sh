#!/bin/bash
set -euo pipefail

WALL_DIR="$HOME/.config/wallpapers"

if [ ! -d "$WALL_DIR" ]; then
	echo "Cannot find directory with wallpapers: $WALL_DIR"
	exit 1
fi

FILE_LIST=$(find "$WALL_DIR" -type f \( -iname "*.png" -o -iname "*.jpg" \) -print)
SELECTED_NAME=$(echo "$FILE_LIST" | xargs -n1 basename | wofi --dmenu --prompt "Select wallpaper")

[ -z "$SELECTED_NAME" ] && exit 0

WALL=""
for file in $FILE_LIST; do
	[ "$(basename "$file")" = "$SELECTED_NAME" ] && WALL="$file" && break
done

[ -z "$WALL" ] && { echo "ERROR: Selected file not found!" >&2; exit 1; }

echo "Setting wallpaper: $SELECTED_NAME"

hyprctl hyprpaper unload all
hyprctl hyprpaper preload "$WALL"
hyprctl hyprpaper wallpaper ",$WALL"

echo "Wallpaper set successfully"

if command -v wal >/dev/null 2>&1; then
	echo "Applying pywal colors..."
	wal -i "$WALL"
	echo "Pywal applied successfully"

	export PATH="$HOME/.local/bin:$PATH:/usr/local/bin"

	if command -v pywalfox >/dev/null 2>&1; then
		echo "Updating pywalfox..."
		pywalfox update &
	else
		echo "Pywalfox not found in PATH"
	fi

	MAKO_SCRIPT="$HOME/.config/mako/update-colors.sh"
	if [ -x "$MAKO_SCRIPT" ]; then
		echo "Updating mako colors..."
		bash "$MAKO_SCRIPT" &
	else
		echo "Mako update script not found or not executable: $MAKO_SCRIPT"
	fi

	KEYBOARD_SCRIPT="$HOME/.config/keyboard/set-color-keyboard.sh"
	if [ -x "$KEYBOARD_SCRIPT" ]; then
		echo "Updating keyboard colors..."
		bash "$KEYBOARD_SCRIPT" &
	else
		echo "Keyboard color script not found or not executable: $KEYBOARD_SCRIPT"
	fi
	
	wait
else
	echo "Pywal not installed, skipping"
fi

echo "All done!"
