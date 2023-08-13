#!/usr/bin/env sh
set -xeou pipefail

. config
echo "$IMG_NAME"

ISO_URL="./pi-gen/deploy/$IMG_NAME"
ISO_CHECKSUM=$(cut -d' ' -f1 <"$ISO_URL".sha256)

packer init ./packer
packer build \
	-var source_iso_url="$ISO_URL" \
	-var source_iso_checksum="$ISO_CHECKSUM" \
	./packer
