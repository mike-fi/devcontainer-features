
# Databricks CLI devcontainer feature

Installing the Databricks CLI into your devcontainer as a feature, diminishing the need to write Dockerfiles or bash scripts. This feature depends on `ghcr.io/devcontainers/features/common-utils:2`.

## Example Usage

```json
"features": {
    "ghcr.io/mike-fi/devcontainer-features/databricks-cli:1": {
        "version": "v1.0.0"
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select CLI version. `main` resolves to the latest GitHub release. | string | main |
