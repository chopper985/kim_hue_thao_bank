#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="${1:-assets/icons}"
BACKUP_DIR="${2:-assets/icons-old}"
QUALITY="${QUALITY:-85}"
DRY_RUN="${DRY_RUN:-0}"

if ! command -v cwebp >/dev/null 2>&1; then
  echo "Error: cwebp is not installed. Install webp tools first."
  exit 1
fi

if [ ! -d "$SRC_DIR" ]; then
  echo "Error: source directory not found: $SRC_DIR"
  exit 1
fi

mkdir -p "$BACKUP_DIR"

converted_count=0
moved_count=0
skipped_count=0

while IFS= read -r -d '' png_file; do
  rel_path="${png_file#"$SRC_DIR"/}"
  webp_file="${png_file%.png}.webp"
  backup_file="$BACKUP_DIR/$rel_path"

  if [ "$DRY_RUN" = "1" ]; then
    if [ ! -f "$webp_file" ]; then
      echo "[dry-run] convert: $png_file -> $webp_file"
    else
      echo "[dry-run] skip convert (webp exists): $webp_file"
    fi
    echo "[dry-run] move png: $png_file -> $backup_file"
    continue
  fi

  if [ ! -f "$webp_file" ]; then
    tmp_webp="${webp_file}.tmp"
    cwebp -quiet -q "$QUALITY" "$png_file" -o "$tmp_webp"
    mv -f "$tmp_webp" "$webp_file"
    converted_count=$((converted_count + 1))
  else
    skipped_count=$((skipped_count + 1))
  fi

  mkdir -p "$(dirname "$backup_file")"
  mv -f "$png_file" "$backup_file"
  moved_count=$((moved_count + 1))
done < <(find "$SRC_DIR" -type f -name '*.png' -print0)

if [ "$DRY_RUN" = "1" ]; then
  echo "Dry run complete."
  exit 0
fi

echo "Done."
echo "Converted PNG -> WEBP: $converted_count"
echo "Moved original PNG to backup: $moved_count"
echo "Skipped convert (WEBP already existed): $skipped_count"
