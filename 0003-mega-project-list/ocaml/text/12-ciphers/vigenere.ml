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
  let enc = ref true in
  let key = ref "" in
  let text = ref "" in
  let usage = "Usage: vigenere [-enc|-dec] [-key string] [-text string]" in
  let specs = [
    ("-enc", Arg.Set enc, "Encode text (default)");
    ("-dec", Arg.Clear enc, "Decode text");
    ("-key", Arg.Set_string key, "Key for coding/decoding");
    ("-text", Arg.Set_string text, "Text to encode/decode");
  ] in
  Arg.parse specs (fun x -> raise (Arg.Bad ("Bad argument : " ^ x))) usage;
  let recta = recta (if !enc then encrypt else decrypt) in
  print_endline (cipher recta !key !text)
