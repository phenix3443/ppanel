#!/usr/bin/env bash
# Build the gateway binaries from the behavior-compatible source in
# phenix3443/ppanel-gateway. Replaces what used to be the upstream closed-source
# prebuilt binaries. See README.md.
#
# Usage:
#   ./build-gateway.sh [/path/to/ppanel-gateway]
# With no argument, a shallow clone of ppanel-gateway is used.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="${1:-}"
CLEANUP=""

if [[ -z "$SRC" ]]; then
  tmp="$(mktemp -d)"
  CLEANUP="$tmp"
  echo "cloning phenix3443/ppanel-gateway ..."
  git clone --depth 1 https://github.com/phenix3443/ppanel-gateway.git "$tmp/ppanel-gateway"
  SRC="$tmp/ppanel-gateway"
fi
trap '[[ -n "$CLEANUP" ]] && rm -rf "$CLEANUP"' EXIT

[[ -f "$SRC/go.mod" ]] || { echo "not a gateway source dir: $SRC" >&2; exit 2; }

for pair in linux/amd64 linux/arm64 darwin/amd64 darwin/arm64; do
  os="${pair%/*}"; arch="${pair#*/}"
  echo "building gateway-$os-$arch"
  ( cd "$SRC" && GOOS="$os" GOARCH="$arch" CGO_ENABLED=0 \
      go build -trimpath -ldflags="-s -w" -o "$HERE/gateway-$os-$arch" ./cmd/gateway )
done
echo "done -> $HERE"
