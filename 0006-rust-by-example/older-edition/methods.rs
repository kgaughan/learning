use std::num::abs;

struct Point {
	x: f64,
	y: f64,
}

// Implementation block; all Point methods go in here.
impl Point {
	// Static method; generally used for constructors.
	fn origin() -> Point {
		Point { x: 0.0, y: 0.0 }
	}

	// Another static method that takes two arguments
	fn new(x: f64, y: f64) -> Point {
		Point { x: x, y: y }
	}
}

struct Rectangle {
	p1: Point,
	p2: Point,
}

impl Rectangle {
	// Instance method; self refers to the caller object
	fn area(&self) -> f64 {
		// self gives access to the struct fields via the dot operator.
		let Point { x: x1, y: y1 } = self.p1;
		let Point { x: x2, y: y2 } = self.p2;

		abs((x1 - x2) * (y1 - y2))
	}

	fn perimeter(&self) -> f64 {
		let Point { x: x1, y: y1 } = self.p1;
		let Point { x: x2, y: y2 } = self.p2;

		2.0 * abs(x1 - x2) + 2.0 * abs(y1 - y2)
	}

	// This method requires the caller object to be mutable.
	fn move(&mut self, x: f64, y: f64) {
		self.p1.x += x;
		self.p2.x += x;
		self.p1.y += y;
		self.p2.y += y;
	}
}

struct Bomb {
	name: ~str,
}

impl Bomb {
	// This method consumes the caller object.
	fn boom(self) {
		println!("{} boes boom!", self.name);
		// self goes out of scope and is destroyed.
	}
}

fn main() {
	let rectangle = Rectangle {
		// Static methods are called using double semicolons.
		p1: Point::origin(),
		p2: Point::new(3.0, 4.0),
	};

	// Instance methods are called using the dot operator. Note that the
	// first argument, &self, is implicitly passed.
	println!("Rectangle perimeter: {}", rectangle.perimeter());
	println!("Rectangle area: {}", rectangle.area());

	let mut square = Rectangle {
		p1: Point::origin(),
		p2: Point::new(1.0, 1.0),
	};

	// Error: object is immutable, but moethod requires mutable object
	//rectangle.move(1.0, 1.0);
	
	// Ok: mutable object can call mutable methods.
	square.move(1.0, 1.0);

	let bomb = Bomb { name: ~"C4" };

	bomb.boom();

	// Error: previous boom() call moved the bomb out of scope.
	//bomb.boom();
}
