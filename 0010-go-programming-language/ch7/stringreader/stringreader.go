package stringreader

type StringReader struct {
	start int
	s     string
}

func New(s string) *StringReader {
	return &StringReader{0, s}
}

func (s *StringReader) Read(p []byte) (n int, err error) {
	// copy() will only copy the shorter of the two slices
	copied := copy(p, s.s[s.start:])
	s.start += copied
	return copied, nil
}
