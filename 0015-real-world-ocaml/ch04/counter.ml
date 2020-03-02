open Base

type t = (string, int, String.comparator_witness) Map.t

let empty = Map.empty (module String)

let to_list x = Map.to_alist x

let touch counts line =
  let count =
    match Map.find counts line with
    | None -> 0
    | Some x -> x
  in Map.set counts ~key:line ~data:(count + 1)
