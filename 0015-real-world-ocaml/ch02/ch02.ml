let area_of_ring inner_radius outer_radius =
  let pi = acos (-1.) in
  let area_of_circle r = pi *. r *. r in
  area_of_circle outer_radius -. area_of_circle inner_radius

let upcase_first_entry line =
  match String.split ~on:',' line with
  | [] -> assert false (* String.split returns at least one element *)
  | first :: rest -> String.concat ~sep:"," (String.uppercase first :: rest)

let rec find_first_stutter = function
  | [] | [_] -> None (* only zero or one elements, so no repeats *)
  | x :: y :: tl ->
      if x = y then
        Some x
      else
        find_first_stutter (y :: tl)

let rec is_even x =
  if x = 0 then true else is_odd (x - 1)
and is_odd x =
  if x = 0 then false else is_even (x - 1)

let (+!) (x1, y1) (x2, y2) =
  (x1 + x2, y1 + y2)

let ( *** )  x y =
  (x ** y) ** y

let (|>) x f = f x

let some_or_zero = function
  | Some x -> x
  | None -> 0

let ratio ~num ~denom =
  float num /. float denom

(* optional arguments with boilerplace *)
let concat ?sep x y =
  let sep =
    match sep with
    | None -> ""
    | Some x -> x
  in x ^ sep ^ y

(*
 * optional arguments without boilerplate; putting 'sep' second prevents
 * erasure due to partial application on first argument
 *)
let concat1 x ?(sep="") y =
  x ^ sep ^ y

let uppercase_concat ?(sep="") a b =
  concat ~sep (String.uppercase a) b

let numeric_deriv ~delta ~x ~y ~f =
  let x' = x +. delta in
  let y' = y +. delta in
  let base = f ~x ~y in
  let dx = (f ~x:x' ~y -. base) /. delta in
  let dy = (f ~x ~y:y' -. base) /. delta in
  (dx, dy)

(* with type of 'f' explicitly annotated *)
let numeric_deriv1 ~delta ~x ~y ~(f: x: float -> y: float -> float) =
  let x' = x +. delta in
  let y' = y +. delta in
  let base = f ~x ~y in
  let dx = (f ~x:x' ~y -. base) /. delta in
  let dy = (f ~x ~y:y' -. base) /. delta in
  (dx, dy)

let colon_concat = concat ~sep:":"
