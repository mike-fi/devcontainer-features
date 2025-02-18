
# Databricks CLI devcontainer feature

Installing the databricks-cli into your devcontainer as a feature, deminishing the need to write Dockerfiles or bash scripts.

## Example Usage

```json
"features": {
    "ghcr.io/mike-fi/devcontainer-features/databricks-cli:1": {
        "version": "v0.241.0"
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select cli version | string | main |
