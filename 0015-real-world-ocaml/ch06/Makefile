FLAGS:=-use-ocamlfind -pkg core -tag thread

all: _build/variants.cmo _build/expr.cmo

_build/variants.cmo: variants.ml
	ocamlbuild $(FLAGS) variants.cmo

_build/expr.cmo: expr.ml
	ocamlbuild $(FLAGS) expr.cmo

clean:
	ocamlbuild -clean

.PHONY: all clean
