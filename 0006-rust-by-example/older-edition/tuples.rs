fn chipanzees() -> (int, &str) {
	(6, "Pan troglodytes")
}

fn elephants() -> (int, &str) {
	(9, "Elephas maximus")
}

fn penguins() -> (int, &str) {
	(4, "Spheniscus demersus")
}

fn wolves() -> (int, &str) {
	(6, "Canis lupus")
}

fn show(pair: (int, &str)) {
	let (amount, species) = pair;
	println!("There are {} {}", amount, species);
}

fn main() {
	let long_tuple = (1u8, 2u16, 3u32, 4u64,
					  -1i8, -2i16, -3i32, -4i64,
					  0.1f32, 0.2f64,
					  'a', "abc");

	println!("long tuple first value: {}", long_tuple.val0());
	println!("long tuple second value: {}", long_tuple.val1());

	let pair = (3, 4);
	let (x, y) = pair;
	println!("x is {}, and y is {}", x, y);
	println!("pair is {}", pair);

	let tuple_of_tuples = ((1u8, 2u16, 2u32), (4u64, -1i8), -2i16);

	println!("Animal inventory");
	show(chipanzees());
	show(elephants());
	show(penguins());
	show(wolves());
}
