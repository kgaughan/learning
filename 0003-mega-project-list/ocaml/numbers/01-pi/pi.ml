(*
 * Calculate pi to the nth digit.
 *
 * There are a number of formulae here for doing it:
 * http://mathworld.wolfram.com/PiFormulas.html
 *
 * I think the best one to implement would be (9):
 *
 * PI = sigma(2 * (-1 ** k) * (3 ** (0.5 - k)) /
 *            2 * k + 1); k = 0..inf
 *
 * I'm cheating on this a little by (a) using built-in floats which have
 * limited precision and (b) just doing the 25 iterations needed to get PI to
 * the number of iterations a float can support.
 *
 * It strikes me that I'd be able to implement this more neatly in Haskell by
 * using a lazy list mapped by iter and summed.
 *)

let pi n =
  let iter k = 2.0 *. (-1.0 ** k) *. (3.0 ** (0.5 -. k)) /. (2.0 *. k +. 1.0) in
  let rec loop n v = if n >= 0.0 then loop (n -. 1.0) (v +. iter n) else v in
  loop n 0.0;;

let main () =
  print_float (pi 25.0);
  print_newline ();
  exit 0;;

main ();;
