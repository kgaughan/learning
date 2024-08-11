enum Day {
	Monday,
	Tuesday,
	Wednesday,
	Thursday,
	Friday,
	Saturday,
	Sunday,
}

impl Day {
	fn mood(&self) {
		println!("{}", match self {
			&Friday => "It's Friday!",
			&Saturday | &Sunday => "Weekend! :-)",
			_ => "Weekday...",
		})
	}
}

// Enum with explicit discriminator.
enum Colour {
	Red = 0xFF0000,
	Green = 0x00FF00,
	Blue = 0x0000FF,
}

fn main() {
	let today = Monday;

	today.mood();

	println!("Roses are \\#{:06x}", Red as int);
	println!("Violets are \\#{:06x}", Blue as int);
}
