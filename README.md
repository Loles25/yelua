# Yelua

Yelua is a minimal package manager written in Lua.

## Installation

### Prerequisites

- Lua 5.1+
- Git
- [LuaRocks](https://luarocks.org/) for dependency management

### From source

```sh
git clone https://github.com/Loles25/yelua.git
cd yelua
luarocks install --deps-only yelua-0.1-1.rockspec
```

### Building a binary

A standalone binary can be produced with [luastatic](https://github.com/ers35/luastatic):

```sh
make build
./yelua.bin list
```

### LuaRocks packaging

To install locally through LuaRocks:

```sh
luarocks make
```

## Commands

- `install <package>`: install one or more packages.
- `remove <package>`: remove installed packages.
- `update [package]`: update all packages or only the ones listed.
- `list`: display installed packages.
- `search <term>`: search the whitelist.
- `cache clean`: purge the cache.

## Configuration

The main configuration file is located at `~/.yelua/config.yaml`:

```yaml
cache_dir: ~/.yelua/cache
```

## `yelua.json` file

A project can declare its dependencies in a root `yelua.json` file:

```json
{
  "dependencies": {
    "example-package": "1.0.0",
    "another-package": "*"
  }
}
```

Then run:

```sh
./yelua install
```

## Documentation

More detailed information is available in the [`docs/`](docs/) folder.

