#!/bin/bash

# Set the target folder (adjust if needed)
FOLDER="/Volumes/work/g_EResources/06_Projects/ORD_RDM/RDM_Personnel/C_NUNEZ/PROJECT_MATERIALS/Project_Avatars /physics_simulations"

# Target size in bytes (200 KiB)
TARGET_SIZE=204800

# Output folder
OUT_FOLDER="$FOLDER/resized"
mkdir -p "$OUT_FOLDER"

# Loop through all jpg/jpeg files
find "$FOLDER" -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) | while IFS= read -r file; do
    filename=$(basename "$file")
    outfile="$OUT_FOLDER/$filename"

    echo "🖼️ Processing $filename..."

    # Try sips first with low → normal → high
    for QUALITY in low normal high; do
        sips -s format jpeg -s formatOptions "$QUALITY" "$file" --out "$outfile" >/dev/null 2>&1
        size=$(stat -f%z "$outfile")

        echo "🔍 Tried sips - $QUALITY quality → Size: $size bytes"

        if [ "$size" -lt "$TARGET_SIZE" ]; then
            echo "✅ Success with sips: $size bytes"
            break
        fi
    done

    # If still too large, use ImageMagick fallback
    if [ "$size" -gt "$TARGET_SIZE" ]; then
        echo "⚠️ Still too large after sips. Using ImageMagick..."

        # Initial quality and scale
        quality=90
        scale=100

        # Work on a temp file
        temp_file="$outfile"

        # Loop: reduce quality and scale if needed
        while [ "$size" -gt "$TARGET_SIZE" ] && [ "$quality" -ge 10 ]; do
            convert "$file" -resize "${scale}%" -quality "$quality" "$temp_file"
            size=$(stat -f%z "$temp_file")

            echo "↘️ convert: quality=$quality%, scale=${scale}% → $size bytes"

            # Reduce quality first, then scale if needed
            if [ "$quality" -gt 30 ]; then
                quality=$((quality - 10))
            else
                scale=$((scale - 10))
            fi
        done

        if [ "$size" -lt "$TARGET_SIZE" ]; then
            echo "✅ Compressed with ImageMagick: $size bytes"
        else
            echo "❌ Could not reduce $filename below $TARGET_SIZE bytes"
        fi
    fi

    echo "--------------------------"
done

echo "✅ All images processed. Output saved to: $OUT_FOLDER"
