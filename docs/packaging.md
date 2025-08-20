# Distribution

## Generating a binary

Yelua can be packaged as a binary using [`luastatic`](https://github.com/ers35/luastatic).

```sh
make build
./yelua.bin list
```

## Publishing on LuaRocks

A rockspec (`yelua-0.1-1.rockspec`) is provided. To install locally:

```sh
luarocks make
```

To publish on LuaRocks:

```sh
luarocks upload yelua-0.1-1.rockspec --api-key=<key>
```

