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
