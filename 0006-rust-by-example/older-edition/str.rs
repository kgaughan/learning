fn main() {
	let pangram = "the quick brown fox jumps over the lazy dog";
	println!("Pangram: {}", pangram);

	// Iterate over words in reverse; no new string is allocated.
	println!("Words in reverse");
	for word in pangram.words().rev() {
		println!("{}", word);
	}

	// Copy chars into a vector, sort, and remove duplicates.
	let mut chars: Vec<char> = pangram.chars().collect();
	chars.sort();
	chars.dedup();

	// StrBuf is a growable array.
	let mut strbuf = StrBuf::new();
	for c in chars.move_iter() {
		// Insert a char at the end of strbuf
		strbuf.push_char(c);
		// Insert a string at the end of strbuf
		strbuf.push_str(" ");
	}

	// The trimmed string is a slice of the original string, hence no new
	// allocation is performed.
	let trimmed_string = strbuf.as_slice().trim_chars(&[',', ' ']);
	println!("Used characters: {}", trimmed_string);

	// Heap allocate a string.
	let alice = ~"I like dogs";
	// Replaced string get heap allocated (superfluous type annotation)
	let bob: ~str = alice.replace("dog", "cat");

	println!("Bob says: {}", bob);
}
