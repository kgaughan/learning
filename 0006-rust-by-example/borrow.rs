struct Book {
	author: ~str,
	title: ~str,
	year: uint,
}

// & means a reference to a Book; no ownership is taken.
fn borrow_book(book: &Book) {
	println!("I borrowed {}, {} edition", book.title, book.year);
}

// &mut means a mutable reference, meaning the fields of the struct can
// be modified
fn new_edition(book: &mut Book) {
	book.year = 2014;
}

fn main() {
	// An immutable Book
	let geb = Book {
		author: ~"Douglas Hofstadter",
		title: ~"Gödel, Escher, Bach",
		year: 1979,
	};

	// Borrow geb; geb can still be used afterwards
	borrow_book(&geb);

	// geb can be borrowed again, and again, and again...
	borrow_book(&geb);

	// A mutable Book
	let mut mutable_geb = Book {
		author: ~"Douglas Hofstadter",
		title: ~"Gödel, Escher, Bach",
		year: 1979,
	};

	// Error: can't borrow immutable object as mutable
	//new_edition(&mut geb);

	// Ok: borrow mutable object as mutable
	new_edition(&mut mutable_geb);

	// Ok: mutable objects can be immutably borrowed
	borrow_book(&mutable_geb);

	// When an object is mutably borrowed, the original can't be used
	// until its mutable reference goes out of scope.
	if true {
		let borrowed_geb = &mut mutable_geb;

		// Error: mutable_geb has been mutably borrowed.
		//println!("Can no longer access {}", mutable_geb.title);

		println!("The mutable reference of {} is available",
				 borrowed_geb.title);
		// Now borrowed_geb goes out of scope.
	}
	println!("Once again, I can access {}", mutable_geb.title);

	// Immutable borrows place no restriction on original owner.
	if true {
		let borrowed_geb = &mutable_geb;
		println!("The original is still accessible: {}",
				 mutable_geb.title);
		println!("and so is the immutable reference: {}",
				 borrowed_geb.title);
	}

	// ref can be used to take references when destructuring. Here geb_title
	// and geb_author are references to ~str, i.e., &~str. geb_year is a
	// copy of the year field.
	let Book {
		author: ref geb_author,
		title: ref geb_title,
		year: geb_year,
	} = geb;
}
