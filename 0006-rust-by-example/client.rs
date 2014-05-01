use common::SOCKET_PATH;
use std::io::net::unix::UnixStream;
use std::os;

mod common;

fn main() {
	// args is an array of the arguments passed into the program.
	let args = os::args();
	let socket = Path::new(SOCKET_PATH);

	// First argument is the message to be sent.
	let message = match args.as_slice() {
		[_, ref message] => message.as_slice(),
		_ => fail!("Wrong number of arguments."),
	};

	// Connect to socket.
	let mut stream = match UnixStream::connect(&socket) {
		Err(_) => fail!("Server is not running."),
		Ok(stream) => stream,
	};

	// Send message
	match stream.write_str(message) {
		Err(_) => fail!("Couldn't send message"),
		Ok(_) => {},
	};
}
