#!/usr/bin/env bash
# Reads app.config, prepares www/ (html / zip / image / video / audio / text) and writes gradle properties.
set -e

conf() { grep -E "^$1=" app.config 2>/dev/null | head -1 | cut -d= -f2- | sed 's/\r$//' || true; }

APP_NAME="$(conf APP_NAME)"
PACKAGE_ID="$(conf PACKAGE_ID)"
VERSION="$(conf VERSION)"
START_URL="$(conf START_URL)"

mkdir -p www

if [ -z "$START_URL" ]; then
  # 1) zip -> unzip into www
  if [ ! -f www/index.html ]; then
    for z in www/*.zip; do
      [ -e "$z" ] || continue
      echo "Unzipping $z"
      unzip -o -q "$z" -d www
      rm -f "$z"
      break
    done
  fi

  # 2) index.html inside a sub-folder -> move its content to www root
  if [ ! -f www/index.html ]; then
    found="$(find www -name index.html | head -1 || true)"
    if [ -n "$found" ]; then
      dir="$(dirname "$found")"
      echo "Using $dir as app folder"
      cp -r "$dir"/. www/
    fi
  fi

  # 3) single media / text file -> generate a small viewer page
  if [ ! -f www/index.html ]; then
    f="$(find www -maxdepth 1 -type f ! -name '.gitkeep' | head -1 || true)"
    if [ -z "$f" ]; then
      echo "ERROR: www folder khali. www/index.html (leda zip/image/video) pettandi." ; exit 1
    fi
    name="$(basename "$f")"
    ext="$(echo "${name##*.}" | tr 'A-Z' 'a-z')"
    head='<!DOCTYPE html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><style>body{margin:0;background:#000;display:flex;align-items:center;justify-content:center;min-height:100vh}img,video{max-width:100%;max-height:100vh}audio{width:90%}pre{color:#eee;background:#111;white-space:pre-wrap;padding:12px;margin:0;width:100%;box-sizing:border-box;min-height:100vh}</style></head><body>'
    case "$ext" in
      png|jpg|jpeg|gif|webp|bmp|svg) echo "$head<img src=\"$name\"></body></html>" > www/index.html ;;
      mp4|webm|3gp|m4v)               echo "$head<video src=\"$name\" controls autoplay playsinline></video></body></html>" > www/index.html ;;
      mp3|wav|ogg|m4a|aac)            echo "$head<audio src=\"$name\" controls autoplay></audio></body></html>" > www/index.html ;;
      txt|md|log|csv)
        { echo "$head<pre>"; sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' "$f"; echo "</pre></body></html>"; } > www/index.html ;;
      pdf) echo "ERROR: PDF direct support ledu (Android WebView PDF chupinchadu). PDF ni HTML ga marchi pettandi." ; exit 1 ;;
      *)   echo "ERROR: .$ext file type support ledu. www/index.html pettandi." ; exit 1 ;;
    esac
    echo "Generated viewer for $name"
  fi
fi

# optional custom icon
if [ -f icon.png ]; then
  cp icon.png app/src/main/res/mipmap-xxhdpi/ic_launcher.png
  echo "Custom icon used"
fi

{
  echo "appName=${APP_NAME:-My App}"
  echo "packageId=${PACKAGE_ID:-com.webapp.myapp}"
  echo "versionName=${VERSION:-1.0}"
  echo "versionCode=${GITHUB_RUN_NUMBER:-1}"
  echo "startUrl=${START_URL}"
} >> gradle.properties

echo "Prepared: ${APP_NAME:-My App} (${PACKAGE_ID:-com.webapp.myapp})"
