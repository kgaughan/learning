(* Caesar cipher *)

let caesar_ch shift ch =
  let rotate lower =
    Char.chr (Char.code lower +
              (shift + Char.code ch - Char.code lower) mod 26) in
  if ch >= 'A' && ch <= 'Z' then
    rotate 'A'
  else if ch >= 'a' && ch <= 'z' then
    rotate 'a'
  else
    ch

let caesar shift s = String.map (caesar_ch shift) s

let _ =
  let shift = int_of_string Sys.argv.(1) in
  let s = Sys.argv.(2) in
  print_endline (caesar shift s)
