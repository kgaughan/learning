open Printf;;

let main () =
  print_string "Width? ";
  let width = read_float () in
  print_string "Height? ";
  let height = read_float () in
  print_string "Cost per tile? ";
  let cost = read_float() in
  Printf.printf "Total cost is: %0.2f\n" (width *. height *. cost);;

main ();;
