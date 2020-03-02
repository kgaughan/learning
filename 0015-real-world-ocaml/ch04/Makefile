all: freq.byte session_info.byte

freq.byte: freq.ml
	ocamlbuild -use-ocamlfind -pkg core -tag thread freq.byte

session_info.byte: session_info.ml
	ocamlbuild -use-ocamlfind -pkg core -tag thread session_info.byte

clean:
	ocamlbuild -clean

.PHONY: all clean
