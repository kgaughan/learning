## Binaries

.PHONY: all
all: client server

# The dependency order is significant
server: spamlex.cmo spam.cmo spam_server.cmo
	$(COMPILER) -linkpkg -o $@ $^

client: client.cmo
	$(COMPILER) -linkpkg -o $@ $^

## Dependencies

spam_server.ml: spam.cmo spam.cmi
spam.ml: spam.cmi spamlex.cmo

## Utilities

.PHONY: clean
clean:
	rm -f server client spamlex.ml *.cm*

include ../common.mk
