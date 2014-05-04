package main

import (
	"io"
	"os"
	"strings"
)

type rot13Reader struct {
	r io.Reader
}

func rotate(b byte) byte {
	var lower byte
	switch {
	case b >= 'A' && b <= 'Z':
		lower = 'A'
	case b >= 'a' && b <= 'z':
		lower = 'a'
	default:
		return b
	}
	return lower + ((b - lower + 13) % 26)
}

func (self *rot13Reader) Read(p []byte) (n int, err error) {
	n, err = self.r.Read(p)
	for i := 0; i < n; i++ {
		p[i] = rotate(p[i])
	}
	return
}

func main() {
	s := strings.NewReader(
		"Lbh penpxrq gur pbqr!")
	r := rot13Reader{s}
	io.Copy(os.Stdout, &r)
}
