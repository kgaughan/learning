package main

import (
	"fmt"
)

type Fetcher interface {
	// Fetch returns the body of URL and
	// a slice of URLs found on that page.
	Fetch(url string) (body string, urls []string, err error)
}

// Need at least two to avoid deadlock.
const QUEUE = 2

type Request struct {
	url     string
	depth   int
	fetcher Fetcher
}

type Response struct {
	src   string
	body  string
	urls  []string
	depth int
	err   error
}

func (self *Request) Fetch() Response {
	body, urls, err := self.fetcher.Fetch(self.url)
	return Response{
		src:   self.url,
		body:  body,
		urls:  urls,
		depth: self.depth - 1,
		err:   err,
	}
}

// Crawl uses fetcher to recursively crawl
// pages starting with url, to a maximum of depth.
func Crawl(url string, depth int, fetcher Fetcher) {
	// The queue of URLs to be crawled
	toCrawl := make(chan Request, QUEUE)
	// URLs coming in from crawled pages
	incoming := make(chan Response, QUEUE)

	// Spin up a few goroutines to do the crawling. You could probably get
	// away with just spinning up one per request, but I'm more comfortable
	// with this as in a real-life situation you'd want to limit the number
	// of concurrent requests being made to a server at a time.
	for i := 0; i < QUEUE; i++ {
		go func() {
			for request := range toCrawl {
				incoming <- request.Fetch()
			}
		}()
	}

	// Keep track of URLs we've already fetched.
	fetched := make(map[string]bool)

	// Prime the pump
	toCrawl <- Request{
		url:     url,
		depth:   depth,
		fetcher: fetcher,
	}
	pendingCount := 1

	for pendingCount > 0 {
		response := <-incoming
		pendingCount--
		if response.err != nil {
			fmt.Printf("Error fetching %v: '%v'\n", response.src, response.err)
			continue
		}
		fmt.Printf("%v: '%v'\n", response.src, response.body)
		if response.depth == 0 {
			continue
		}
		for _, u := range response.urls {
			if _, ok := fetched[u]; ok {
				continue
			}
			fetched[u] = true
			pendingCount++
			toCrawl <- Request{
				url:     u,
				depth:   response.depth - 1,
				fetcher: fetcher,
			}
		}
	}

	// Let the workers shut down.
	close(toCrawl)
}

func main() {
	Crawl("http://golang.org/", 4, fetcher)
}

// fakeFetcher is Fetcher that returns canned results.
type fakeFetcher map[string]*fakeResult

type fakeResult struct {
	body string
	urls []string
}

func (f fakeFetcher) Fetch(url string) (string, []string, error) {
	if res, ok := f[url]; ok {
		return res.body, res.urls, nil
	}
	return "", nil, fmt.Errorf("not found: %s", url)
}

// fetcher is a populated fakeFetcher.
var fetcher = fakeFetcher{
	"http://golang.org/": &fakeResult{
		"The Go Programming Language",
		[]string{
			"http://golang.org/pkg/",
			"http://golang.org/cmd/",
		},
	},
	"http://golang.org/pkg/": &fakeResult{
		"Packages",
		[]string{
			"http://golang.org/",
			"http://golang.org/cmd/",
			"http://golang.org/pkg/fmt/",
			"http://golang.org/pkg/os/",
		},
	},
	"http://golang.org/pkg/fmt/": &fakeResult{
		"Package fmt",
		[]string{
			"http://golang.org/",
			"http://golang.org/pkg/",
		},
	},
	"http://golang.org/pkg/os/": &fakeResult{
		"Package os",
		[]string{
			"http://golang.org/",
			"http://golang.org/pkg/",
		},
	},
}
