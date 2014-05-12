(*
 * I grabbed this formula from Wikipedia. This is apparently the formula
 * used in the US for fixed rate mortgages. I'm not sure if it varies
 * elsewhere.
 *
 * http://en.wikipedia.org/wiki/Mortgage_calculator
 *)

let monthly_payment principal rate term =
  let monthly = rate /. 12.0 /. 100.0 in
  (principal *. monthly) /. (1.0 -. (1.0 +. monthly) ** -. term)

let prompt_for prompt =
  print_string prompt;
  read_float ()

let _ =
  let principal = prompt_for "Principal? " in
  let rate = prompt_for "Rate (percent)? " in
  let term = floor (prompt_for "Term? ") in
  Printf.printf "Given a principal %0.2f at %.2f%% for %.0f months,\n"
                principal rate term;
  Printf.printf "you would pay %0.2f per month.\n"
                (monthly_payment principal rate term)
