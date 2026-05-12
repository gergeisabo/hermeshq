#!/usr/bin/env bash
set -e

# Generate a minimal 1024x1024 icon for HermesHQ
# This produces a purple gradient square with "HQ" text
# Requires: convert (ImageMagick)

SIZE=1024
OUT="assets/icon.png"

if command -v convert &>/dev/null; then
  convert -size ${SIZE}x${SIZE} \
    -define gradient:direction=south-east \
    gradient:'#5B4FCF'-'#372E80' \
    -gravity center \
    -fill white -font Helvetica-Bold -pointsize 400 \
    -annotate 0 'HQ' \
    "$OUT"
  echo "✓ Icon generated: $OUT"
else
  echo "⚠ ImageMagick not available. Add a 1024x1024 PNG to assets/icon.png"
fi
