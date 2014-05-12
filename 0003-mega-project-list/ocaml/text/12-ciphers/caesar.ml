(* Caesar cipher *)

let caesar shift s =
  let rotate lower ch =
    Char.chr (Char.code lower +
              (shift + Char.code ch - Char.code lower) mod 26) in
  let caesar_ch ch =
    if ch >= 'A' && ch <= 'Z' then
      rotate 'A' ch
    else if ch >= 'a' && ch <= 'z' then
      rotate 'a' ch
    else
      ch
  in String.map caesar_ch s

let _ =
  let shift = int_of_string Sys.argv.(1) in
  let s = Sys.argv.(2) in
  print_endline (caesar shift s)
