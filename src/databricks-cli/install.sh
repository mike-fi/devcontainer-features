#!/bin/sh

# DISCLAIMER
# This script is licensed under the MIT License
# The software installed by this script is subject to its own license terms. For more information see NOTICE.md and the documentation provided by the software vendor.

set -e

echo "Activating feature 'databricks-cli'"

VERSION=${VERSION:-"main"}


# arch = "$(uname -m)"
# case $arch in
#     x86_64) arch="amd64";;
#     aarch64 | arm8*) arch="arm64";;
#     aarch32 | armv7* | armvhf*) arch="arm61";;
#     i?86) arch="386";;
#     *) echo "('!) Architecture $arch unsupported"; exit 1;;
# esac

# The 'install.sh' entrypoint script is always executed as the root user.
#
# These following environment variables are passed in by the dev container CLI.
# These may be useful in instances where the context of the final 
# remoteUser or containerUser is useful.
# For more details, see https://containers.dev/implementors/features#user-env-var
echo "The effective dev container remoteUser is '$_REMOTE_USER'"
echo "The effective dev container remoteUser's home directory is '$_REMOTE_USER_HOME'"

echo "The effective dev container containerUser is '$_CONTAINER_USER'"
echo "The effective dev container containerUser's home directory is '$_CONTAINER_USER_HOME'"

echo "Installing Databricks CLI version: $VERSION"

# assert curl is available
if ! command -v curl >/dev/null 2>&1; then
    echo "Error: curl is not installed. Please install curl and try again."
    exit 1
fi

curl -fsSL https://raw.githubusercontent.com/databricks/setup-cli/$VERSION/install.sh | sh

echo "Databricks CLI installed successfully"
chmod +x /usr/local/bin/databricks
