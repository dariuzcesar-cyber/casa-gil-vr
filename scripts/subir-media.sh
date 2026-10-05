#!/usr/bin/env bash
# Sube los videos de portada (assets/render-casa-gil-*.mp4) a Cloudflare R2.
#   Uso:  scripts/subir-media.sh
#
# Los videos NO se sirven desde Cloudflare Pages porque Pages no soporta
# peticiones por rango (HTTP 206) y Safari/iPhone no reproduce video sin ellas.
# R2 sí las soporta.
#
# Requiere rclone y, en TU terminal (nunca en el repo ni en el chat):
#   export R2_ACCESS_KEY_ID="..."
#   export R2_SECRET_ACCESS_KEY="..."
set -euo pipefail

BUCKET="casa-la-parota-tiles"
ACCOUNT_ID="57350b337d100d70f6c38f9afec6bb0b"
PROYECTO="casa-gil"
ORIGEN="$(cd "$(dirname "$0")/.." && pwd)/assets"

: "${R2_ACCESS_KEY_ID:?Define R2_ACCESS_KEY_ID}"
: "${R2_SECRET_ACCESS_KEY:?Define R2_SECRET_ACCESS_KEY}"

export RCLONE_CONFIG_R2_TYPE=s3
export RCLONE_CONFIG_R2_PROVIDER=Cloudflare
export RCLONE_CONFIG_R2_ACCESS_KEY_ID="$R2_ACCESS_KEY_ID"
export RCLONE_CONFIG_R2_SECRET_ACCESS_KEY="$R2_SECRET_ACCESS_KEY"
export RCLONE_CONFIG_R2_ENDPOINT="https://${ACCOUNT_ID}.r2.cloudflarestorage.com"
export RCLONE_CONFIG_R2_ACL=private
export RCLONE_CONFIG_R2_NO_CHECK_BUCKET=true

# Subida desde la raíz del bucket (ver nota en subir-tiles.sh)
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/${PROYECTO}/media"
for f in "$ORIGEN"/render-casa-gil-*.mp4 "$ORIGEN"/render-casa-gil-poster.jpg; do
  [ -f "$f" ] && ln -s "$f" "$TMP/${PROYECTO}/media/$(basename "$f")"
done

rclone copy "$TMP" "R2:${BUCKET}" --copy-links --progress \
  --header-upload "Cache-Control: public, max-age=604800"

echo "Listo. Prueba: https://tiles.dariuzph.com/${PROYECTO}/media/render-casa-gil-720.mp4"
