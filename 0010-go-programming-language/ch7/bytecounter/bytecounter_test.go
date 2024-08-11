package bytecounter

import (
	"fmt"
	"testing"
)

func TestByteCounter(t *testing.T) {
	var c ByteCounter
	fmt.Fprintf(&c, "Hello, world!")
	if c != 13 {
		t.Errorf("Got %v bytes; expected 13", c)
	}
}
