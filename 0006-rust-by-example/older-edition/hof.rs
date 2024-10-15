extern crate num;

// The AdditiveIterator trait adds the sum() method to iterators
use std::iter::{AdditiveIterator, count};
// The Integer trait adds the is_odd() method to integer primitives
use num::Integer;

fn main() {
	println!("Find the sum of all the squared odd numbers under 1000");
	let upper: int = 1000;

	// Imperative approach
	// Declare accumulator variable.
	let mut acc = 0;
	// Iterate 0, 1, 2, ... to infinity.
	for n in count(0, 1) {
		// Square the number
		let n_squared = n * n;

		if n_squared >= upper {
			// Break loop if the upper limit is exceeded.
			break;
		} else if n_squared.is_odd() {
			// Accumulate value if it's odd.
			acc += n_squared;
		}
	}
	println!("Imperative style: {}", acc);

	// Functional approach
	let sum_of_squared_odd_numbers =
		// All integers
		count(0, 1).
		// Squared
		map(|n| n * n).
		// Below upper limit
		take_while(|&n| n < upper).
		// That are odd
		filter(|n| n.is_odd()).
		// Sum them
		sum();
	println!("Functional style: {}", sum_of_squared_odd_numbers);
}
