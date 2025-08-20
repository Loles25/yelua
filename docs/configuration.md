# Configuration

Yelua stores its configuration in `~/.yelua/config.yaml`.

## Example

```yaml
cache_dir: ~/.yelua/cache
```

The directory is created automatically on first run.

## Declare dependencies with `yelua.json`

Place a `yelua.json` file at the project root to list required packages:

```json
{
  "dependencies": {
    "example-package": "1.0.0",
    "another-package": "*"
  }
}
```

Then run `./yelua install` to fetch the dependencies.

## Whitelist

Installable packages are defined in `whitelist.json`. Only packages listed there can be installed.

