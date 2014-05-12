(* Integer factorisation. *)

let rec print_int_list =
  List.iter (fun n -> print_int n; print_string " ")

let is_composite primes m =
  List.exists (fun prime -> m mod prime == 0) primes

(* Simple prime sieve generating all the primes up to n. *)
let sieve n =
  let rec sieve_rec primes m =
    if m > n then
      primes
    else
      sieve_rec (if is_composite primes m then primes else (m :: primes))
                (m + 1)
  in sieve_rec [] 2

(* Perform integer factorisation on `n`. *)
let int_factors n =
  let rec int_fact remaining m =
    match remaining with
    | h :: t -> if m mod h == 0
                then h :: (int_fact remaining (m / h))
                else (int_fact t m)
    | _ -> []
  in
  int_fact (sieve n) n

let _ =
  let arg = int_of_string Sys.argv.(1) in
  print_int_list (int_factors arg);
  print_newline ();
  exit 0
