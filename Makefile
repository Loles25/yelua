.RECIPEPREFIX = >
.PHONY: build rock test

build:
>luastatic yelua src/*.lua -o yelua.bin

rock:
>luarocks make

test:
>busted tests
