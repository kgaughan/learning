use std::mem::size_of_val;

fn analyze_slice(slice: &[int]) {
	println!("First element of the slice: {}", slice[0]);
	println!("The slice has {} elements", slice.len());
}

fn main() {
	// Fixed-size array (type signature is superfluous)
	let xs: [int, ..5] = [1, 2, 3, 4, 5];

	// Indexing starts at 0
	println!("First element of the array: {}", xs[0]);
	println!("Second element of the array: {}", xs[1]);

	// .len() return the size of the array.
	println!("Array size: {}", xs.len());

	// Arrays are stack allocated
	println!("Array occupies {} bytes", size_of_val(&xs));

	// Out of bounds indexing yields runtime failure
	//println!("{}", xs[5]);

	// Arrays can be automatically converted into slices.
	println!("Borrow the whole array as a slice");
	analyze_slice(xs);

	// Slices can point to a section of an array.
	println!("Borrow a section of the array as a slice");
	analyze_slice(xs.slice(1, 4));
}
