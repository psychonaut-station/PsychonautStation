#!/bin/bash
set -e
set -x

7z a -tzip "/home/tgstation-server/websites/cdn/tg/tgstation.zip" $1/tgstation.rsc -mx9 -mmt2

INPUT_FILE="$1/icons/ui/achievements/achievements.dmi"
OUTPUT_DIR="/home/tgstation-server/websites/cdn/tg/achievements"

CACHE_DIR="$(dirname "$0")/achievements"

if [ -d "$CACHE_DIR" ]; then
    rm -rf "$CACHE_DIR"
fi

"$1/tools/bootstrap/python" -m dmi.prepare_achievements "$INPUT_FILE" "$CACHE_DIR"

if [ -d "$OUTPUT_DIR" ]; then
    rm -rf "$OUTPUT_DIR"
fi

mkdir -p "$OUTPUT_DIR"

mv "$CACHE_DIR"/* "$OUTPUT_DIR"/

rm -rf "$CACHE_DIR"
