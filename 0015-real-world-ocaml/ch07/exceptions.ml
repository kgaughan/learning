open Core
open Base.Poly

exception Key_not_found of string

let rec find_exn alist key =
  match alist with
  | [] -> raise (Key_not_found key)
  | (key', data) :: tl ->
      if key = key' then
        data
      else
        find_exn tl key

exception Wrong_date of Date.t [@@deriving sexp]

let failwith msg =
  raise (Failure msg)

let merge_lists xs ys ~f =
  if List.length xs <> List.length ys then
    None
  else
    let rec loop xs ys =
      match xs, ys with
      | [], [] -> []
      | x::xs, y::ys -> f x y :: loop xs ys
      | _ -> assert false
    in
    Some (loop xs ys)


let merge_lists_assert xs ys ~f =
  let rec loop xs ys =
    match xs, ys with
    | [], [] -> []
    | x::xs, y::ys -> f x y :: loop xs ys
    | _ -> assert false
  in
  loop xs ys

let load_reminders filename =
  let inc = In_channel.create filename in
  let reminders = [%of_sexp: ((Time_unix.t * string) list)] (Sexp.input_sexp inc) in
  In_channel.close inc;
  reminders

let load_reminders_catch filename = 
  let inc = In_channel.create filename in
  protect ~f:(fun () -> [%of_sexp: ((Time_unix.t * string) list)] (Sexp.input_sexp inc))
          ~finally:(fun () -> In_channel.close inc)

let load_reminders_idiomatic filename =
  In_channel.with_file filename ~f:(fun inc ->
    [%of_sexp: ((Time_unix.t * string) list)] (Sexp.input_sexp inc))

let lookup_weight ~compute_weight alist key =
  match List.Assoc.find ~equal:(=) alist key with
  | None -> 0.
  | Some data -> compute_weight data

let find alist key =
  Option.try_with (fun () -> find_exn alist key)

let find_aware alist key =
  Or_error.try_with (fun () -> find_exn alist key)
