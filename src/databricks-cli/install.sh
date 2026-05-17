#!/bin/sh

# DISCLAIMER
# This script is licensed under the MIT License
# The software installed by this script is subject to its own license terms. For more information see NOTICE.md and the documentation provided by the software vendor.

set -eu

echo "Activating feature 'databricks-cli'"

VERSION="${VERSION:-main}"
TARGET_BIN="/usr/local/bin/databricks"

echo "The effective dev container remoteUser is '$_REMOTE_USER'"
echo "The effective dev container remoteUser's home directory is '$_REMOTE_USER_HOME'"

echo "The effective dev container containerUser is '$_CONTAINER_USER'"
echo "The effective dev container containerUser's home directory is '$_CONTAINER_USER_HOME'"

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Error: required command '$1' is not installed."
        exit 1
    fi
}

checksum_verify() {
    checksum_file="$1"
    archive_name="$2"
    archive_checksum_file="$TMP_DIR/${archive_name}.sha256"

    if ! grep "[ *]${archive_name}\$" "$TMP_DIR/$checksum_file" >"$archive_checksum_file"; then
        echo "Error: checksum entry for '$archive_name' was not found in '$checksum_file'."
        exit 1
    fi

    if command -v sha256sum >/dev/null 2>&1; then
        (cd "$TMP_DIR" && sha256sum -c "$(basename "$archive_checksum_file")" >/dev/null)
        return
    fi

    if command -v shasum >/dev/null 2>&1; then
        expected_hash="$(awk '{print $1}' "$archive_checksum_file")"
        actual_hash="$(shasum -a 256 "$TMP_DIR/$archive_name" | awk '{print $1}')"
        [ "$expected_hash" = "$actual_hash" ]
        return
    fi

    echo "Error: neither 'sha256sum' nor 'shasum' is available for checksum verification."
    exit 1
}

resolve_version() {
    requested_version="$1"

    if [ "$requested_version" = "main" ] || [ "$requested_version" = "latest" ]; then
        latest_release_url="$(curl -fsSL -o /dev/null -w '%{url_effective}' https://github.com/databricks/cli/releases/latest)"
        resolved_version="${latest_release_url##*/}"
    else
        resolved_version="$requested_version"
    fi

    case "$resolved_version" in
        v*) printf '%s\n' "$resolved_version" ;;
        *) printf 'v%s\n' "$resolved_version" ;;
    esac
}

detect_arch() {
    raw_arch="$(uname -m)"
    case "$raw_arch" in
        x86_64|amd64) printf 'amd64\n' ;;
        aarch64|arm64) printf 'arm64\n' ;;
        *)
            echo "Error: unsupported architecture '$raw_arch'. Supported architectures: amd64, arm64."
            exit 1
            ;;
    esac
}

require_command curl
require_command tar
require_command install

resolved_version="$(resolve_version "$VERSION")"
version_number="${resolved_version#v}"
arch="$(detect_arch)"

archive_name="databricks_cli_${version_number}_linux_${arch}.tar.gz"
checksum_name="databricks_cli_${version_number}_SHA256SUMS"
release_base_url="https://github.com/databricks/cli/releases/download/${resolved_version}"

echo "Installing Databricks CLI version: ${resolved_version} for linux/${arch}"

TMP_DIR="$(mktemp -d)"
STAGED_BIN=""
cleanup() {
    if [ -n "$STAGED_BIN" ] && [ -e "$STAGED_BIN" ]; then
        rm -f "$STAGED_BIN"
    fi
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT INT HUP TERM

curl -fsSLo "$TMP_DIR/$archive_name" "${release_base_url}/${archive_name}"
curl -fsSLo "$TMP_DIR/$checksum_name" "${release_base_url}/${checksum_name}"

if ! checksum_verify "$checksum_name" "$archive_name"; then
    echo "Error: checksum verification failed for '$archive_name'."
    exit 1
fi

tar -xzf "$TMP_DIR/$archive_name" -C "$TMP_DIR"
STAGED_BIN="$(mktemp "${TARGET_BIN}.tmp.XXXXXX")"
install -m 0755 "$TMP_DIR/databricks" "$STAGED_BIN"
mv -f "$STAGED_BIN" "$TARGET_BIN"
STAGED_BIN=""

echo "Databricks CLI installed successfully: $("$TARGET_BIN" -v)"
