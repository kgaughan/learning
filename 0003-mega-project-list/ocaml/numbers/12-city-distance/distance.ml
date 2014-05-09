(*
 * Calculate the distance between two locations given their longitude and
 * latitude. To do this, we use the haversine function:
 *
 *   http://en.wikipedia.org/wiki/Haversine_formula
 *)

(* Approximate of the radius of the earth, according to Google. *)
let earth = 6378.1;;

(* pi isn't in the standard library, which makes *no* sense to me. *)
let pi = 4.0 *. atan 1.0;;

let rad x = pi *. x /. 180.0;;

let haversin x = (sin (x /. 2.0)) ** 2.0;;

let haversine r (long1, lat1) (long2, lat2) =
  let h = haversin (lat2 -. lat1) +.
          cos lat1 *. cos lat2 *. haversin (long2 -. long1) in
  2.0 *. r *. asin (sqrt h);;

let ask_location prompt =
  print_string prompt;
  print_string ":\nLongitude? ";
  let long = rad (read_float ()) in
  print_string "Latitude? ";
  let lat = rad (read_float ()) in
  (long, lat);;

let main () =
  let loc1 = ask_location "First location" in
  let loc2 = ask_location "Second location" in
  Printf.printf "Distance is %f\n" (haversine earth loc1 loc2);;

main ();;
