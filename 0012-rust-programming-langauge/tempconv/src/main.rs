use std::io;

fn to_fahrenheit(value: f32) -> f32 {
    (value * 9.0 / 5.0) + 32.0
}

fn to_celsius(value: f32) -> f32 {
    (value - 32.0) * 5.0 / 9.0
}

fn main() {
    println!("Would you like to convert from [C]elsius or [F]ahrenheit?");
    let mut source = String::new();
    io::stdin()
        .read_line(&mut source)
        .expect("Failed to read line");
    let converter = if source.trim().to_lowercase().starts_with("f") {
        to_celsius
    } else {
        to_fahrenheit // I'm being lazy.
    };

    let mut temperature = String::new();
    loop {
        println!("What's your temperature?");
        io::stdin()
            .read_line(&mut temperature)
            .expect("Failed to read line");
        let temperature: f32 = match temperature.trim().parse() {
            Ok(num) => num,
            Err(_) => {
                println!("Couldn't parse that; try again.");
                continue;
            }
        };

        println!("That converts to {}", converter(temperature));
        return;
    }
}
