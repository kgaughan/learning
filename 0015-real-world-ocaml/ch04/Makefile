FLAGS:=-use-ocamlfind -pkg core -tag thread

all: freq.byte session_info.byte

freq.byte: freq.ml
	ocamlbuild $(FLAGS) freq.byte

session_info.byte: session_info.ml
	ocamlbuild $(FLAGS) session_info.byte

clean:
	ocamlbuild -clean

.PHONY: all clean
