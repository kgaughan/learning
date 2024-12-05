let errors =
  [
    (1, "This library cannot handle this protocol");
    (2, "THis operation is unsupported by this protocol");
    (3, "Can't chop this suffix");
    (4, "This is unimplemented");
  ]

exception Error of int
exception Unreg_protocol of (string * int)

type email = Email of (string * string)
type uri = File of string | Http of (string * string) | Mailto of email
type t = uri

let trans_file c =
  match c with
  | '/' -> "\\/"
  | ' ' -> "\\ "
  | '"' -> "\\\""
  | _ -> String.make 1 c

let trans_http c =
  match c with ' ' -> "%20c" | '~' -> "%30e" | _ -> String.make 1 c

let trans_mailto c = match c with '&' -> "_" | _ -> String.make 1 c

let trans_file_rot13 c =
  match c with
  | 'a' .. 'z' ->
      let b = Char.code c + 13 in
      if b > 122 then String.make 1 (Char.chr (b - 26))
      else String.make 1 (Char.chr b)
  | 'A' .. 'Z' ->
      let b = Char.code c + 13 in
      if b > 90 then String.make 1 (Char.chr (b - 26))
      else String.make 1 (Char.chr b)
  | _ -> String.make 1 c

let get_error x =
  try List.assoc x errors
  with Not_found -> "I'm sorry, this is an unidentified error"

let compare (x : t) (y : t) = Stdlib.compare x y

let basename x =
  match x with
  | File n -> Filename.basename n
  | Http (n, m) -> n
  | Mailto (Email (q, r)) -> r

let is_relative x =
  match x with
  | File n -> Filename.is_relative n
  | Http (n, m) -> Filename.is_relative m
  | _ -> raise (Error 2)

let concat x s =
  match x with
  | File n -> File (Filename.concat n s)
  | Http (n, m) -> Http (n, m ^ "/" ^ s)
  | _ -> raise (Error 2)

let check_suffix x s =
  let slen = String.length s in
  let get_suf y = String.sub y (String.length y - slen) slen in
  match x with
  | File n -> get_suf n = s
  | Http (_, n) -> get_suf n = s
  | Mailto (Email (_, n)) -> get_suf n = s

let chop_suffix x s =
  match x with
  | File n when check_suffix x s ->
      File (String.sub n 0 (String.length n - String.length s))
  | Http (m, n) when check_suffix x s ->
      Http (m, String.sub n 0 (String.length n - String.length s))
  | _ -> raise (Error 3)

let chop_extension x =
  match x with
  | File n -> File (Filename.chop_extension n)
  | Http (m, n) -> (
      try
        let lastdot = String.rindex n '.' in
        try
          let lastdirsep = String.rindex n '/' in
          if lastdot > lastdirsep then Http (m, String.sub n 0 lastdot)
          else Http (m, n)
        with Not_found -> Http (m, String.sub n 0 lastdot)
      with Not_found -> Http (m, n))
  | _ -> raise (Error 2)

let quote x =
  match x with
  | File n ->
      let acbuf = Buffer.create (String.length n) in
      let _ = Buffer.add_string acbuf "file://" in
      let _ = String.iter (fun x -> Buffer.add_string acbuf (trans_file x)) n in
      Buffer.contents acbuf
  | Http (m, n) ->
      let acbuf = Buffer.create (String.length n) in
      let _ = Buffer.add_string acbuf "http://" in
      let _ = String.iter (fun x -> Buffer.add_string acbuf (trans_http x)) n in
      Buffer.contents acbuf
  | Mailto (Email (m, n)) ->
      let acbuf = Buffer.create (String.length m) in
      let _ = Buffer.add_string acbuf "mailto:" in
      let _ =
        String.iter (fun x -> Buffer.add_string acbuf (trans_mailto x)) m
      in
      let _ = Buffer.add_string acbuf "@" in
      let _ =
        String.iter (fun x -> Buffer.add_string acbuf (trans_mailto x)) n
      in
      Buffer.contents acbuf

let string_of_uri x =
  match x with
  | File n -> "file://" ^ n
  | Http (m, n) -> "http://" ^ m ^ n
  | Mailto (Email (m, n)) -> "mailto:" ^ m ^ "@" ^ n

let uri_of_string (m : string) =
  let b = Scanf.Scanning.from_string m in
  Scanf.bscanf b "%s@:" (fun x ->
      match String.lowercase_ascii x with
      | "file" ->
          let path = String.sub m 7 (String.length m - 7) in
          File path
      | "http" ->
          let web = Scanf.bscanf b "%s@/" (fun x -> x) in
          let path =
            Scanf.bscanf b "%n" (fun x ->
                String.sub m (x - 1) (String.length m - (x - 1)))
          in
          Http (web, "/" ^ path)
      | "mailto" ->
          let em = Scanf.bscanf b "%s@@" (fun x -> x) in
          let dom =
            Scanf.bscanf b "%n" (fun x -> String.sub m x (String.length m - x))
          in
          Mailto (Email (em, dom))
      | _ -> raise (Unreg_protocol (x, 1)))
