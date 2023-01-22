rule tokens = parse
  ' ' { tokens lexbuf }
| "the" { tokens lexbuf }
| "and" { tokens lexbuf }
| "on" { tokens lexbuf }
| "a" { tokens lexbuf }
| ['\n' '\t']+ { tokens lexbuf }
| ['-']?['0' - '9']+ { tokens lexbuf }
| [':' ';' '{' '}' '(' ')' '[' ']' '|' '@' '#' '$' '%' '^' '&' '*' '|' '\\' '/' '?' '<' '>' ',' '.' '+' '=' '~' '`' '"' '\'']+ { tokens lexbuf }
| ['a'-'z' 'A'-'Z' '0'-'9' '_' '-']+ { Lexing.lexeme lexbuf }
| eof { raise End_of_file }
| _ { tokens lexbuf }

{
  module StringMap = Map.Make(String)

  let (goodmap, badmap) = try
    let ic = open_in (Filename.concat (Sys.getenv "HOME") ".spamdb") in
    let (g, b) = Marshal.from_channel ic in
    close ic;
    g, b
  with Sys_error n => StringMap.empty, StringMap.empty

  let goodcount = StringMap.fold (fun _ y z -> y + z) goodmap 0

  let badcount = StringMap.fold (fun _ y z -> y + z) badmap 0
}
