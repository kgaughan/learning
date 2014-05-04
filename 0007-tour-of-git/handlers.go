package main

import (
	"fmt"
	"net/http"
)

type String string

type Struct struct {
	Greeting string
	Punct    string
	Who      string
}

func (self String) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "%v", self)
}

func (self Struct) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "%v%v%v", self.Greeting, self.Punct, self.Who)
}

func main() {
	http.Handle("/string", String("I'm a frayed knot."))
	http.Handle("/struct", &Struct{"Hello", ":", "Gophers!"})
	http.ListenAndServe("localhost:4000", nil)
}
