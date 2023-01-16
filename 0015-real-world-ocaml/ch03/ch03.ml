open Base
open Core

let rec sum = function
  | [] -> 0
  | hd :: tl -> hd + sum tl

let rec drop_value to_drop = function
  | [] -> []
  | hd :: tl ->
      let new_tl = drop_value to_drop tl in
      if hd = to_drop then new_tl else hd :: new_tl

let rec drop_zero = function
  | [] -> []
  | 0 :: tl -> drop_zero tl
  | hd :: tl -> hd :: drop_zero tl

let plus_one_match = function
  | 0 -> 1
  | 1 -> 2
  | 2 -> 3
  | x -> x + 1

let max_widths header rows =
  let lengths l = List.map ~f:String.length l in
  List.fold rows
    ~init:(lengths header)
    ~f:(fun acc row -> List.map2_exn ~f:Int.max acc (lengths row))

let render_separator widths =
  let pieces = List.map widths ~f:(fun w -> String.make (w + 2) '-') in
  "|" ^ (String.concat ~sep:"+" pieces) ^ "|"

let pad s length =
  " " ^ s ^ (String.make (length - String.length s + 1) ' ')

let render_row row widths =
  let padded = List.map2_exn row widths ~f:pad in
  "|" ^ (String.concat ~sep:"|" padded) ^ "|"

let render_table header rows =
  let widths = max_widths header rows in
  let rendered_lines =
    (render_row header widths) ::
    (render_separator widths) ::
    List.map rows ~f:(fun row -> render_row row widths) in
  String.concat ~sep:"\n" rendered_lines

let is_ocaml_source s =
  match String.rsplit2 s ~on:'.' with
  | Some (_, ("ml" | "mli")) -> true
  | _ -> false

let rec ls_rec s =
  if Sys.is_file_exn ~follow_symlinks:true s then
    [s]
  else
    (* |> is like & in Haskell, a reverse application operator, much like a
     * pipeline. ^/ is the filename concatenation operator. *)
    Sys.ls_dir s |> List.concat_map ~f:(fun sub -> ls_rec (s ^/ sub))

let len lst =
  let rec acc n = function
    | [] -> n
    | _ :: tl -> acc (n + 1) tl
  in acc 0 lst

let rec destutter = function
  | [] | [_] as l -> l
  | hd1 :: (hd2 :: _ as tl) when hd1 = hd2 -> destutter tl
  | hd :: tl -> destutter tl

let rec count_some = function
  | [] -> 0
  | None :: tl -> count_some tl
  | _ :: tl -> 1 + count_some tl

let count_some_fast = List.count ~f:Option.is_some
