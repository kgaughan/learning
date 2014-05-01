fn main() {
	// Iterators can be collected into vectors.
	let collected_iterator: Vec<int> = range(0, 10).collect();
	println!("Collected range(0, 10) into: {}",
			 collected_iterator.as_slice());

	// vec! can be used to initialise a vector
	let mut xs = vec!(1, 2, 3);
	println!("Vector: {}", xs.as_slice());

	// Insert new element at the end of the vector.
	println!("Push 4 into the vector.");
	xs.push(4);
	println!("Vector: {}", xs.as_slice());

	// Error: immutable vectors can't be grown or shrank.
	//collected_iterator.push(0);
	
	// The len method yields the current size of the vector.
	println!("Vector size: {}", xs.len());

	// Indexing is done using the 'get' method (indexing starts at 0).
	println!("Second element: {}", xs.get(1));

	// Remove last element from the vector.
	println!("Pop the last element: {}", xs.pop());

	// Out of bounds indexing yields a runtime failure.
	println!("Fourth element: {}", xs.get(3));
}
