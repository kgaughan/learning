all: first_uri.cmo uri_lexer.cmo uri_parser.cmo

clean:
	rm -rf *.cm?
	rm -rf parse_test uri_lexer.ml uri_parser.ml uri_parser.mli

parse_test: uri_parser.cmo uri_lexer.cmo
	ocamlc -o $@ $^

%.cmi: %.mli
	ocamlc -c $<

%.cmo: %.ml
	ocamlc -c $<

uri_lexer.ml: uri_lexer.mll
	ocamllex $<

uri_parser.ml: uri_parser.mly
	ocamlyacc $<
	ocamlc -c uri_parser.mli

uri_lexer.ml: uri_parser.ml

first_uri.ml: first_uri.cmi

.PHONY: all clean
