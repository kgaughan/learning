## Binaries

# The dependency order is significant
spam: spamlex.cmo spam.cmo cli.cmo
	ocamlc -o $@ $^

## Dependencies

cli.ml: spam.cmo
spam.ml: spam.cmi spamlex.cmo

## Utilities

.PHONY: clean
clean:
	rm -f spam spamlex.ml *.cm*

include ../common.mk
