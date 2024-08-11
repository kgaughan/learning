use std::io::timer::Timer;

fn main() {
	// Create a timer object.
	let mut timer = Timer::new().unwrap();

	// Create a one-shot notification (type annotation is superfluous).
	let oneshot: Receiver<()> = timer.oneshot(3000);

	println!("Hold on...");

	// Block the task until timeout.
	oneshot.recv();

	// The same timer can be used to generate periodic notifications.
	let metronome = timer.periodic(1000);

	let mut count = 0;

	println!("Start counting!");
	loop {
		// Loop will run once per second.
		metronome.recv();

		count += 1;
		println!("{}", count);
	}
}
