PKGS=
COMPILER=ocamlfind ocamlc $(PKGS)

## Utilities

.PHONY: format
format:
	ocamlformat -i *.ml *.mli

## Build rules

%.ml %.mli: %.mly
	@echo "YACC  $<"
	@ocamlyacc $<
	@$(COMPILER) -c $*.mli

%.ml: %.mll
	@echo "LEX   $<"
	@ocamllex $<

%.cmi: %.mli
	@echo "BUILD $<"
	@$(COMPILER) -c $<

%.cmo: %.ml
	@echo "BUILD $<"
	@$(COMPILER) -c $<
