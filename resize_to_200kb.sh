#!/bin/bash

# Set the target folder (adjust if needed)
FOLDER="/Volumes/work/g_EResources/06_Projects/ORD_RDM/RDM_Personnel/C_NUNEZ/PROJECT_MATERIALS/Project_Avatars /physics_simulations"

# Target size in bytes (200 KiB)
TARGET_SIZE=204800

# Temporary output folder (optional: change if needed)
OUT_FOLDER="$FOLDER/resized"
mkdir -p "$OUT_FOLDER"

# Loop through all jpg/jpeg files
find "$FOLDER" -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) | while IFS= read -r file; do
    filename=$(basename "$file")
    outfile="$OUT_FOLDER/$filename"

    echo "Processing $filename..."

    # Start with lowest quality
    QUALITY="low"

    # Try converting with low quality first
    sips -s format jpeg -s formatOptions $QUALITY "$file" --out "$outfile"

    # Check output size
    size=$(stat -f%z "$outfile")
    
    # If still too large, overwrite with medium or high compression
    if [ "$size" -gt "$TARGET_SIZE" ]; then
        echo "File too large ($size bytes). Trying medium compression..."
        QUALITY="normal"
        sips -s format jpeg -s formatOptions $QUALITY "$file" --out "$outfile"
        size=$(stat -f%z "$outfile")
    fi

    if [ "$size" -gt "$TARGET_SIZE" ]; then
        echo "File still too large ($size bytes). Trying high compression..."
        QUALITY="high"
        sips -s format jpeg -s formatOptions $QUALITY "$file" --out "$outfile"
        size=$(stat -f%z "$outfile")
    fi

    echo "Final size: $size bytes"
done

echo "✅ All images processed. Output saved to: $OUT_FOLDER"
