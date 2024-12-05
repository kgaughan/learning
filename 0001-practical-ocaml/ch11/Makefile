## Binaries

.PHONY: all
all: first_uri.cmo uri_lexer.cmo uri_parser.cmo

parse_test: uri_parser.cmo uri_lexer.cmo
	ocamlc -o $@ $^

## Dependencies

uri_lexer.ml: uri_parser.ml

first_uri.ml: first_uri.cmi

## Utilities

.PHONY: clean
clean:
	rm -rf *.cm?
	rm -rf parse_test uri_lexer.ml uri_parser.ml uri_parser.mli

include ../common.mk
