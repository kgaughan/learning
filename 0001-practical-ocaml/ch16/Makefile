PKGS:=-package unix
COMPILER:=ocamlfind ocamlc $(PKGS)

## Binaries

.PHONY: all
all: wc rpncalc shortest csv_top cp_top

csv_top: csv_parser.cmo csv.cmo
	ocamlmktop -o $@ $^

cp_top: config_parser.cmo config_lexer.cmo
	ocamlmktop -o $@ $^

shortest: shortest.cmo
	$(COMPILER) -linkpkg -o $@ $^

wc: wc.cmo
	$(COMPILER) -linkpkg -o $@ $^

rpncalc: rpncalc.cmo
	$(COMPILER) -linkpkg -o $@ $^

## Dependencies

## Utilities

.PHONY: clean
clean:
	rm -f wc rpncalc *_top shortest *.cm*
	rm -f csv_parser.ml csv_parser.mli
	rm -f config_parser.ml config_parser.mli

.PHONY: format
format:
	ocamlformat -i *.ml *.mli

## Build rules

%.ml %.mli: %.mly
	ocamlyacc $<
	$(COMPILER) -c $*.mli

%.ml: %.mll
	ocamllex $<

%.cmi: %.mli
	$(COMPILER) -c $<

%.cmo: %.ml
	$(COMPILER) -c $<
