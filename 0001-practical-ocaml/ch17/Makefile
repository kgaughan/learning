## Binaries

.PHONY: all
all: syslog

syslog: syslog_parser.cmo syslog_lexer.cmo
	@echo "BUILD $<"
	@$(COMPILER) -linkpkg -o $@ $^

## Dependencies

## Utilities

.PHONY: clean
clean:
	rm -f wc syslog *.cm*
	rm -f syslog_parser.ml syslog_parser.mli

include ../common.mk
