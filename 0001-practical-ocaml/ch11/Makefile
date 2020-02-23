all: first_uri.cmo

clean:
	rm -rf *.cm?

%.cmi: %.mli
	ocamlc -c $<

%.cmo: %.ml
	ocamlc -c $<

first_uri.ml: first_uri.cmi

.PHONY: all clean
