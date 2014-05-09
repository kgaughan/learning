let explode s =
  let rec exp i l = if i < 0 then l else exp (i - 1) (s.[i] :: l)
  in exp (String.length s - 1) []

(* Convert a list into a list of pair of adjacent elements. *)
let pairs l pad =
  let rec iter l =
    match l with
    | e1 :: e2 :: t -> (e1, e2) :: iter t
    | e1 :: [] -> [(e1, pad)]
    | [] -> []
  in iter l

exception Bad_digit

let char_to_int c =
  if c >= '0' && c <= '9' then
    Char.code(c) - Char.code('0')
  else
    raise Bad_digit

let sum l = List.fold_left (+) 0 l

(* Calculate the Luhn checksum of a string of digits. *)
let luhn s =
  let double_sum n = if n < 5 then n * 2 else 1 + (n * 2 mod 10) in
  let (first, second) =
    List.split (pairs (List.map char_to_int (explode s)) 0) in
  (sum first + sum (List.map double_sum second)) mod 10 = 0

let _ =
  if luhn Sys.argv.(1) then
    print_string "passes\n"
  else
    print_string "fails\n"
