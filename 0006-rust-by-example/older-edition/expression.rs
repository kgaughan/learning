fn is_divisible_by(this: uint, that: uint) -> bool {
	if that == 0 {
		false
	} else {
		this % that == 0
	}
}

fn fizzbuzz(n: uint) {
	println!("{}",
		if is_divisible_by(n, 15) {
			~"fizzbuzz"
		} else if is_divisible_by(n, 3) {
			~"fizz"
		} else if is_divisible_by(n, 5) {
			~"buzz"
		} else {
			format!("{}", n)
		}
	)
}

fn main() {
	for n in range(1u, 101) {
		fizzbuzz(n)
	}
}
