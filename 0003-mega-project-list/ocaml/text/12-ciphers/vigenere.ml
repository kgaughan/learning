(* Vigenère cipher *)

let recta x y =
  let a = Char.code 'A' in
  let offset_x = Char.code x - a in
  let offset_y = Char.code y - a in
  Char.chr ((offset_x + offset_y) mod 26 + a)

let encrypt key text =
  let enc_ch i ch = recta ch key.[i mod String.length key] in
  let buf = Buffer.create (String.length text) in
  for i = 0 to String.length text - 1 do
    Buffer.add_char buf (enc_ch i text.[i])
  done;
  Buffer.contents buf

let _ =
  let key = Sys.argv.(1) in
  let text = Sys.argv.(2) in
  print_endline (encrypt key text)
