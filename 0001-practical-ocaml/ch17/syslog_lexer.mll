{
open Syslog_parser
}

let time = ['0'-'2']['0'-'9']':'['0'-'6']['0'-'9']':'['0'-'6']['0'-'9']

rule tokens = parse
| [' ' '\t']+ { tokens lexbuf }
| (['a'-'z' 'A'-'Z']+[' ']+['0'-'9']+[' ']+time as dt) { DATETIME(dt) }
| ':' { COLON }
| ['a'-'z' 'A'-'Z' '#' '[' ']' '(' ')' '0'-'9' '.' ',' '=' '/' '\\' '-' '@' '_' '!' '%' '^' '&' '*' '~' '"' ''' '`' '|' '<' '>' '?' ';' '+' '$']+ { WORD(Lexing.lexeme lexbuf) }
| '\n' { EOL }
| eof { EOF }

{

let tostring (n, m, l, k) =
  Printf.printf "%s|%s|%s|%s\n" n m l k

let _ =
  let ichan = open_in "messages" in
  let lb = Lexing.from_channel ichan in
  try
    let rec loop = function
    | [] -> ()
    | h :: t ->
      tostring h;
      loop t
    in
    loop (Syslog_parser.main tokens lb);
    close_in ichan
  with
  | Parsing.Parse_error
  | Failure(_) ->
      Printf.printf "Between %i and %i near '%s'"
        (Lexing.lexeme_start lb)
        (Lexing.lexeme_end lb)
        (Lexing.lexeme lb);
      close_in ichan;
      exit(1)

}
