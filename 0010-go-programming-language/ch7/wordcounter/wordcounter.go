package wordcounter

import "bufio"
import "bytes"

// WordCounter implements io.Writer and counts the words written to it.
type WordCounter struct {
	buffer  *bytes.Buffer
	scanner *bufio.Scanner
	n       int
}

func New() *WordCounter {
	c := &WordCounter{}
	c.buffer = new(bytes.Buffer)
	c.scanner = bufio.NewScanner(c.buffer)
	c.scanner.Split(bufio.ScanWords)
	return c
}

func (c *WordCounter) Write(p []byte) (int, error) {
	n, _ := c.buffer.Write(p)
	for c.scanner.Scan() {
		c.n++
	}
	return n, nil
}

func (c *WordCounter) Count() int {
	return c.n
}
