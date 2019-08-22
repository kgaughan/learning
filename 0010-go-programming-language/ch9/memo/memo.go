// Package memo provides concurrency-unsafe memoisation of a function of type
// Func.
package memo

import "sync"

type entry struct {
	res   result
	ready chan struct{} // closed when res is ready
}

// A Memo caches the results of calling a Func.
type Memo struct {
	requests chan request
}

// Func is the type of the function to memoise.
type Func func(key string) (interface{}, error)

type result struct {
	value interface{}
	err   error
}

// A request is a message requesting that the Func be applied to key.
type request struct {
	key      string
	response chan<- result // the client wants a single result
}

// New function returns a memoisation of f. Clients must subsequently call Close.
func New(f Func) *Memo {
	memo := &Memo{requests: make(chan request)}
	go memo.server(f)
	return memo
}

func (memo *Memo) Get(key string) (interface{}, error) {
	response := make(chan result)
	memo.requests <- request{key, response}
	res := <-response
	return res.value, res.err
}

func (memo *Memo) Close() {
	close(memo.requests)
}

func (memo *Memo) server(f Func) {
	cache := make(map[string]*entry)
	for req := range memo.requests {
		e := cache[req.key]
		if e == nil {
			// This is the first request for this key.
			e = &entry{ready: make(chan struct{})}
			cache[req.key] = e
			go e.call(f, req.key) // call f(key)
		}
		go e.deliver(req.response)
	}
}

func (e *entry) call(f Func, key string) {
	// Evaluate the function
	e.res.value, e.res.err = f(key)
	// Broadcast the ready condition.
	close(e.ready)
}

func (e *entry) deliver(response chan<- result) {
	// Wait for ready condition.
	<-e.ready
	// Send the result to the client.
	response <- e.res
}
