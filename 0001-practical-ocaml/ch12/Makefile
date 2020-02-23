docs: cool.cmo
	mkdir docs
	ocamldoc -html -d docs -g cool.cmo -I +ocamldoc *.ml

cool.cmo: cool.ml
	ocamlc -I +ocamldoc -c cool.ml

.PHONY: docs
