fn main() {
	let mut count = 0;

	println!("Let's count until infinity!");

	// Infinite loop
	loop {
		count += 1;

		if count == 3 {
			// Skip this iteration
			continue
		}

		println!("{}", count);

		if count == 5 {
			println!("OK, that's enough");
			// Exit this loop
			break
		}
	}
}
