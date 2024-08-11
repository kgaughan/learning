struct Book {
	author: ~str,
	title: ~str,
	year: int,
}

impl Book {
	// 'a is the lifetime of the caller object. This method will borrow the
	// author field for as long as the caller object is alive.

	fn author<'a>(&'a self) -> &'a str {
		// as_slice() borrows an owned string (~str) as &str
		self.author.as_slice()
	}

	fn title<'a>(&'a self) -> &'a str {
		self.title.as_slice()
	}
}

fn feed_bookworms(book: Book) {
	// Destroys book.
}

fn main() {
	// This integer lifeine is the same as main(). Let's name it 'main.
	let stack_allocated_int = 0;

	// Let's call get lifetime 'geb.
	let geb = Book {
		author: ~"Douglas Hofstadter",
		title: ~"Gödel, Escher, Bach",
		year: 1979,
	};

	// Error: author takes ownership of geb; now geb owns nothing, and
	// title can't take the field title from geb.
	//let author = geb.author;
	//let title = geb.title;
	
	{
		// Let's call this scope 'submain.

		// These variables have the type &'geb str, but their lifetime
		// is 'submain.
		let author: &str = geb.author();
		let title = geb.title();

		// Error: can't destroy the book here because it's borrowed in the
		// 'submain scope.
		//feed_bookworms(geb);

		// end of 'submain; author and title get destroyed
	}

	// Here, the lifetime 'geb is over. Not that 'geb < 'main.
	feed_bookworms(geb);

	// Error: 'geb is over; can't take any of its fields.
	//let year = geb.year;
	
	// End of 'main.
}
