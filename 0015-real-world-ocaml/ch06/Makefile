all: variants.cmo expr.cmo

variants.cmo: variants.ml
	ocamlbuild -use-ocamlfind -pkg core -tag thread variants.cmo

expr.cmo: expr.ml
	ocamlbuild -use-ocamlfind -pkg core -tag thread expr.cmo

clean:
	ocamlbuild -clean

.PHONY: all clean
