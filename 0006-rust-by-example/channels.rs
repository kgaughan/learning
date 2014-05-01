use std::comm::channel;

static NTASKS: int = 5;

fn main() {
	// Channels have two endpoints: the Sender<T> and the Receiver<T>,
	// where T is the type of the messae to be transferred (type
	// annotation is superfluous).
	let (tx, rx): (Sender<_>, Receiver<_>) = channel();

	for id in range(0, NTASKS) {
		// The sender endpoint can be copied.
		let tx = tx.clone();

		// Each task will send its ID via the channel.
		spawn(proc() {
			// Queue message in the channel.
			tx.send(id);

			// Sending is a non-blocking operation: the task will
			// continue immediately after sending its message.
			println!("Task number {} finished", id);
		});
	}

	// Here all the tasks are collected.
	for _ in range(0, NTASKS) {
		// The recv() methods picks a message from the channel.
		let id = rx.recv();
		println!("Task number {} reported.", id);
	}

	// Receiving blocks the task if there is no message available until
	// a new message arrives.
	rx.recv();

	println!("This point will never be reached!");
}
