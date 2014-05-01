// A tuple struct that can be compared
#[deriving(Eq, Ord)]
struct Centimetres(f64);

// A tuple struct that can be printed
#[deriving(Show)]
struct Inches(int);

impl Inches {
	fn to_centimetres(&self) -> Centimetres {
		let &Inches(inches) = self;
		Centimetres(inches as f64 * 2.54)
	}
}

// A vanilla tuple struct
struct Seconds(int);

fn main() {
	let one_second = Seconds(1);
	let another_second = Seconds(1);

	// Error: Seconds can't be printed (doesn't implement the Show trait)
	//println!("{}", one_second);
	
	// Error: Seconds can't be compared.
	//let this_is_true = one_second == another_second;
	
	let foot = Inches(12);

	println!("{}", foot);

	let metre = Centimetres(100.0);

	if foot.to_centimetres() < metre {
		println!("A foot is smaller than a metre");
	} else {
		println!("A foot is bigger than a metre");
	}
}
