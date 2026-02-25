#!/bin/bash
# Уменьшает все PNG в заданной папке до 128x128 px (вписывает в 128x128, добавляет прозрачные поля при необходимости).
# Использование: ./resize-png.sh [папка]
# Требуется: ImageMagick (sudo apt install imagemagick)

set -e
DIR="${1:-.}"
[ -d "$DIR" ] || { echo "Папка не найдена: $DIR"; exit 1; }

if command -v magick &>/dev/null; then
  RESIZE='magick'
elif command -v convert &>/dev/null; then
  RESIZE='convert'
else
  echo "Установите ImageMagick: sudo apt install imagemagick"
  exit 1
fi

count=0
for f in "$DIR"/*.png; do
  [ -f "$f" ] || continue
  tmp=$(mktemp --suffix=.png)
  "$RESIZE" "$f" -resize 128x128 -gravity center -background none -extent 128x128 "$tmp" && mv "$tmp" "$f"
  echo "$f -> 128x128"
  count=$((count + 1))
done

echo "Готово: обработано файлов: $count"
