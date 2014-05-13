(* Vigenère cipher *)

let encrypt offset_x offset_y = offset_x + offset_y

let decrypt offset_x offset_y = offset_x + 26 - offset_y

let recta mode x y =
  let a = Char.code 'A' in
  let offset_x = Char.code x - a in
  let offset_y = Char.code y - a in
  Char.chr ((mode offset_x offset_y) mod 26 + a)

let cipher recta key text =
  let enc_ch i ch = recta ch key.[i mod String.length key] in
  let buf = Buffer.create (String.length text) in
  for i = 0 to String.length text - 1 do
    Buffer.add_char buf (enc_ch i text.[i])
  done;
  Buffer.contents buf

let _ =
  let recta =
    match Sys.argv.(1) with
    | "enc" -> recta encrypt
    | "dec" -> recta decrypt
    | _ -> exit 1 in
  let key = Sys.argv.(2) in
  let text = Sys.argv.(3) in
  print_endline (cipher recta key text)
