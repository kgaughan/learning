package wordcounter

import "testing"

func TestWordCounter(t *testing.T) {
	c := New()
	c.Write([]byte("Now is the winter of our discontent,\nMade glorious summer by this sun of York.\n"))
	if c.Count() != 15 {
		t.Errorf("Got %v bytes; expected 15", c.Count())
	}
}
