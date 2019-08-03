package word

import "testing"

func TestPalindrome(t *testing.T) {
	tests := []struct {
		input string
		want  bool
	}{
		{"", true},
		{"a", true},
		{"aa", true},
		{"detartrated", true},
		{"kayak", true},
		{"A man, a plan, a canal: Panama", true},
		{"palindrome", false},
	}
	for _, test := range tests {
		if got := IsPalindrome(test.input); got != test.want {
			t.Errorf(`IsPalindrome(%q) = %v`, test.input, got)
		}
	}
}
