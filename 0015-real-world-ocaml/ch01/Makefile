all: sum.native ch01.cmo

clean:
	corebuild -clean

ch01.cmo: ch01.ml
	ocamlc -c $<

sum.native: sum.ml
	corebuild $@

.PHONY: all clean
