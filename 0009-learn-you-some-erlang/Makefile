SRC := $(wildcard *.erl)
OBJ := $(SRC:.erl=.beam)

all: $(OBJ)

clean:
	rm -f $(OBJ)

%.beam: %.erl
	erlc $^

road: road.beam
	erl -noshell -run road main road.txt

.PHONY: all clean
.PHONY: road
