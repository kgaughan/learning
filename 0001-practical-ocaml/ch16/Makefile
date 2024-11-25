PKGS:=-package unix
COMPILER:=ocamlfind ocamlc $(PKGS)

## Binaries

.PHONY: all
all: wc rpncalc

wc: wc.cmo
	$(COMPILER) -linkpkg -o $@ $^

rpncalc: rpncalc.cmo
	$(COMPILER) -linkpkg -o $@ $^

## Dependencies

## Utilities

.PHONY: clean
clean:
	rm -f wc rpncalc *.cm*

.PHONY: format
format:
	ocamlformat -i *.ml *.mli

## Build rules

%.ml: %.mll
	ocamllex $<

%.cmi: %.mli
	$(COMPILER) -c $<

%.cmo: %.ml
	$(COMPILER) -c $<
