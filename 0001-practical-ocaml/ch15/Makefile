COMPILER:=ocamlfind ocamlc
LINK_FLAGS:=-linkpkg -package unix

## Binaries

.PHONY: all
all: client server

# The dependency order is significant
server: spamlex.cmo spam.cmo spam_server.cmo
	$(COMPILER) $(LINK_FLAGS) -o $@ $^

client: client.cmo
	$(COMPILER) $(LINK_FLAGS) -o $@ $^

## Dependencies

spam_server.ml: spam.cmo spam.cmi
spam.ml: spam.cmi spamlex.cmo

## Utilities

.PHONY: clean
clean:
	rm -f server client spamlex.ml *.cm*

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
