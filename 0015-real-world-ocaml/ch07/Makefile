FLAGS:=-use-ocamlfind -pkg core,core_bench,core_unix.command_unix -tag thread

all: _build/backtrace.native

_build/backtrace.native: backtrace.ml
	ocamlbuild $(FLAGS) backtrace.native

clean:
	ocamlbuild -clean

.PHONY: all clean
