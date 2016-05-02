objects:=$(patsubst %.erl,%.beam,$(wildcard *.erl))

all: $(objects)

clean:
	rm -f $(objects)

%.beam: %.erl
	erlc $^

road: road.beam
	erl -noshell -run road main road.txt

.PHONY: all clean
.PHONY: road
