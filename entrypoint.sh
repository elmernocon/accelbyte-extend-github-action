#!/bin/bash

set -eou pipefail

REPOSITORY="AccelByte/extend-helper-cli"
EXECUTABLE_NAME="extend-helper-cli"

VERSION="${1:-}"
OS="${2:-linux}"
ARCH="${3:-amd64}"

ASSET_NAME="${EXECUTABLE_NAME}-${OS}_${ARCH}"

if [[ -z "$VERSION" ]]; then
    RELEASE_URL="https://api.github.com/repos/${REPOSITORY}/releases/latest"
else
    RELEASE_URL="https://api.github.com/repos/${REPOSITORY}/releases/tags/${VERSION}"
fi

resp=$(curl -sL -w "%{http_code}" "$RELEASE_URL")
resp_code="${resp: -3}"
resp_body="${resp::${#resp}-3}"

if [[ "$resp_code" -ne 200 ]]; then
    error_message=$(echo "$resp_body" | jq -r '.message // empty')
    echo "Failed to get the release information. GitHub API Error $resp_code $error_message."
    exit 1
fi

VERSION=$(echo "$resp_body" | jq -r ".name")

DOWNLOAD_URL=$(echo "$resp_body" | jq -r ".assets[] | select(.name == \"${ASSET_NAME}\") | .browser_download_url")

if [[ -z "$DOWNLOAD_URL" ]]; then
    echo "Failed to get the download URL."
    exit 1
fi

TMP_PATH=$(mktemp)
curl -sL -o "${TMP_PATH}" "${DOWNLOAD_URL}"
chmod +x "${TMP_PATH}"
sudo mv "${TMP_PATH}" /usr/local/bin/${ASSET_NAME}
sudo ln -sf /usr/local/bin/${ASSET_NAME} /usr/local/bin/${EXECUTABLE_NAME}

echo "$VERSION /usr/local/bin/${ASSET_NAME}"
