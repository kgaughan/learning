FLAGS:=-use-ocamlfind -pkg core -tag thread

all: dictionary.byte loops.byte dlist.byte

dictionary.ml: dictionary.mli

dictionary.byte: dictionary.ml 
	ocamlbuild $(FLAGS) dictionary.byte

loops.byte: loops.ml
	ocamlbuild $(FLAGS) loops.byte

dlist.ml: dlist.mli

dlist.byte: dlist.ml
	ocamlbuild $(FLAGS) dlist.byte

clean:
	ocamlbuild -clean

.PHONY: all clean
