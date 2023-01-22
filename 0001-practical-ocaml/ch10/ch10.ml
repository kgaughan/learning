module Setofexceptions = Set.Make(struct type t = exn let compare = Pervasives.compare end)

let find xval ht =
  if (Hashtbl.mem ht xval) then
    Hashtbl.find ht xval
  else
    (Hashtbl.add ht xval 0; 0)

let betterfind xval ht =
  try
    Hashtbl.find ht xval
  with Not_found ->
    Hashtbl.add ht xval 0;
    0

let read_whole_file filename =
  let ichan = open_in filename in
  let ibuffer = Buffer.create 100 in
  try
    while true do
      let line = input_line ichan in
      Buffer.add_string buffer (line ^ "\n")
    done;
    ""
  with End_of_file ->
    close_in ichan;
    Buffer.contents ibuffer

(**
 * find an element and return it
 * @returns 'a
 * @raises Not_found
 *)
let find_in token lst = List.find token lst

let write_log_message filename message =
  let oc =
    try
      open_out_gen [Open_append] 0644 filename
    with Sys_error n -> open_out_gen [Open_append; Open_creat] 0644 filename
  in
    output oc message 0 (String.length message);
    close_out oc
