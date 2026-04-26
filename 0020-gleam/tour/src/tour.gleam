//// This is a module comment.

import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string as text

pub fn main() {
  io.println("Hello, Mike!")
  io.println(text.reverse("Hello, Joe!"))
  io.println("One " <> "Two")

  let add_one = fn(a) { a + 1 }
  echo twice(1, add_one)

  "Hello, Mike!"
  |> text.drop_end(1)
  |> text.drop_start(7)
  |> io.println

  let quantity = 5.0
  let unit_price = 10.0
  let discount = 0.2

  echo calculate_total_cost(quantity:, unit_price:, discount:)

  let x = int.random(5)
  let result = case x {
    // Match specific values
    0 -> "Zero"
    1 -> "One"

    // Match any other value
    other -> "It is " <> int.to_string(other)
  }
  io.println(result)

  echo get_name("Hello, Joe")
  echo get_name("Hello, Mike")
  echo get_name("System still working?")

  let list_x = list.repeat(int.random(5), times: int.random(3))
  echo list_x
  let list_result = case list_x {
    [] -> "Empty list"
    [1] -> "List of just 1"
    [4, ..] -> "List starting with 4"
    [_, _] -> "List of 2 elements"
    _ -> "Some other list"
  }
  echo list_result

  echo factorial(5)
  echo factorial(6)

  let sum = sum_list([18, 56, 35, 85, 91], 0)
  echo sum

  echo get_first_non_empty([[], [1, 2, 3], [4, 5]])
  echo get_first_non_empty([[1, 2], [3, 4, 5], []])
  echo get_first_non_empty([[], [], []])

  let numbers = [1, 2, 3, 4, 5]
  echo get_first_largest(numbers, 3)
  echo get_first_largest(numbers, 5)

  echo weather(Spring)
  echo weather(Autumn)

  let amy = Person("Amy", 26, True)
  let jared = Person(name: "Jared", age: 31, needs_glasses: True)
  let tom = Person("Tom", 28, needs_glasses: False)

  let friends = [amy, jared, tom]
  echo friends

  handle_fish(Starfish("Lucy", "Pink"))
  handle_ice_cream(IceCream("strawberry"))

  echo <<3>>
  echo <<"Hello, Joe!":utf8>>

  let ints = [0, 1, 2, 3, 4, 5]

  io.println("=== list.map ===")
  let _ = echo list.map(ints, fn(x) { x * 2 })

  io.println("=== list.filter ===")
  let _ = echo list.filter(ints, fn(x) { x % 2 == 0 })

  io.println("=== list.fold ===")
  let _ = echo list.fold(ints, 0, fn(count, e) { count + e })

  io.println("=== list.find ===")
  let _ = echo list.find(ints, fn(x) { x > 3 })
  let _ = echo list.find(ints, fn(x) { x > 13 })

  io.println("=== result.map ===")
  let _ = echo result.map(Ok(1), fn(x) { x * 2 })
  let _ = echo result.map(Error(1), fn(x) { x * 2 })

  io.println("=== result.try ===")
  let _ = echo result.try(Ok("1"), int.parse)
  let _ = echo result.try(Ok("no"), int.parse)
  let _ = echo result.try(Error(Nil), int.parse)

  io.println("=== result.unwrap ===")
  let _ = echo result.unwrap(Ok("1234"), "default")
  let _ = echo result.unwrap(Error(Nil), "default")

  io.println("=== pipeline ===")
  int.parse("-1234")
  |> result.map(int.absolute_value)
  |> result.try(int.remainder(_, 42))
  |> echo

  let scores = dict.from_list([#("Lucy", 13), #("Drew", 15)])
  echo scores

  let scores =
    scores
    |> dict.insert("Bushra", 16)
    |> dict.insert("Darius", 14)
    |> dict.delete("Drew")
  echo dict.to_list(scores)

  let person_with_pet = PetOwner("Al", Some("Nubi"))
  let person_without_pet = PetOwner("Maria", None)
  echo person_with_pet
  echo person_without_pet

  let positive = new(1)
  let zero = new(0)
  let negative = new(-1)

  echo to_int(positive)
  echo to_int(zero)
  echo to_int(negative)

  let _ = echo with_use()
  let _ = echo without_use()

  let _ = echo now()

  let _ = echo reverse_list([1, 2, 3, 4, 5])
  let _ = echo reverse_list(["a", "b", "c", "d", "e"])
}

/// Do something to something twice
fn twice(argument: value, my_function: fn(value) -> value) -> value {
  my_function(my_function(argument))
}

/// Get the total cost with any discounts applied.
fn calculate_total_cost(
  quantity quantity: Float,
  unit_price price: Float,
  discount discount: Float,
) -> Float {
  let subtotal = quantity *. price
  let discount = subtotal *. discount
  subtotal -. discount
}

fn get_name(x: String) -> String {
  case x {
    "Hello, " <> name -> name
    _ -> "Unknown"
  }
}

fn factorial(x: Int) -> Int {
  factorial_loop(x, 1)
}

fn factorial_loop(x: Int, accumulator: Int) -> Int {
  case x {
    // Base cases
    0 | 1 -> accumulator
    // Recursive case
    _ -> factorial_loop(x - 1, accumulator * x)
  }
}

fn sum_list(list: List(Int), total: Int) -> Int {
  case list {
    [first, ..rest] -> sum_list(rest, total + first)
    [] -> total
  }
}

fn get_first_non_empty(lists: List(List(t))) -> List(t) {
  case lists {
    [[_, ..] as first, ..] -> first
    [_, ..rest] -> get_first_non_empty(rest)
    [] -> []
  }
}

fn get_first_largest(numbers: List(Int), limit: Int) -> Int {
  case numbers {
    [first, ..] if first > limit -> first
    [_, ..rest] -> get_first_largest(rest, limit)
    [] -> 0
  }
}

pub type Season {
  Spring
  Summer
  Autumn
  Winter
}

fn weather(season: Season) -> String {
  case season {
    Spring -> "Mild"
    Summer -> "Hot"
    Autumn -> "Windy"
    Winter -> "Cold"
  }
}

pub type Person {
  Person(name: String, age: Int, needs_glasses: Bool)
}

pub type Fish {
  Starfish(name: String, favourite_colour: String)
  Jellyfish(name: String, jiggly: Bool)
}

pub type IceCream {
  IceCream(flavour: String)
}

fn handle_fish(fish: Fish) {
  case fish {
    Starfish(_, favourite_colour) -> io.println(favourite_colour)
    Jellyfish(name, ..) -> io.println(name)
  }
}

fn handle_ice_cream(ice_cream: IceCream) {
  let IceCream(flavour) = ice_cream
  io.println(flavour)
}

pub type PetOwner {
  PetOwner(name: String, pet: Option(String))
}

pub opaque type PositiveInt {
  PositiveInt(inner: Int)
}

pub fn new(i: Int) -> PositiveInt {
  case i >= 0 {
    True -> PositiveInt(i)
    False -> PositiveInt(0)
  }
}

pub fn to_int(i: PositiveInt) -> Int {
  i.inner
}

pub fn with_use() -> Result(String, Nil) {
  use username <- result.try(get_username())
  use password <- result.try(get_password())
  use greeting <- result.map(log_in(username, password))
  greeting <> ", " <> username
}

pub fn without_use() -> Result(String, Nil) {
  result.try(get_username(), fn(username) {
    result.try(get_password(), fn(password) {
      result.map(log_in(username, password), fn(greeting) {
        greeting <> ", " <> username
      })
    })
  })
}

fn get_username() -> Result(String, Nil) {
  Ok("alice")
}

fn get_password() -> Result(String, Nil) {
  Ok("hunter2")
}

fn log_in(_username: String, _password: String) -> Result(String, Nil) {
  Ok("welcome")
}

pub type DateTime

@external(erlang, "calendar", "local_time")
@external(javascript, "./my_package_ffi.mjs", "now")
pub fn now() -> DateTime

@external(erlang, "lists", "reverse")
pub fn reverse_list(items: List(e)) -> List(e) {
  tail_recursive_reverse(items, [])
}

fn tail_recursive_reverse(items: List(e), reversed: List(e)) -> List(e) {
  case items {
    [] -> reversed
    [first, ..rest] -> tail_recursive_reverse(rest, [first, ..reversed])
  }
}
