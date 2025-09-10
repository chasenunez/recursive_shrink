# JPEG Resizer Script

A macOS-compatible Bash script that compresses `.jpg` and `.jpeg` images to ensure they are **less than 200 KiB**, using both native and external tools.

## Description

This script:

* Recursively finds all `.jpg` / `.jpeg` images in a specified folder.
* Tries compressing images using macOS’s built-in `sips` tool.
* If that fails, it uses **ImageMagick** to iteratively reduce image quality and resolution until the file size is **strictly under 200 KiB**.
* Saves all resized/compressed images in a separate `resized/` folder, preserving your original files.

## Requirements

* **macOS**
* **Bash**
* [**ImageMagick**](https://imagemagick.org/) (for fallback compression)

### Install ImageMagick (if not already installed)

```bash
brew install imagemagick
```

## Usage

### 1. Edit the Script

Open the script and set the correct folder path in the `FOLDER` variable:

```bash
FOLDER="/your/path/to/images"
```

### 2. Run the Script

```bash
chmod +x resize_images.sh
./resize_images.sh
```

## Output

* Processed images are saved in a subfolder called `resized` inside your original folder:

  ```
  /your/path/to/images/resized/
  ```

* Each image is guaranteed to be **< 200 KiB**.

* Original images are **not modified**.

## Compression Strategy

The script uses a **two-step strategy**:

1. **Primary Compression with `sips`**:

   * Tries `low`, then `normal`, then `high` quality settings.

2. **Fallback Compression with `ImageMagick`**:

   * Starts at 90% quality and 100% scale.
   * Gradually reduces **quality** and then **scale** until the file is under 200 KiB.

This ensures the **best possible image quality** while keeping file sizes within the limit.

## Limitations

* Only supports `.jpg` and `.jpeg` files (case-insensitive).
* Currently supports macOS only (due to `sips` and `stat -f%z` usage).
* May reduce image quality or dimensions significantly if original images are large.

## License

This script is free to use and modify. No warranties provided — use at your own risk.
