open Core
open Base.Poly

let compute_bounds ~compare list =
  let sorted = List.sort ~compare list in
  match List.hd sorted, List.last sorted with
  | None, _ | _, None -> None
  | Some x, Some y -> Some (x, y)

(*
let find_mismatches_oldschool table1 table2 =
  let f key data mismatches =
    match Hashtbl.find table2 key with
    | Some data' when data' <> data -> key :: mismatches
    | _ -> mismatches
  in Hashtbl.fold f table1 []
 *)

let find_mismatches table1 table2 =
  Hashtbl.fold table1 ~init:[] ~f:(fun ~key ~data mismatches ->
    match Hashtbl.find table2 key with
    | Some data' when data' <> data -> key :: mismatches
    | _ -> mismatches
  )

let compute_bounds_monadic ~compare list =
  let sorted = List.sort ~compare list in
  Option.bind (List.hd sorted) ~f:(fun first ->
    Option.bind (List.last sorted) ~f:(fun last ->
      Some (first, last)))

let compute_bounds_infix ~compare list =
  let open Option.Monad_infix in
  let sorted = List.sort ~compare list in
  List.hd sorted >>= fun first ->
    List.last sorted >>= fun last ->
      Some (first, last)

let compute_bounds_both ~compare list = 
  let sorted = List.sort ~compare list in
  Option.both (List.hd sorted) (List.last sorted)
