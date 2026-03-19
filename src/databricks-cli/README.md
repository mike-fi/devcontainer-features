
# Databricks CLI devcontainer feature

Installing the Databricks CLI into your devcontainer as a feature, diminishing the need to write Dockerfiles or bash scripts.

## Example Usage

```json
"features": {
    "ghcr.io/mike-fi/devcontainer-features/databricks-cli:1": {
        "version": "v0.294.0"
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select CLI version. `main` resolves to the latest GitHub release. | string | main |
