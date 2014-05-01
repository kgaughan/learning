struct Homework;

// This function takes ownership of a Homework object
fn dog_eats_homework(homework: ~Homework) {
	// homework is destroyed in this scope; memory is freed from the heap
}

fn main() {
	let homework = ~Homework;

	// Give up ownership of homework
	dog_eats_homework(homework);

	// Error: homework has moved out of this scope
	//dog_eats_homework(homework);

	// Blocks have their own scope; boxed_int goes out of scope and memory
	// is freed from the heap at the end of the block.
	if true {
		let boxed_int = ~5;
	}

	// Error: boxed_int doesn't exist in this scope
	//let another_boxed_int = boxed_int;
}
