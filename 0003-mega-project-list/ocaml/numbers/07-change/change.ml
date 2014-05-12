(* Change calculation. *)

(* Typical European change denominations. *)
let coins = [200; 100; 50; 20; 10; 5; 2; 1]

(* Returns a list of tuples in the form [(unit, amount)] *)
let rec change amt coins =
  match coins with
  | [] -> []
  | h :: t ->
      if h <= amt then
        (h, amt / h) :: (change (amt mod h) t)
      else
        (change amt t)

let _ =
  print_string "Change (in cents)? ";
  let amt = read_int () in
  let amts = change amt coins in 
  print_string "Your change is:\n";
  List.iter (fun (u, a) -> Printf.printf "%d of %d\n" a u) amts
