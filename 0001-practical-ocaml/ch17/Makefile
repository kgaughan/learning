## Binaries

.PHONY: all
all: syslog complex

syslog: syslog_parser.cmo syslog_lexer.cmo
	@echo "BUILD $<"
	@$(COMPILER) -linkpkg -o $@ $^

complex: parser.cmo lexer.cmo
	@echo "BUILD $<"
	@$(COMPILER) -linkpkg -o $@ $^

## Dependencies

parser.mly parser.mll: mll_types.cmo

## Utilities

.PHONY: clean
clean:
	rm -f complex syslog *.cm*
	rm -f syslog_parser.ml syslog_parser.mli
	rm -f parser.ml parser.mli

include ../common.mk
