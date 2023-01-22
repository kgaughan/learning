(* Fast version of fib.ml *)

let fib n =
  let rec ifib m2 m1 m0 =
    if m0 < 2 then m2 + m1
              else ifib m1 (m2 + m1) (m0 - 1)
  in ifib 0 1 n

let main () =
  let arg = int_of_string Sys.argv.(1) in
  print_int (fib arg);
  print_newline ();
  exit 0

main ()
