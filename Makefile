.PHONY: all clean

all: build

build:
	ocamlbuild -use-ocamlfind tutorial.native

clean:
	ocamlbuild -clean

