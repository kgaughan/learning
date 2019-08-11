package stringreader

import "testing"

func TestReaderSmallBuffer(t *testing.T) {
	reader := New("a short string")
	buf := make([]byte, 4)
	if n, _ := reader.Read(buf); n != 4 {
		t.Errorf("Unexpected amount read. Expected 4; got %v", n)
	}
}

func TestReaderBigBuffer(t *testing.T) {
	s := "a short string"
	reader := New(s)
	buf := make([]byte, len(s)*2)
	if n, _ := reader.Read(buf); n != len(s) {
		t.Errorf("Unexpected amount read. Expected %v; got %v", len(s), n)
	}
}
