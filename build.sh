#!/usr/bin/env bash
set -e

OUTDIR="$(pwd)/output"
WORKDIR="$(pwd)/output/work"

echo "==> Cleaning previous builds..."
rm -rf "$OUTDIR"
mkdir -p "$OUTDIR"

echo "==> Building RaveOS ISO..."
echo "    Output: $OUTDIR"
echo "    Work:   $WORKDIR"
echo ""

mkarchiso -v -w "$WORKDIR" -o "$OUTDIR" releng/

echo ""
echo "==> Build completed successfully!"
echo ""
ls -lh "$OUTDIR"/*.iso