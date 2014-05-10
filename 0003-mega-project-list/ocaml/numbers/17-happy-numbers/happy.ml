(* Why isn't this already in the the standard libraries?! *)
module IntSet = Set.Make(struct
  let compare = Pervasives.compare
  type t = int
end)

let sum_square_of_digits n =
  let squares = Array.init 10 (fun i -> i * i) in
  let rec iter n acc =
    if n == 0 then acc else iter (n / 10) (acc + squares.(n mod 10))
  in iter n 0

let is_happy n =
  let rec iter n checked =
    if n == 1 then
      true
    else if IntSet.mem n checked then
      false
    else
      iter (sum_square_of_digits n) (IntSet.add n checked)
  in iter n IntSet.empty

let _ =
  let arg = int_of_string Sys.argv.(1) in
    Printf.printf "%d is %s\n"
                  arg
                  (if is_happy arg then "happy!" else "sad");
