# Dev Container Features

> This repo provides a hopefully growing set of devcontainer features making my daily work easier. And maybe yours.

## Features

### `databricks-cli`

Adding `databricks-cli` to the devcontainer installs the Databricks CLI. The feature requires `common-utils`, defaults to `main`, and resolves that to the latest GitHub release before downloading the matching Linux binary for the container architecture and verifying its checksum.

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/devcontainers/features/common-utils:2": {},
        "ghcr.io/mike-fi/devcontainer-features/databricks-cli:1": {
            "version": "v1.0.0"
        }
    }
}
```
> __NOTE__: This feature depends on `ghcr.io/devcontainers/features/common-utils:2` and installs the Linux `amd64` and `arm64` release archives after verifying the published SHA-256 checksum.
