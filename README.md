## Photo Resizing Script

A simple Bash script to resize and compress `.jpg` / `.jpeg` images in a folder to ensure they are under **200 KiB** using macOS's built-in `sips` tool.

## Description

This script:

* Recursively finds all `.jpg` / `.jpeg` files in a specified folder.
* Attempts to reduce their file size to below **200 KiB**.
* Uses `sips` with increasing compression levels (`low` → `normal` → `high`).
* Saves the compressed images to a `resized/` subdirectory in the original folder.

---

## Requirements

* macOS (uses the native `sips` command)
* Bash

---

## Usage

### 1. Edit the script

Before running the script, update the `FOLDER` variable to point to your target directory:

```bash
FOLDER="<FILEPATH>"  # Replace <FILEPATH> with your actual image folder path
```

Example:

```bash
FOLDER="/Users/yourname/Pictures/to_compress"
```

### 2. Run the script

```bash
chmod +x resize_images.sh
./resize_images.sh
```

> The script creates a subfolder named `resized` inside your original image folder to store the processed images.

---

## Output

* Compressed `.jpg` / `.jpeg` files are saved to:

  ```
  <your folder>/resized/
  ```

* Original images are left untouched.

* Console output indicates the compression level used and final file sizes.

---

## Notes

* Compression levels used are based on `sips` presets:

  * `low`, `normal`, and `high` compression.
* If a file still exceeds 200 KiB after `high` compression, the script does not attempt further resizing (e.g., resolution reduction).
* `stat -f%z` is used to check file sizes; this is compatible with macOS.

---

## Limitations

* Only works on **macOS**.
* No resolution resizing — only JPEG compression is adjusted.
* Only processes `.jpg` / `.jpeg` files (case-insensitive).
* May overwrite files in the `resized/` folder if re-run.

---

## Suggestions

To improve the script in future versions:

* Add support for resolution scaling.
* Accept command-line arguments (e.g., target folder, size, output folder).
* Handle other image formats (e.g., PNG).
* Implement logging or error reporting.

---

## License

This script is free to use, modify, and distribute. No warranty provided.