all: freq.byte

freq.byte: freq.ml
	ocamlbuild -use-ocamlfind -pkg core -tag thread freq.byte

clean:
	ocamlbuild -clean

.PHONY: all clean
