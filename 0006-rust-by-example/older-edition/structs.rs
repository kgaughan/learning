// Unit struct
struct Nil;

// Tuple struct
struct Pair(int, f64);

// Struct with two fields
struct Point {
	x: f64,
	y: f64,
}

struct Rectangle {
	p1: Point,
	p2: Point,
}

fn main() {
	let point = Point { x: 3.0, y: 4.0 };

	println!("Point coordinates: ({}, {})", point.x, point.y);

	let Point { x: my_x, y: my_y } = point;

	let rectangle = Rectangle {
		p1: Point { x: my_y, y: my_x },
		p2: point,
	};

	let nil = Nil;

	let pair = Pair(1, 0.0);

	let Pair(integer, decimal) = pair;
}
