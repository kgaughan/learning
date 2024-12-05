## Binaries

.PHONY: all
all: wc rpncalc shortest csv_top cp_top

csv_top: csv_parser.cmo csv.cmo
	@echo "BUILD $<"
	@ocamlfind ocamlmktop -o $@ $^

cp_top: config_parser.cmo config_lexer.cmo
	@echo "BUILD $<"
	@ocamlfind ocamlmktop -o $@ $^

shortest: shortest.cmo
	@echo "BUILD $<"
	@$(COMPILER) -linkpkg -o $@ $^

wc: wc.cmo
	@echo "BUILD $<"
	@$(COMPILER) -linkpkg -o $@ $^

rpncalc: rpncalc.cmo
	@echo "BUILD $<"
	@$(COMPILER) -linkpkg -o $@ $^

## Dependencies

## Utilities

.PHONY: clean
clean:
	rm -f wc rpncalc *_top shortest *.cm*
	rm -f csv_parser.ml csv_parser.mli
	rm -f config_parser.ml config_parser.mli

include ../common.mk
