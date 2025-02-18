# Dev Container Features

> This repo provides a hopefully growing set of devcontainer features making my daily work easier. And maybe yours.

## Features

### `databricks-cli`

Adding `databricks-cli` to the devcontainer will install the databricks-cli, defaulting to main, with the given version

```jsonc
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
    "features": {
        "ghcr.io/devcontainers/features/common-utils:1": {},
        "ghcr.io/mike-fi/devcontainer-features/databricks-cli:1": {
            "version": "v0.241.0"
        }
    }
}
```
> __NOTE__: This feature currently requires curl to be installed, which is part of the common-utils feature. I'm working on a solution to make it installable cross-platform.