// Linked list node
enum Node {
	// data (uint) -> next_node (~Node)
	Cons(uint, ~Node),
	// Terminal node
	Nil,
}

impl Node {
	// Return the head of the list.
	fn head(&self) -> Option<uint> {
		match self {
			&Cons(head, _) => Some(head),
			&Nil => None,
		}
	}

	fn len(&self) -> uint {
		match self {
			// Can't move tail out of the list; instead, take a reference.
			&Cons(_, ref tail) => 1 + tail.len(),
			&Nil => 0,
		}
	}

	fn tail(self) -> Option<Node> {
		match self {
			Nil => None,
			// Unbox the tail.
			Cons(_, tail) => Some(*tail),
		}
	}
}

fn main() {
	// Linked list: 1 -> 2 -> 3 -> Nil
	let mut list = Cons(1, ~Cons(2, ~Cons(3, ~Nil)));
	println!("List size: {}", list.len());

	// Continuously behead the list until it's empty.
	loop {
		let head = list.head();

		list = match list.tail() {
			None => break,
			Some(tail) => tail,
		};

		println!("List head: {}", head.unwrap());
	}
}
